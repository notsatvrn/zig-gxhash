const gxhash = @import("root.zig");
const std = @import("std");

const iterations = 10000000;
const size = 1024;

pub fn main() !void {
    var bytes: [size]u8 = [_]u8{0} ** size;
    try std.posix.getrandom(&bytes);

    const start = try std.time.Instant.now();

    for (0..iterations) |_| {
        //std.mem.doNotOptimizeAway(std.hash.Wyhash.hash(0, &bytes));
        std.mem.doNotOptimizeAway(gxhash.hash64(&bytes, 0));
    }

    const ns = (try std.time.Instant.now()).since(start);
    std.debug.print("took {d}ms | {d}MB/s\n", .{ ns / std.time.ns_per_ms, (iterations * size) / (ns / 1000) });
}
