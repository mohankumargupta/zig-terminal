const std = @import("std");
const term = @import("terminal/terminal.zig");
const TerminalQuirks = @import("terminal/terminal_quirks.zig").TerminalQuirks;
const Terminal = term.Terminal;
const FgColor = @import("terminal/styles.zig").FgColor;
const BgColor = @import("terminal/styles.zig").BgColor;
const FgPaletteColor = @import("terminal/styles.zig").FgPaletteColor;
const BgPaletteColor = @import("terminal/styles.zig").BgPaletteColor;
const Bold = @import("terminal/styles.zig").Bold;
//const ansi = @import("terminal/ansi.zig");
//const Color = ansi.color.Color;
//const FgColor = ansi.color.Fg;

pub fn main() !void {
    var terminalquirks = try TerminalQuirks.init();
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
    try writer.print("\r\n", .{});
    try Terminal.println(
        writer,
        "this is blue",
        .{},
        .{FgColor.Blue},
    );
    try Terminal.println(
        writer,
        "this is bold blue",
        .{},
        .{ Bold, FgColor.Blue },
    );
    try Terminal.println(
        writer,
        "this is pink",
        .{},
        .{FgPaletteColor{ .color = 200 }},
    );
    try Terminal.println(
        writer,
        "this is red with grey color",
        .{},
        .{
            BgPaletteColor{ .color = 245 },
            FgColor.Red,
        },
    );
    try writer.print("Enter a key to exit\r\n", .{});
    Terminal.getch();

    //windows key codes
    //down: 80, up: 72 left: 75 right: 77
}
