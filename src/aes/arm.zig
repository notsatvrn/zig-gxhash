const core = @import("../core.zig");
const State = core.State;

pub inline fn encrypt(data: State, keys: State) State {
    return (asm (
        \\ mov   %[out].16b, %[in].16b
        \\ aese  %[out].16b, %[zero].16b
        \\ aesmc %[out].16b, %[out].16b
        : [out] "=&x" (-> State),
        : [in] "x" (data),
          [zero] "x" (core.empty),
    )) ^ keys;
}

pub inline fn encryptLast(data: State, keys: State) State {
    return (asm (
        \\ mov   %[out].16b, %[in].16b
        \\ aese  %[out].16b, %[zero].16b
        : [out] "=&x" (-> State),
        : [in] "x" (data),
          [zero] "x" (core.empty),
    )) ^ keys;
}
