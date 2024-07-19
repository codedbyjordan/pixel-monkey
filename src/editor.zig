const std = @import("std");
const rl = @import("raylib");
const gui = @import("gui.zig");

const emptyColor = rl.Color.init(0, 0, 0, 0);

pub fn isInGrid(cell: *rl.Vector2) bool {
    return cell.*.x > -1 and cell.*.y > -1 and cell.*.x < @as(f32, @floatFromInt(gui.gridWidth)) and cell.*.y < @as(f32, @floatFromInt(gui.gridHeight));
}

pub fn updatePixels(pixels: *[gui.gridWidth * gui.gridHeight]rl.Color, start: *rl.Vector2, color: rl.Color, brushSize: i32) void {
    const brushSizeAsUsize: usize = @intCast(brushSize);
    for (0..brushSizeAsUsize) |i| {
        for (0..brushSizeAsUsize) |j| {
            const pixelsX: usize = @as(usize, @intFromFloat(start.x)) + i;
            const pixelsY: usize = @as(usize, @intFromFloat(start.y)) + j;

            var cellVector = rl.Vector2.init(@floatFromInt(pixelsX), @floatFromInt(pixelsY));

            if (isInGrid(&cellVector)) {
                pixels[pixelsY * gui.gridWidth + pixelsX] = color;
            }
        }
    }
}

pub fn drawAllPixels(pixels: *[gui.gridWidth * gui.gridHeight]rl.Color, pixelSize: i32) void {
    for (0..gui.gridWidth) |i| {
        for (0..gui.gridHeight) |j| {
            const x: i32 = @intCast(i);
            const y: i32 = @intCast(j);

            if (!std.meta.eql(pixels[j * gui.gridWidth + i], emptyColor)) {
                rl.drawRectangle(x * pixelSize + gui.gridOffsetX + 1, y * pixelSize + gui.gridOffsetY + 1, pixelSize - 1, pixelSize - 1, pixels[j * gui.gridWidth + i]);
            }
        }
    }
}

pub fn drawCursor(start: *rl.Vector2, brushSize: i32, pixelSize: i32) void {
    const brushSizeAsUsize: usize = @intCast(brushSize);
    for (0..brushSizeAsUsize) |i| {
        for (0..brushSizeAsUsize) |j| {
            const iAsInt: i32 = @intCast(i);
            const jAsInt: i32 = @intCast(j);
            const pixelX: i32 = @as(i32, @intFromFloat(start.x)) + iAsInt;
            const pixelY: i32 = @as(i32, @intFromFloat(start.y)) + jAsInt;

            var cellVector = rl.Vector2.init(@floatFromInt(pixelX), @floatFromInt(pixelY));

            if (isInGrid(&cellVector)) {
                rl.drawRectangle(pixelX * pixelSize + gui.gridOffsetX, pixelY * pixelSize + gui.gridOffsetY, pixelSize, pixelSize, rl.Color.init(255, 255, 255, 50));
            }
        }
    }
}
