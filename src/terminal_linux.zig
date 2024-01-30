const std = @import("std");

in: std.fs.File = undefined,
out: std.fs.File = undefined,

const Self = @This();

pub fn init(_: Self) void {
    std.log.info("linux", .{});
}

pub fn deinit(_: Self) void {}
