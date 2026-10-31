const std = @import("std");

const WIDTH: usize = 30;
const HEIGHT: usize = 15;

const Grid = [HEIGHT][WIDTH]bool;

fn emptyGrid() Grid {
    var g: Grid = undefined;
    for (0..HEIGHT) |y| {
        for (0..WIDTH) |x| {
            g[y][x] = false;
        }
    }
    return g;
}

fn placeGlider(g: *Grid, top: usize, left: usize) void {
    // Classic glider pattern
    const pattern = [_][2]usize{
        .{ 0, 1 }, .{ 1, 2 }, .{ 2, 0 }, .{ 2, 1 }, .{ 2, 2 },
    };
    for (pattern) |p| {
        const y = top + p[0];
        const x = left + p[1];
        if (y < HEIGHT and x < WIDTH) g[y][x] = true;
    }
}

fn countNeighbors(g: *const Grid, y: usize, x: usize) u8 {
    var count: u8 = 0;
    var dy: i32 = -1;
    while (dy <= 1) : (dy += 1) {
        var dx: i32 = -1;
        while (dx <= 1) : (dx += 1) {
            if (dy == 0 and dx == 0) continue;
            const ny = @as(i32, @intCast(y)) + dy;
            const nx = @as(i32, @intCast(x)) + dx;
            if (ny < 0 or ny >= @as(i32, @intCast(HEIGHT))) continue;
            if (nx < 0 or nx >= @as(i32, @intCast(WIDTH))) continue;
            if (g[@as(usize, @intCast(ny))][@as(usize, @intCast(nx))]) count += 1;
        }
    }
    return count;
}

fn step(g: *const Grid) Grid {
    var next = emptyGrid();
    for (0..HEIGHT) |y| {
        for (0..WIDTH) |x| {
            const n = countNeighbors(g, y, x);
            const alive = g[y][x];
            if (alive and (n == 2 or n == 3)) {
                next[y][x] = true;
            } else if (!alive and n == 3) {
                next[y][x] = true;
            }
        }
    }
    return next;
}

fn countAlive(g: *const Grid) u32 {
    var count: u32 = 0;
    for (0..HEIGHT) |y| {
        for (0..WIDTH) |x| {
            if (g[y][x]) count += 1;
        }
    }
    return count;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    var generations: u32 = 10;
    if (args.len > 1) {
        generations = std.fmt.parseInt(u32, args[1], 10) catch 10;
    }

    var buf: [0x1000]u8 = undefined;
    var w = std.Io.File.stdout().writer(io, &buf);
    const stdout = &w.interface;

    var grid = emptyGrid();
    placeGlider(&grid, 1, 1);

    var gen: u32 = 0;
    while (gen <= generations) : (gen += 1) {
        try stdout.print("Generation {d} (alive: {d})\n", .{ gen, countAlive(&grid) });
        for (0..HEIGHT) |y| {
            for (0..WIDTH) |x| {
                try stdout.print("{c}", .{if (grid[y][x]) @as(u8, '#') else @as(u8, '.')});
            }
            try stdout.print("\n", .{});
        }
        try stdout.print("\n", .{});
        grid = step(&grid);
    }
    try stdout.flush();
}
