const builtin = @import("builtin");

pub const TerminalQuirks = switch (builtin.os.tag) {
    .windows => @import("terminal_windows.zig"),
    else => @import("terminal_linux.zig"),
};
