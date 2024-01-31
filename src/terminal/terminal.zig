const std = @import("std");
const Self = @This();
const quirks = @import("TerminalQuirks.zig");
const ansi = @import("ansi.zig");
const ansiStyles = @import("styles.zig");
const FgColor = ansiStyles.FgColor;
const BgColor = ansiStyles.BgColor;
const c = @cImport(@cInclude("getch.h"));

pub const TerminalQuirks = quirks.TerminalQuirks;

const ArrowKeys = enum(c_int) { NOTARROW = 0, UP = 17, DOWN = 18, LEFT = 19, RIGHT = 20 };

pub const Terminal = struct {
    fn printAnsiEscapeCodes(writer: anytype, styles: []u8, stylesCount: usize) !void {
        try writer.print("{s}", .{ansi.escape.CSI});
        for (0..stylesCount) |index| {
            try writer.print("{}", .{styles[index]});
            if (index < stylesCount - 1) {
                try writer.print(";", .{});
            }
        }
        try writer.print("m", .{});
    }

    pub fn print(writer: anytype, comptime fmt: []const u8, args: anytype, styles: anytype) !void {
        const ArgsType = @TypeOf(styles);
        if (@typeInfo(ArgsType) == .Struct) {
            const fields_info = std.meta.fields(ArgsType);

            var styleCount: usize = 0;
            const maxStyleLength = 5;
            const length = fields_info.len * maxStyleLength;
            var ansiescapecodes: [length]u8 = undefined;

            inline for (0..fields_info.len) |index| {
                const field_type = fields_info[index];
                switch (field_type.type) {
                    FgColor, BgColor => {
                        ansiescapecodes[styleCount] = @intFromEnum(styles[index]);
                        styleCount += 1;
                    },
                    comptime_int => {
                        ansiescapecodes[styleCount] = styles[index];
                        styleCount += 1;
                    },
                    else => {},
                }
            }

            try printAnsiEscapeCodes(writer, &ansiescapecodes, styleCount);
            try writer.print(fmt, args);
            try writer.print("{s}", .{ansi.style.ResetAll});
        }
    }

    pub fn println(writer: anytype, comptime fmt: []const u8, args: anytype, styles: anytype) !void {
        try print(writer, fmt, args, styles);
        try writer.print("\n", .{});
    }

    pub fn getch() void {
        const ch = c.getch();
        const arrow: ArrowKeys = std.meta.intToEnum(ArrowKeys, ch) catch ArrowKeys.NOTARROW;
        std.log.info("{}", .{ch});
        std.log.info("{any}", .{arrow});
    }
};
