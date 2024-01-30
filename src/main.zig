const std = @import("std");
const Terminal = @import("terminal/terminal.zig").Terminal;

pub fn main() !void {
    var terminal = Terminal{};
    terminal.init();
    try terminal.write("\x1b[34m√Hello\x1b[0");
    defer terminal.deinit() catch unreachable;
}

test "simple test" {}
