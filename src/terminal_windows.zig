const std = @import("std");

in: std.fs.File,
out: std.fs.File,
_consoleCP: *UTF8ConsoleOutput = undefined,
_consoleMode: u32 = 0,

const Self = @This();

const kernel32 = opaque {
    usingnamespace std.os.windows.kernel32;
    extern "kernel32" fn SetConsoleMode(*anyopaque, u32) callconv(std.os.windows.WINAPI) c_int;
};

const UTF8ConsoleOutput = struct {
    original: c_uint = undefined,

    const cp_utf8 = 65001;

    fn init(self: *UTF8ConsoleOutput) void {
        self.original = kernel32.GetConsoleOutputCP();
        _ = kernel32.SetConsoleOutputCP(cp_utf8);
    }

    fn deinit(self: *UTF8ConsoleOutput) void {
        if (self.original != undefined) {
            _ = std.os.windows.kernel32.SetConsoleOutputCP(self.original);
        }
    }
};

pub fn init(self: *Self) void {
    std.log.info("windows", .{});
    var utf8 = UTF8ConsoleOutput{};
    utf8.init();
    self._consoleCP = &utf8;
    const ENABLE_VIRTUAL_TERMINAL_PROCESSING = 4;
    _ = kernel32.GetConsoleMode(self.in.handle, &self._consoleMode);
    _ = kernel32.SetConsoleMode(self.out.handle, self._consoleMode | ENABLE_VIRTUAL_TERMINAL_PROCESSING);
}

pub fn deinit(self: *Self) void {
    self._consoleCP.deinit();
    _ = kernel32.SetConsoleMode(self.out.handle, self._consoleMode);
}

pub fn write(self: *Self, comptime fmt: []const u8) !void {
    _ = try self.out.write(fmt);
}
