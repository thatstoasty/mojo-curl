"""HTTP protocol version configuration."""

from std.ffi import c_long


@fieldwise_init
struct HTTPVersion(TrivialRegisterPassable):
    """CURL HTTP version options for setting HTTP versions."""

    var value: c_long
    """Internal enum value."""
    comptime NONE = Self(0)
    """Let libcurl decide which HTTP version to use based on the server's capabilities."""
    comptime V1_0 = Self(1)
    """Use HTTP/1.0. This is the default if you don't set any HTTP version and the URL doesn't start with `https://`."""
    comptime V1_1 = Self(2)
    """Use HTTP/1.1. This is the default if the URL starts with `https://`."""
    comptime V2_0 = Self(3)
    """Use HTTP/2.0. This requires libcurl to be built with HTTP/2 support."""
    comptime V2_TLS = Self(4)
    """Use HTTP/2.0, but only over TLS. This requires libcurl to be built with HTTP/2 support."""
    comptime V2_PRIOR_KNOWLEDGE = Self(5)
    """Use HTTP/2.0 with prior knowledge. This means that libcurl will attempt to use HTTP/2 without using HTTP/1.1 upgrade mechanism. This requires libcurl to be built with HTTP/2 support."""
    comptime V3 = Self(30)
    """Use HTTP/3. This requires libcurl to be built with HTTP/3 support."""
