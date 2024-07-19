const Grid = @import("gui.zig").Grid;
const rl = @import("raylib");
const zigimg = @import("zigimg");
const GeneralPurposeAllocator = @import("std").heap.GeneralPurposeAllocator;

pub fn saveImage(pixels: *[]rl.Color, filePath: []const u8, grid: *Grid) !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var image = try zigimg.Image.create(allocator, grid.width, grid.height, .rgba32);
    defer image.deinit();
    switch (image.pixels) {
        .rgba32 => |data| {
            for (0..grid.height) |y| {
                for (0..grid.width) |x| {
                    const index = y * grid.width + x;
                    const pixel = pixels.*[index];
                    data[index] = zigimg.color.Rgba32.initRgba(pixel.r, pixel.g, pixel.b, pixel.a);
                }
            }
        },
        else => return error.UnsupportedPixelFormat,
    }
    const png_encoder_options = zigimg.png.PNG.EncoderOptions{};
    try image.writeToFilePath(filePath, .{ .png = png_encoder_options });
}
