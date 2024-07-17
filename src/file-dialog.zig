// binding ripped from https://github.com/fabioarnold/nfd-zig/blob/master/src/lib.zig
const std = @import("std");
const c = @cImport({
    @cInclude("nfd.h");
    @cInclude("stdlib.h");
});

pub fn openSaveDialog(filter: ?[:0]const u8, default_path: ?[:0]const u8) !?[:0]const u8 {
    var out_path: [*c]u8 = null;

    const result = c.NFD_SaveDialog(if (filter != null) filter.? else null, if (default_path != null) default_path.? else null, &out_path);

    return switch (result) {
        c.NFD_OKAY => if (out_path == null) null else std.mem.sliceTo(out_path, 0),
        c.NFD_ERROR => return error.NFDError,
        else => null,
    };
}
