const std = @import("std");
const Terminal = @import("terminal.zig").Terminal;

pub fn main() !void {
    var terminal = Terminal{};
    terminal.init();
}

test "simple test" {}
