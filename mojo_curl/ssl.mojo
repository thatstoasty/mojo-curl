from std.ffi import c_int

@fieldwise_init
struct SSLVersion(Copyable, TrivialRegisterPassable):
    """CURL SSL version options for setting SSL/TLS versions."""

    var value: c_int
    comptime DEFAULT: Self = 0
    comptime TLSv1: Self = 1
    comptime SSLv2: Self = 2
    comptime SSLv3: Self = 3
    comptime TLSv1_0: Self = 4
    comptime TLSv1_1: Self = 5
    comptime TLSv1_2: Self = 6
    comptime TLSv1_3: Self = 7

    @implicit
    def __init__(out self, value: Int):
        self.value = c_int(value)
