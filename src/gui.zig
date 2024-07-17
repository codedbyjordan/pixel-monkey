const rg = @import("raygui");
const rl = @import("raylib");
const images = @import("images.zig");
const openFileDialog = @import("file-dialog.zig").openFileDialog;
const std = @import("std");

pub const gridWidth: usize = 32;
pub const gridHeight: usize = 32;

pub const gridOffsetX: i32 = 300;
pub const gridOffsetY: i32 = 10;

pub fn drawContainer(screenHeight: i32) void {
    _ = rl.drawRectangle(0, 0, 250, screenHeight, rl.Color.white);
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

fn drawIconButton(icon: rg.GuiIconName, pixelSize: i32, posX: i32, posY: i32, color: rl.Color) i32 {
    const iconId: i32 = @intCast(@intFromEnum((icon)));

    const mousePos = rl.getMousePosition();

    const floatPosX: f32 = @floatFromInt(posX);
    const floatPosY: f32 = @floatFromInt(posY);
    const floatSize: f32 = @floatFromInt(pixelSize);

    const inIconBounds = mousePos.x >= floatPosX and mousePos.y >= floatPosY and mousePos.x <= floatPosX + floatSize * 16 and mousePos.y <= floatPosY + floatSize * 16;

    const iconColor = if (inIconBounds) rl.Color.gray else color;

    _ = rg.guiDrawIcon(iconId, posX, posY, pixelSize, iconColor);

    if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left) and inIconBounds) {
        return 1;
    }
    return 0;
}

pub fn drawToolbar(pixels: *[gridWidth * gridHeight]rl.Color) !void {
    const toolbarX = 8;
    const toolbarY = 4;

    if (drawIconButton(rg.GuiIconName.icon_file_save, 1, toolbarX, toolbarY, rl.Color.black) == 1) {
        const result = try openFileDialog("png", null);
        if (result) |path| {
            try images.saveImage(pixels, path);
        }
    }
}

pub fn drawBrushSizeSlider(brushSize: *f32) void {
    const brushSizeRect = rl.Rectangle{
        .x = 12,
        .y = 50,
        .width = 100,
        .height = 10,
    };

    rl.drawText("Brush size", 12, 38, 4, rl.Color.black);
    _ = rg.guiSlider(brushSizeRect, "1", "10", brushSize, 1, 10);
}
