const std = @import("std");
const term = @import("terminal/terminal.zig");
const TerminalQuirks = term.TerminalQuirks;
const Terminal = term.Terminal;

pub fn main() !void {
    var terminalquirks = TerminalQuirks{};
    terminalquirks.init();
    defer terminalquirks.deinit();

    const writer = std.io.getStdOut().writer();
    try Terminal.write(writer, "\x1b[34m√Hello\x1b[0");
}

test "simple test" {}
