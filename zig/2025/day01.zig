const std = @import("std");
const dir = std.Io.Dir.cwd();

pub const Instruction = struct {
    direction: u8,
    distance: i32,
};

pub fn rotate(current: *i32, instruction: *const Instruction) !i32 {
    switch (instruction.direction) {
        'R' => {
            return @mod(current.* + instruction.distance, 100);
        },
        'L' => {
            return @mod(current.* - instruction.distance, 100);
        },
        else => {
            return error.InvalidDirection;
        },
    }
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const file = try dir.openFile(io, "day01.txt", .{});
    defer file.close(io);

    var buf: [5]u8 = undefined;
    var reader = file.reader(io, &buf);

    var current: i32 = 50;
    var zeros: u16 = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        var instruction: Instruction = .{ .direction = line[0], .distance = try std.fmt.parseInt(i32, line[1..], 10) };
        current = try rotate(&current, &instruction);

        if (current == 0) {
            zeros = zeros + 1;
        }
    }

    std.log.info("{d}", .{zeros});
}
