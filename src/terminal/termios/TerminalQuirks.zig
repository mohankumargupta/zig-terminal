const std = @import("std");
const os = std.os;

term: Term = undefined,

const Self = @This();

const Term = struct { termios: os.termios };

//https://github.com/Luukdegram/pit/blob/master/src/term.zig#L69-L90

pub fn init() !Self {
    std.log.info("linux", .{});
    const fd = std.io.getStdIn().handle;
    const original_termios = try os.tcgetattr(fd);

    var new_termios = original_termios;
    new_termios.iflag &= ~@as(os.tcflag_t, os.BRKINT | os.ICRNL | os.INPCK | os.ISTRIP | os.IXON);
    new_termios.oflag &= ~@as(os.tcflag_t, os.OPOST);
    new_termios.cflag |= @as(os.tcflag_t, os.CS8);
    new_termios.lflag &= ~@as(os.tcflag_t, os.ECHO | os.ICANON | os.IEXTEN | os.ISIG);
    new_termios.cc[6] = 0; // VMIN
    new_termios.cc[5] = 1; // VTIME

    try os.tcsetattr(fd, .FLUSH, new_termios);

    const term_instance = Term{
        .termios = original_termios,
    };
    return term_instance; // autofix
}

pub fn deinit(self: Self) void {
    const handle = std.io.getStdIn().handle;
    os.tcsetattr(handle, .FLUSH, self.termios) catch {};
}
