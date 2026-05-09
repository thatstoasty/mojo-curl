# Converted from allexamples/keepalive.c
# Use the TCP keep-alive options

from std.ffi import c_long

from mojo_curl import Easy, Option, Result


def main() raises:
    var easy = Easy()

    # Enable TCP keep-alive for this transfer
    _ = easy.tcp_keepalive(enable=True)

    # Keep-alive idle time: 120 seconds before the first probe is sent
    _ = easy.tcp_keepidle(120)

    # Interval between keep-alive probes: 60 seconds
    _ = easy.tcp_keepintvl(60)

    # Maximum number of keep-alive probes before dropping the connection
    # (uses set_option directly since tcp_keepcnt has no dedicated wrapper)
    _ = easy.set_option(Option.TCP_KEEPCNT, c_long(3))

    _ = easy.url("https://curl.se/")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
