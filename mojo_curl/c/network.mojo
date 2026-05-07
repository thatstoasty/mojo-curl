from std.ffi import c_ushort, c_char
from std.utils import StaticTuple

comptime sa_family_t = c_ushort
"""Address family type."""

struct sockaddr(TrivialRegisterPassable):
    var sa_family: sa_family_t
    var sa_data: StaticTuple[c_char, 14]

    def __init__(
        out self,
        family: sa_family_t = 0,
        data: StaticTuple[c_char, 14] = StaticTuple[c_char, 14](),
    ):
        self.sa_family = family
        self.sa_data = data
