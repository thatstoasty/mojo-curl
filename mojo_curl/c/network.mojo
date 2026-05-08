from std.ffi import c_ushort, c_char
from std.utils import StaticTuple

comptime sa_family_t = c_ushort
"""Address family type."""

struct sockaddr(TrivialRegisterPassable):
    """Struct representing a socket address."""
    var sa_family: sa_family_t
    """Address family (e.g., AF_INET for IPv4, AF_INET6 for IPv6)."""
    var sa_data: StaticTuple[c_char, 14]
    """Address data (14 bytes, typically used for storing the actual address and port)."""

    def __init__(
        out self,
        family: sa_family_t = 0,
        data: StaticTuple[c_char, 14] = StaticTuple[c_char, 14](),
    ):
        """Initializes a `sockaddr` struct with the given address family and data.
        
        Args:
            family: The address family (e.g., AF_INET for IPv4, AF_INET6 for IPv6).
            data: The address data (14 bytes, typically used for storing the actual address and port).
        """
        self.sa_family = family
        self.sa_data = data
