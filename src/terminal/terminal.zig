const std = @import("std");
const Self = @This();
const quirks = @import("TerminalQuirks.zig");

pub const TerminalQuirks = quirks.TerminalQuirks;

pub const Terminal = struct {
    pub fn write(writer: anytype, comptime fmt: []const u8) !void {
        _ = try writer.print(fmt, .{});
    }
};
