const std = @import("std");
const print = std.debug.print;
const rl = @import("raylib");
const rg = @import("raygui");
const Gui = @import("gui.zig").Gui;
const Color = @import("color.zig").Color;
const Editor = @import("editor.zig").Editor;

const pixelSize: i32 = 12;

var brushSize: i32 = 1;

var mouseCell = rl.Vector2.init(0, 0);

pub fn main() anyerror!void {
    var screenWidth: i32 = 800;
    var screenHeight: i32 = 450;
    var gui = Gui.init();

    var pixels: []rl.Color = undefined;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    pixels = try allocator.alloc(rl.Color, gui.grid.width * gui.grid.height);
    defer allocator.free(pixels);

    var i: usize = 0;
    while (i < gui.grid.width * gui.grid.height) : (i += 1) {
        pixels[i] = Color.empty;
    }

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var editor = Editor{};

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        screenWidth = rl.getScreenWidth();
        screenHeight = rl.getScreenHeight();

        if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left) and gui.grid.isMouseInGrid(&mouseCell)) {
            editor.updatePixels(&pixels, &mouseCell, gui.state.colorPickerColor, &gui);
        } else if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_right) and gui.grid.isMouseInGrid(&mouseCell)) {
            editor.updatePixels(&pixels, &mouseCell, Color.empty, &gui);
        }

        if (gui.grid.isMouseInGrid(&mouseCell)) {
            editor.drawCursor(&mouseCell, gui.state.brushSize, pixelSize, &gui.grid);
        }

        gui.drawBrushSizeInput();
        gui.drawGrid(&mouseCell, pixelSize);
        gui.drawColorPicker(&gui.state.colorPickerColor);
        try gui.drawMenubar(&pixels);
        editor.drawAllPixels(&pixels, pixelSize, &gui.grid);
        rl.drawFPS(screenWidth - 100, 0);
    }
}
