"""SSL/TLS version configuration."""

from std.ffi import c_int


@fieldwise_init
struct SSLVersion(Copyable, TrivialRegisterPassable):
    """CURL SSL version options for setting SSL/TLS versions."""

    var value: c_int
    """Internal enum value."""

    comptime DEFAULT: Self = 0
    """Use the default SSL/TLS version. This is the default if you don't set any SSL version."""
    comptime TLSv1: Self = 1
    """Use TLSv1.0 or later."""
    comptime SSLv2: Self = 2
    """Use SSLv2. This is an old and insecure protocol and should not be used unless you have a very specific reason to do so."""
    comptime SSLv3: Self = 3
    """Use SSLv3. This is an old and insecure protocol and should not be used unless you have a very specific reason to do so."""
    comptime TLSv1_0: Self = 4
    """Use TLSv1.0."""
    comptime TLSv1_1: Self = 5
    """Use TLSv1.1."""
    comptime TLSv1_2: Self = 6
    """Use TLSv1.2."""
    comptime TLSv1_3: Self = 7
    """Use TLSv1.3."""

    @implicit
    def __init__(out self, value: Int):
        """Implicit conversion from Int to SSLVersion.

        Args:
            value: The integer value to convert to SSLVersion.
        """
        self.value = c_int(value)
