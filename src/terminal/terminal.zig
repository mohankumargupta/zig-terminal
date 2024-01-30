const std = @import("std");
const Self = @This();
const quirks = @import("TerminalQuirks.zig");
const ansi = @import("ansi.zig");

pub const TerminalQuirks = quirks.TerminalQuirks;

pub const Terminal = struct {
    pub fn print(writer: anytype, comptime fmt: []const u8, _args: anytype, styles: anytype) !void {
        _ = _args; // autofix

        const result = comptime ansi.csi.SGR(styles) ++ fmt ++ ansi.style.ResetAll;

        _ = try writer.print("{s}", .{result});
    }

    pub const FgColor = enum(u8) {
        Black = 30,
        Red = 31,
        Green = 32,
        Yellow = 33,
        Blue = 34,
        Magenta = 35,
        Cyan = 36,
        White = 37,
    };

    pub const BgColor = enum(u8) {
        Black = 40,
        Red = 41,
        Green = 42,
        Yellow = 43,
        Blue = 44,
        Magenta = 45,
        Cyan = 46,
        White = 47,
    };

    pub const style = union(enum) {
        FgColor: FgColor,
        BgColor: BgColor,
        Fg256Color: u8,
        Bg256Color: u8,
        FgRGBColor: u24,
        BgRGBColor: u24,
        Bold: void,
        Italic: void,
        Underline: void,
    };
};
