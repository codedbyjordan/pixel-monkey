const rl = @import("raylib");

pub fn isMouseClickInBounds(bounds: rl.Rectangle) bool {
    const mp = rl.getMousePosition();
    return rl.isMouseButtonDown(rl.MouseButton.mouse_button_left) and rl.checkCollisionPointRec(mp, bounds);
}
