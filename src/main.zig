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

    const boo = ansi.style.FgBlue ++ "hello" ++ ansi.style.ResetAll;
    const red = ansi.style.BgRed ++ "world" ++ ansi.style.ResetAll;
    const green = ansi.style.FgGreen ++ "green" ++ ansi.style.ResetAll;

    try writer.print("{s}", .{green});
    try writer.print("{s}", .{boo});
    try writer.print("{s}", .{red});
    const color1 = .{ @intFromEnum(Terminal.FgColor.Black), @intFromEnum(Terminal.BgColor.White) };
    try Terminal.print(
        writer,
        "cool",
        .{},
        .{ 35, 43 },
    );
    try Terminal.print(
        writer,
        "really cool",
        .{},
        color1,
    );
}

test "simple test" {}
