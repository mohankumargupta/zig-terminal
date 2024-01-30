const builtin = @import("builtin");

pub const Terminal = switch (builtin.os.tag) {
    .windows => @import("terminal_windows.zig"),
    else => @import("terminal_linux.zig"),
};
