const std = @import("std");
const print = std.debug.print;
const rl = @import("raylib");
const rg = @import("raygui");
const Gui = @import("gui.zig").Gui;
const editor = @import("editor.zig");

const pixelSize: i32 = 12;

var brushSize: i32 = 1;

const emptyColor = rl.Color.init(0, 0, 0, 0);
var mouseCell = rl.Vector2.init(0, 0);

pub fn main() anyerror!void {
    var screenWidth: i32 = 800;
    var screenHeight: i32 = 450;
    const gui = Gui.init();
    var pixels: [gui.grid.width * gui.grid.height]rl.Color = undefined;

    var i: usize = 0;
    while (i < gui.grid.width * gui.grid.height) : (i += 1) {
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
            editor.updatePixels(&pixels, &mouseCell, gui.state.colorPickerColor, brushSize);
        } else if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_right) and editor.isInGrid(&mouseCell)) {
            editor.updatePixels(&pixels, &mouseCell, emptyColor, brushSize);
        }

        if (editor.isInGrid(&mouseCell)) {
            editor.drawCursor(&mouseCell, brushSize, pixelSize);
        }

        editor.drawAllPixels(&pixels, pixelSize);
        rl.drawFPS(screenWidth - 100, 0);
    }
}
