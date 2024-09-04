const std = @import("std");

const core = @import("../core.zig");
const avx = @import("x86_avx.zig");

const State = core.State;

pub const encrypt = avx.encrypt;
pub const encryptLast = avx.encryptLast;

// 256-bit state for hybrid

const i8x32 = @Vector(32, i8);
const i32x8 = @Vector(8, i32);
const i64x4 = @Vector(4, i64);

const State256 = packed union {
    const Self = @This();

    i8x32: i8x32,
    i32x8: i32x8,
    i64x4: i64x4,

    u256: u256,

    pub const empty = Self{ .u256 = 0 };

    pub inline fn init128x2(s1: State, s2: State) Self {
        return .{ .i64x4 = @shuffle(i64, s1.i64x2, s2.i64x2, .{ 0, 1, -1, -2 }) };
    }

    pub inline fn manualOut128(self: Self) struct { State, State } {
        const s1 = State{ .i64x2 = .{ self.i64x4[0], self.i64x4[1] } };
        const s2 = State{ .i64x2 = .{ self.i64x4[2], self.i64x4[3] } };
        return .{ s1, s2 };
    }

    pub inline fn shuffleOut128(self: Self) struct { State, State } {
        const s1 = State{ .i64x2 = @shuffle(i64, self, self, .{ 0, 1 }) };
        const s2 = State{ .i64x2 = @shuffle(i64, self, self, .{ 2, 3 }) };
        return .{ s1, s2 };
    }

    pub inline fn extractOut128(self: Self) struct { State, State } {
        const s1 = asm (
            \\ vextracti128 %[o] %[in] %[out]
            : [out] "=x" (-> State),
            : [in] "x" (self),
              [o] "N" (0),
        );
        const s2 = asm (
            \\ vextracti128 %[o] %[in] %[out]
            : [out] "=x" (-> State),
            : [in] "x" (self),
              [o] "N" (1),
        );
        return .{ s1, s2 };
    }
};

comptime {
    std.debug.assert(@sizeOf(State256) == 32);
    std.debug.assert(@alignOf(State256) == 32);
}

// 256-bit encryption

inline fn encrypt256(data: State256, keys: State256) State256 {
    return asm (
        \\ vaesenc %[k], %[in], %[out]
        : [out] "=x" (-> State256),
        : [in] "x" (data),
          [k] "x" (keys),
    );
}

inline fn encryptLast256(data: State256, keys: State256) State256 {
    return asm (
        \\ vaesenclast %[k], %[in], %[out]
        : [out] "=x" (-> State256),
        : [in] "x" (data),
          [k] "x" (keys),
    );
}

// 256-bit compression

const key = State256.init128x2(core.keys[0], core.keys[1]);

pub inline fn compress8(pointer: [*]const i8, end: usize, hash_vector: State, len: usize) State {
    var ptr = pointer;
    var t = State256.empty;
    var lane = State256.init128x2(hash_vector, hash_vector);

    while (@intFromPtr(ptr) < end) : (ptr += 128) {
        var tmp = encrypt256(.{ .i64x4 = ptr[0..32].* }, .{ .i64x4 = ptr[32..64].* });
        tmp = encrypt256(tmp, .{ .i64x4 = ptr[64..96].* });
        tmp = encrypt256(tmp, .{ .i64x4 = ptr[96..128].* });

        @prefetch(ptr + 128, .{});

        t.i8x32 +%= key.i8x32;

        lane = encryptLast256(encrypt256(tmp, t), lane);
    }

    // Extract the two 128-bit lanes
    var lane1 = State{ .i64x2 = .{ lane.i64x4[0], lane.i64x4[1] } };
    var lane2 = State{ .i64x2 = .{ lane.i64x4[2], lane.i64x4[3] } };
    // For 'Zeroes' test
    const len_vec = (State{ .i32x4 = @splat(@intCast(len)) }).i8x16;
    lane1.i8x16 +%= len_vec;
    lane2.i8x16 +%= len_vec;
    // Merge lanes
    return encrypt(lane1, lane2);
}
