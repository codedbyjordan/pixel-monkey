const rg = @import("raygui");
const rl = @import("raylib");
const images = @import("images.zig");
const openSaveDialog = @import("file-dialog.zig").openSaveDialog;
const std = @import("std");
const Color = @import("color.zig").Color;
const mouse = @import("mouse.zig");

pub const GuiState = struct { isBrushInputFocused: bool, showFileDropdown: bool, brushSize: i32, colorPickerColor: rl.Color };

pub const Grid = struct {
    width: usize,
    height: usize,
    offsetX: i32,
    offsetY: i32,

    pub fn isMouseInGrid(self: *Grid, cell: *rl.Vector2) bool {
        return cell.*.x > -1 and cell.*.y > -1 and cell.*.x < @as(f32, @floatFromInt(self.width)) and cell.*.y < @as(f32, @floatFromInt(self.height));
    }
};

pub const Gui = struct {
    state: GuiState,
    grid: Grid,

    pub fn init() Gui {
        return Gui{ .state = GuiState{ .isBrushInputFocused = false, .showFileDropdown = false, .brushSize = 1, .colorPickerColor = rl.Color.white }, .grid = Grid{ .width = 32, .height = 32, .offsetX = 250, .offsetY = 48 } };
    }

    pub fn drawGrid(self: *Gui, mouseCell: *rl.Vector2, pixelSize: i32) void {
        const gwAsInt: i32 = @intCast(self.grid.width);
        const ghAsInt: i32 = @intCast(self.grid.height);
        const rect = rl.Rectangle.init(@floatFromInt(self.grid.offsetX), @floatFromInt(self.grid.offsetY), @as(f32, @floatFromInt(gwAsInt * pixelSize)), @as(f32, @floatFromInt(ghAsInt * pixelSize)));
        _ = rg.guiGrid(rect, "", @as(f32, @floatFromInt(pixelSize)), 1, mouseCell);
    }

    pub fn drawMenubar(self: *Gui, pixels: *[]rl.Color) !void {
        rl.drawRectangle(0, 0, rl.getScreenWidth(), 32, Color.gray_400);
        if (rg.guiButton(rl.Rectangle.init(0, 0, 64, 32), "File") == 1) {
            self.state.showFileDropdown = !self.state.showFileDropdown;
        }

        if (self.state.showFileDropdown) {
            const saveBtnRect = rl.Rectangle.init(0, 32 - 2, 72, 32);
            if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left) and !mouse.isMouseClickInBounds(saveBtnRect)) {
                self.state.showFileDropdown = false;
            } else if (rg.guiButton(saveBtnRect, "Save") == 1) {
                const result = try openSaveDialog("png", null);
                if (result) |path| {
                    try images.saveImage(pixels, path, &self.grid);
                }
            }
        }
    }

    pub fn drawColorPicker(self: *Gui, color: *rl.Color) void {
        _ = self;
        const colorPickerRect = rl.Rectangle{
            .x = 10,
            .y = @as(f32, @floatFromInt(rl.getScreenHeight() - 110)),
            .width = 100,
            .height = 100,
        };

        _ = rg.guiColorPicker(colorPickerRect, "Select color", color);
    }

    pub fn drawBrushSizeInput(self: *Gui) void {
        const bounds = rl.Rectangle.init(52, 48, 64, 24);
        _ = rg.guiValueBox(bounds, "Brush size", &self.state.brushSize, 1, 10, self.state.isBrushInputFocused);
        if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left)) {
            if (mouse.isMouseClickInBounds(bounds)) {
                self.state.isBrushInputFocused = true;
            } else if (!mouse.isMouseClickInBounds(bounds)) {
                self.state.isBrushInputFocused = false;
            }
        }
    }
};

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
