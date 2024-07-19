const rg = @import("raygui");
const rl = @import("raylib");
const images = @import("images.zig");
const openSaveDialog = @import("file-dialog.zig").openSaveDialog;
const std = @import("std");
const Color = @import("color.zig").Color;
const mouse = @import("mouse.zig");

pub const gridWidth: usize = 32;
pub const gridHeight: usize = 32;

pub const gridOffsetX: i32 = 250;
pub const gridOffsetY: i32 = 48;

pub const GuiState = struct {
    isBrushInputFocused: bool,
    showFileDropdown: bool,
};

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

// fn drawIconButton(icon: rg.GuiIconName, pixelSize: i32, posX: i32, posY: i32, color: rl.Color) i32 {
//     const iconId: i32 = @intCast(@intFromEnum((icon)));

//     const mousePos = rl.getMousePosition();

//     const floatPosX: f32 = @floatFromInt(posX);
//     const floatPosY: f32 = @floatFromInt(posY);
//     const floatSize: f32 = @floatFromInt(pixelSize);

//     const inIconBounds = mousePos.x >= floatPosX and mousePos.y >= floatPosY and mousePos.x <= floatPosX + floatSize * 16 and mousePos.y <= floatPosY + floatSize * 16;

//     const iconColor = if (inIconBounds) rl.Color.gray else color;

//     _ = rg.guiDrawIcon(iconId, posX, posY, pixelSize, iconColor);

//     if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left) and inIconBounds) {
//         return 1;
//     }
//     return 0;
// }

pub fn drawMenubar(pixels: *[gridWidth * gridHeight]rl.Color, guiState: *GuiState) !void {
    rl.drawRectangle(0, 0, rl.getScreenWidth(), 32, Color.gray_400);
    if (rg.guiButton(rl.Rectangle.init(0, 0, 64, 32), "File") == 1) {
        guiState.showFileDropdown = !guiState.showFileDropdown;
    }

    if (guiState.showFileDropdown) {
        const saveBtnRect = rl.Rectangle.init(0, 32 - 2, 72, 32);
        if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left) and !mouse.isMouseClickInBounds(saveBtnRect)) {
            guiState.showFileDropdown = false;
        } else if (rg.guiButton(saveBtnRect, "Save") == 1) {
            const result = try openSaveDialog("png", null);
            if (result) |path| {
                try images.saveImage(pixels, path);
            }
        }
    }
}

pub fn drawBrushSizeInput(brushSize: *i32, guiState: *GuiState) void {
    const bounds = rl.Rectangle.init(4, 48, 64, 24);
    _ = rg.guiValueBox(bounds, "Brush size", brushSize, 1, 10, guiState.isBrushInputFocused);
    if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left)) {
        if (mouse.isMouseClickInBounds(bounds)) {
            guiState.isBrushInputFocused = true;
        } else if (!mouse.isMouseClickInBounds(bounds)) {
            guiState.isBrushInputFocused = false;
        }
    }
}
