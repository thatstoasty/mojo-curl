from std.ffi import c_long

@fieldwise_init
struct HTTPVersion(TrivialRegisterPassable):
    """CURL HTTP version options for setting HTTP versions."""

    var value: c_long
    comptime NONE = Self(0)
    comptime V1_0 = Self(1)
    comptime V1_1 = Self(2)
    comptime V2_0 = Self(3)
    comptime V2_TLS = Self(4)
    comptime V2_PRIOR_KNOWLEDGE = Self(5)
    comptime V3 = Self(30)
