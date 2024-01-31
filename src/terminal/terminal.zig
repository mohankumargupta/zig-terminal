const std = @import("std");
const Self = @This();
const quirks = @import("TerminalQuirks.zig");
const ansi = @import("ansi.zig");

pub const TerminalQuirks = quirks.TerminalQuirks;

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
                std.log.info("{any}", .{field_type.type});
                switch (field_type.type) {
                    FgColor, BgColor => {
                        std.log.info("{any}", .{@intFromEnum(styles[index])});
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

            std.log.info("{any} count: {}", .{ ansiescapecodes, styleCount });
            try printAnsiEscapeCodes(writer, &ansiescapecodes, styleCount);
            try writer.print(fmt, args);
            try writer.print("{s}", .{ansi.style.ResetAll});
        }
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

    pub const Ansi = blk: {
        const numFields = @typeInfo(FgColor).Enum.fields.len + @typeInfo(BgColor).Enum.fields.len;
        var fields: [numFields]std.builtin.Type.EnumField = undefined;

        var index = 0;
        for (@typeInfo(FgColor).Enum.fields) |field| {
            fields[index] = field;
            index += 1;
        }

        for (@typeInfo(BgColor).Enum.fields) |field| {
            fields[index] = field;
            index += 1;
        }

        const enumInfo = std.builtin.Type.Enum{
            .layout = std.builtin.Type.ContainerLayout.Auto,
            .tag_type = u8,
            .fields = &fields,
            .decls = &[0]std.builtin.Type.Declaration{},
            .is_exhaustive = true,
        };

        break :blk @Type(std.builtin.Type{ .Enum = enumInfo });
    };

    // pub const style = union(enum) {
    //     FgColor: FgColor,
    //     BgColor: BgColor,
    //     Fg256Color: u8,
    //     Bg256Color: u8,
    //     FgRGBColor: u24,
    //     BgRGBColor: u24,
    //     Bold: void,
    //     Italic: void,
    //     Underline: void,
    // };
};
