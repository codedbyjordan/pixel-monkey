const rg = @import("raygui");
const rl = @import("raylib");
const images = @import("images.zig");

pub const gridWidth: usize = 32;
pub const gridHeight: usize = 32;

pub const gridOffsetX: i32 = 300;
pub const gridOffsetY: i32 = 10;

pub fn drawContainer(screenHeight: i32) void {
    _ = rg.guiPanel(rl.Rectangle{
        .x = 0,
        .y = 0,
        .width = 250,
        .height = @floatFromInt(screenHeight),
    }, "");
}

pub fn drawGrid(pixelSize: i32, mouseCell: *rl.Vector2) void {
    const gwAsInt: i32 = @intCast(gridWidth);
    const ghAsInt: i32 = @intCast(gridHeight);
    _ = rg.guiGrid(rl.Rectangle.init(gridOffsetX, gridOffsetY, @floatFromInt(gwAsInt * pixelSize), @floatFromInt(ghAsInt * pixelSize)), "Test", @floatFromInt(pixelSize), 1, mouseCell);
}

pub fn drawColorPicker(color: *rl.Color, screenHeight: i32) void {
    const colorPickerRect = rl.Rectangle{
        .x = 10,
        .y = @as(f32, @floatFromInt(screenHeight - 110)),
        .width = 100,
        .height = 100,
    };

    _ = rg.guiColorPicker(colorPickerRect, "Select color", color);
}

pub fn drawToolbar(pixels: *[gridWidth * gridHeight]rl.Color) !void {
    if (rg.guiButton(rl.Rectangle.init(12, 60, 50, 20), "Save") == 1) {
        try images.saveImage(pixels);
    }
}

pub fn drawBrushSizeSlider(brushSize: *f32) void {
    const brushSizeRect = rl.Rectangle{
        .x = 12,
        .y = 30,
        .width = 100,
        .height = 10,
    };

    _ = rg.guiSlider(brushSizeRect, "1", "10", brushSize, 1, 10);
}
