const std = @import("std");
const Terminal = @import("terminal.zig").Terminal;

pub fn main() !void {
    var terminal = Terminal{ .in = std.io.getStdIn(), .out = std.io.getStdOut() };
    terminal.init();
    try terminal.write("\x1b[1;31mHello\x1b[0m");
    defer terminal.deinit();
}

test "simple test" {}
