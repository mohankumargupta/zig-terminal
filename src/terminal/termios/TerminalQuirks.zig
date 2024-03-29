const std = @import("std");
const os = std.os;

term: Term = undefined,

const Self = @This();

const Term = struct { old_termios: os.termios, new_termios: os.termios };

//https://github.com/Luukdegram/pit/blob/master/src/term.zig#L69-L90

pub fn init() !Self {
    std.log.info("linux", .{});
    const fd = std.io.getStdIn().handle;
    const original_termios = try os.tcgetattr(fd);

    var new_termios = original_termios;
    new_termios.iflag &= ~@as(os.tcflag_t, os.linux.BRKINT | os.linux.ICRNL | os.linux.INPCK | os.linux.ISTRIP | os.linux.IXON);
    new_termios.oflag &= ~@as(os.tcflag_t, os.linux.OPOST);
    new_termios.cflag |= @as(os.tcflag_t, os.linux.CS8);
    new_termios.lflag &= ~@as(os.tcflag_t, os.linux.ECHO | os.linux.ICANON | os.linux.IEXTEN | os.linux.ISIG);
    new_termios.cc[6] = 0; // VMIN
    new_termios.cc[5] = 1; // VTIME

    return Self{ .term = Term{ .old_termios = original_termios, .new_termios = new_termios } };
}

pub fn enableRawMode(self: Self) !void {
    const fd = std.io.getStdIn().handle;
    try os.tcsetattr(fd, .FLUSH, self.term.new_termios);
}

pub fn disableRawMode(self: Self) !void {
    const fd = std.io.getStdIn().handle;
    try os.tcsetattr(fd, .FLUSH, self.term.old_termios);
}

pub fn deinit(self: Self) !void {
    const handle = std.io.getStdIn().handle;
    os.tcsetattr(handle, .FLUSH, self.term.old_termios);
    std.io.getStdOut().write("\r\n");
}
