const std = @import("std");
const rl = @import("raylib");
const g = @import("gui.zig");
const Grid = g.Grid;
const Gui = g.Gui;
const Color = @import("color.zig").Color;

pub const Editor = struct {
    pub fn updatePixels(self: *Editor, pixels: *[]rl.Color, start: *rl.Vector2, color: rl.Color, gui: *Gui) void {
        _ = self;
        const brushSizeAsUsize: usize = @intCast(gui.state.brushSize);
        for (0..brushSizeAsUsize) |i| {
            for (0..brushSizeAsUsize) |j| {
                const pixelsX: usize = @as(usize, @intFromFloat(start.x)) + i;
                const pixelsY: usize = @as(usize, @intFromFloat(start.y)) + j;

                var cellVector = rl.Vector2.init(@floatFromInt(pixelsX), @floatFromInt(pixelsY));

                if (gui.grid.isMouseInGrid(&cellVector)) {
                    pixels.*[pixelsY * gui.grid.width + pixelsX] = color;
                }
            }
        }
    }

    pub fn drawAllPixels(self: *Editor, pixels: *[]rl.Color, pixelSize: i32, grid: *Grid) void {
        _ = self;
        for (0..grid.width) |i| {
            for (0..grid.height) |j| {
                const x: i32 = @intCast(i);
                const y: i32 = @intCast(j);

                if (!std.meta.eql(pixels.*[j * grid.width + i], Color.empty)) {
                    rl.drawRectangle(x * pixelSize + grid.offsetX + 1, y * pixelSize + grid.offsetY + 1, pixelSize - 1, pixelSize - 1, pixels.*[j * grid.width + i]);
                }
            }
        }
    }

    pub fn drawCursor(self: *Editor, start: *rl.Vector2, brushSize: i32, pixelSize: i32, grid: *Grid) void {
        _ = self;
        const brushSizeAsUsize: usize = @intCast(brushSize);
        for (0..brushSizeAsUsize) |i| {
            for (0..brushSizeAsUsize) |j| {
                const iAsInt: i32 = @intCast(i);
                const jAsInt: i32 = @intCast(j);
                const pixelX: i32 = @as(i32, @intFromFloat(start.x)) + iAsInt;
                const pixelY: i32 = @as(i32, @intFromFloat(start.y)) + jAsInt;

                var cellVector = rl.Vector2.init(@floatFromInt(pixelX), @floatFromInt(pixelY));

                if (grid.isMouseInGrid(&cellVector)) {
                    rl.drawRectangle(pixelX * pixelSize + grid.offsetX, pixelY * pixelSize + grid.offsetY, pixelSize, pixelSize, rl.Color.init(255, 255, 255, 50));
                }
            }
        }
    }
};
