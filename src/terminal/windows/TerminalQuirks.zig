const std = @import("std");
const ansi = @import("../ansi.zig");

_consoleCP: UTF8ConsoleOutput = undefined,
_consoleMode: u32 = undefined,

const Self = @This();

const kernel32 = opaque {
    usingnamespace std.os.windows.kernel32;
    extern "kernel32" fn SetConsoleMode(*anyopaque, u32) callconv(std.os.windows.WINAPI) c_int;
};

const UTF8ConsoleOutput = struct {
    original: c_uint = undefined,

    const cp_utf8 = 65001;

    fn init() UTF8ConsoleOutput {
        const utf8_support = UTF8ConsoleOutput{ .original = kernel32.GetConsoleOutputCP() };
        _ = kernel32.SetConsoleOutputCP(65001);
        return utf8_support;
    }

    fn deinit(self: UTF8ConsoleOutput) void {
        if (self.original != undefined) {
            _ = std.os.windows.kernel32.SetConsoleOutputCP(self.original);
        }
    }
};

pub fn init() !Self {
    const ENABLE_VIRTUAL_TERMINAL_PROCESSING = 4;
    var consoleMode: u32 = 0;
    _ = kernel32.GetConsoleMode(std.io.getStdOut().handle, &consoleMode);
    _ = kernel32.SetConsoleMode(std.io.getStdOut().handle, consoleMode | ENABLE_VIRTUAL_TERMINAL_PROCESSING);
    const terminal = Self{ ._consoleCP = UTF8ConsoleOutput.init(), ._consoleMode = consoleMode };
    return terminal;
}

pub fn deinit(self: Self) void {
    //_ = self.write(ansi.style.ResetAll) catch unreachable;
    self._consoleCP.deinit();
    _ = kernel32.SetConsoleMode(std.io.getStdOut().handle, self._consoleMode);
}

fn write(_: *Self, comptime fmt: []const u8) !void {
    _ = try std.io.getStdOut().writer().print(fmt, .{});
}
