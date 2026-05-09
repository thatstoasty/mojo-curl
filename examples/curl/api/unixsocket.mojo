# Converted from allexamples/unixsocket.c
# Access an HTTP server over a Unix domain socket

from mojo_curl import Easy, Option, Result


def main() raises:
    var easy = Easy()

    _ = easy.url("http://example.com")

    # Route the HTTP request through a local Unix domain socket instead of TCP.
    # The socket must already be listening at this path.
    var path: String = "/tmp/http-unix-domain"
    _ = easy.set_option(Option.UNIX_SOCKET_PATH, path.as_c_string_slice())

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
