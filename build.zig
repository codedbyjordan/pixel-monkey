const std = @import("std");
const rlz = @import("raylib-zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });

    const zigimg_dep = b.dependency("zigimg", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raygui = raylib_dep.module("raygui");
    const raylib_artifact = raylib_dep.artifact("raylib");

    //web exports are completely separate
    if (target.query.os_tag == .emscripten) {
        const exe_lib = rlz.emcc.compileForEmscripten(b, "pixel-monkey", "src/main.zig", target, optimize);

        exe_lib.linkLibrary(raylib_artifact);
        exe_lib.root_module.addImport("raylib", raylib);

        // Note that raylib itself is not actually added to the exe_lib output file, so it also needs to be linked with emscripten.
        const link_step = try rlz.emcc.linkWithEmscripten(b, &[_]*std.Build.Step.Compile{ exe_lib, raylib_artifact });

        b.getInstallStep().dependOn(&link_step.step);
        const run_step = try rlz.emcc.emscriptenRunStep(b);
        run_step.step.dependOn(&link_step.step);
        const run_option = b.step("run", "Run pixel-monkey");
        run_option.dependOn(&run_step.step);
        return;
    }

    const exe = b.addExecutable(.{ .name = "pixel-monkey", .root_source_file = b.path("src/main.zig"), .optimize = optimize, .target = target });

    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);
    exe.root_module.addImport("zigimg", zigimg_dep.module("zigimg"));

    const CFlags = &[_][]const u8{"-std=c99"};

    exe.addCSourceFile(.{
        .file = b.path("libs/nativefiledialog/src/nfd_common.c"),
        .flags = CFlags,
    });
    exe.addCSourceFile(.{
        .file = b.path("libs/nativefiledialog/src/nfd_gtk.c"),
        .flags = CFlags,
    });

    exe.addIncludePath(b.path("libs/nativefiledialog/src/include"));

    exe.linkLibC();
    exe.linkSystemLibrary("gtk+-3.0");

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run pixel-monkey");
    run_step.dependOn(&run_cmd.step);

    b.installArtifact(exe);
}
