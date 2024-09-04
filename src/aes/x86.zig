const core = @import("../core.zig");
const State = core.State;

pub inline fn encrypt(data: State, keys: State) State {
    var out = data;
    asm (
        \\ aesenc %[k], %[out]
        : [out] "+x" (out),
        : [k] "x" (keys),
    );
    return out;
}

pub inline fn encryptLast(data: State, keys: State) State {
    var out = data;
    asm (
        \\ aesenclast %[k], %[out]
        : [out] "+x" (out),
        : [k] "x" (keys),
    );
    return out;
}
