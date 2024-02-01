const builtin = @import("builtin");

pub const TerminalQuirks = switch (builtin.os.tag) {
    .windows => @import("windows/TerminalQuirks.zig"),
    else => @import("termios/TerminalQuirks.zig"),
};
