const std = @import("std");

in: std.fs.File = undefined,
out: std.fs.File = undefined,
_console: *UTF8ConsoleOutput = undefined,

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
    self._console = &utf8;
}

pub fn deinit(self: *Self) void {
    self._console.deinit();
}
