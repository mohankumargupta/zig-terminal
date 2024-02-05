const std = @import("std");
const Self = @This();
const ansi = @import("ansi.zig");
const ansiStyles = @import("styles.zig");
const FgColor = ansiStyles.FgColor;
const BgColor = ansiStyles.BgColor;
const FgPaletteColor = ansiStyles.FgPaletteColor;
const FgRGBColor = ansiStyles.FgRGBColor;
const BgPaletteColor = ansiStyles.BgPaletteColor;
const BgRGBColor = ansiStyles.BgRGBColor;
const builtin = @import("builtin");
const _getch = switch (builtin.os.tag) {
    .windows => @cImport(@cInclude("getch.h")),
    else => @cImport(@cInclude("getch.h")),
};

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
                    FgPaletteColor => {
                        const palette = @as(FgPaletteColor, styles[index]);
                        ansiescapecodes[styleCount] = 38;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = 5;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = palette.color;
                        styleCount += 1;
                    },
                    FgRGBColor => {
                        const rgb = @as(FgRGBColor, styles[index]);
                        ansiescapecodes[styleCount] = 38;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = 2;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = rgb.r;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = rgb.g;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = rgb.b;
                        styleCount += 1;
                    },
                    BgPaletteColor => {
                        const palette = @as(BgPaletteColor, styles[index]);
                        ansiescapecodes[styleCount] = 48;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = 5;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = palette.color;
                        styleCount += 1;
                    },
                    BgRGBColor => {
                        const rgb = @as(BgRGBColor, styles[index]);
                        ansiescapecodes[styleCount] = 48;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = 2;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = rgb.r;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = rgb.g;
                        styleCount += 1;
                        ansiescapecodes[styleCount] = rgb.b;
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
        try writer.print("\r\n", .{});
    }

    pub fn getch() void {
        const ch = switch (builtin.os.tag) {
            .windows => _getch.getch(),
            else => {},
        };
        const arrow: ArrowKeys = std.meta.intToEnum(ArrowKeys, ch) catch ArrowKeys.NOTARROW;
        std.log.info("{}", .{ch});
        std.log.info("{any}", .{arrow});
    }
};
