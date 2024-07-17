const std = @import("std");
const print = std.debug.print;
const rl = @import("raylib");
const rg = @import("raygui");
const gui = @import("gui.zig");
const editor = @import("editor.zig");

const pixelSize: i32 = 12;

var brushSize: f32 = 1;

const emptyColor = rl.Color.init(0, 0, 0, 0);
var mouseCell = rl.Vector2.init(0, 0);

pub fn main() anyerror!void {
    var screenWidth: i32 = 800;
    var screenHeight: i32 = 450;

    var colorPickerColor = rl.Color.red;
    var pixels: [gui.gridWidth * gui.gridHeight]rl.Color = undefined;

    var i: usize = 0;
    while (i < gui.gridWidth * gui.gridHeight) : (i += 1) {
        pixels[i] = emptyColor;
    }

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        screenWidth = rl.getScreenWidth();
        screenHeight = rl.getScreenHeight();

        if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left) and editor.isInGrid(&mouseCell)) {
            editor.updatePixels(&pixels, &mouseCell, colorPickerColor, brushSize);
        } else if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_right) and editor.isInGrid(&mouseCell)) {
            editor.updatePixels(&pixels, &mouseCell, emptyColor, brushSize);
        }

        if (editor.isInGrid(&mouseCell)) {
            editor.drawCursor(&mouseCell, brushSize, pixelSize);
        }

        editor.drawAllPixels(&pixels, pixelSize);

        gui.drawContainer(screenHeight);
        gui.drawBrushSizeSlider(&brushSize);
        gui.drawColorPicker(&colorPickerColor, screenHeight);
        try gui.drawToolbar(&pixels);
        gui.drawGrid(pixelSize, &mouseCell);
        rl.drawFPS(screenWidth - 100, 0);
    }
}
