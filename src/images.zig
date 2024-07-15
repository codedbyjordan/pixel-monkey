const gui = @import("gui.zig");
const rl = @import("raylib");
const zigimg = @import("zigimg");
const GeneralPurposeAllocator = @import("std").heap.GeneralPurposeAllocator;

pub fn saveImage(pixels: *[gui.gridWidth][gui.gridHeight]rl.Color) !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var image = try zigimg.Image.create(allocator, gui.gridWidth, gui.gridHeight, .rgba32);
    defer image.deinit();
    switch (image.pixels) {
        .rgba32 => |data| {
            for (0..gui.gridHeight) |y| {
                for (0..gui.gridWidth) |x| {
                    const pixel = pixels[x][y];
                    const index = y * gui.gridWidth + x;
                    data[index] = zigimg.color.Rgba32.initRgba(pixel.r, pixel.g, pixel.b, pixel.a);
                }
            }
        },
        else => return error.UnsupportedPixelFormat,
    }
    const png_encoder_options = zigimg.png.PNG.EncoderOptions{};
    try image.writeToFilePath("test1.png", .{ .png = png_encoder_options });
}
