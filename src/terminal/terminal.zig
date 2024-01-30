const std = @import("std");
const Self = @This();
const quirks = @import("TerminalQuirks.zig");

pub const TerminalQuirks = quirks.TerminalQuirks;

pub const Terminal = struct {
    pub fn print(writer: anytype, comptime fmt: []const u8, args: anytype) !void {
        _ = try writer.print(fmt, args);
    }
};
