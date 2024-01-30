const std = @import("std");
const term = @import("terminal/terminal.zig");
const TerminalQuirks = term.TerminalQuirks;
const Terminal = term.Terminal;
const ansi = @import("terminal/ansi.zig");
const Color = ansi.color.Color;
const FgColor = ansi.color.Fg;

pub fn main() !void {
    var terminalquirks = TerminalQuirks{};
    terminalquirks.init();
    defer terminalquirks.deinit();

    const writer = std.io.getStdOut().writer();

    //try Terminal.print(writer, "\x1b[34m√Hello\x1b[0", .{});
    //FgColor(Color.Blue, "Hello")

    const boo = ansi.style.FgBlue ++ "hello" ++ ansi.style.ResetFgColor;
    const red = ansi.style.BgRed ++ "world" ++ ansi.style.ResetBgColor;
    try writer.print("{s}", .{boo});
    try writer.print("{s}", .{red});
    //try Terminal.print(writer, "{s}", .{boo});
}

test "simple test" {}
