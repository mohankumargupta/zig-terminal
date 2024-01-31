const std = @import("std");
const term = @import("terminal/terminal.zig");
const TerminalQuirks = term.TerminalQuirks;
const Terminal = term.Terminal;
const FgColor = @import("terminal/styles.zig").FgColor;
const BgColor = @import("terminal/styles.zig").BgColor;
//const ansi = @import("terminal/ansi.zig");
//const Color = ansi.color.Color;
//const FgColor = ansi.color.Fg;

pub fn main() !void {
    var terminalquirks = TerminalQuirks{};
    terminalquirks.init();
    defer terminalquirks.deinit();

    const writer = std.io.getStdOut().writer();

    //try Terminal.print(writer, "\x1b[34m√Hello\x1b[0", .{});
    //FgColor(Color.Blue, "Hello")

    //const boo = ansi.style.FgBlue ++ "hello" ++ ansi.style.ResetAll;
    //const red = ansi.style.BgRed ++ "world" ++ ansi.style.ResetAll;
    //const green = ansi.style.FgGreen ++ "green" ++ ansi.style.ResetAll;

    //try writer.print("{s}", .{green});
    //try writer.print("{s}", .{boo});
    //try writer.print("{s}", .{red});

    const color1 = .{ FgColor.Magenta, BgColor.White };
    try Terminal.print(
        writer,
        "cool",
        .{},
        .{ 32, 43 },
    );
    try Terminal.print(
        writer,
        "really cool",
        .{},
        color1,
    );
    try writer.print("\n", .{});
    try Terminal.println(
        writer,
        "this is blue",
        .{},
        .{FgColor.Blue},
    );
    try writer.print("Enter a key to exit\n", .{});
    Terminal.getch();

    //windows key codes
    //down: 80, up: 72 left: 75 right: 77
}
