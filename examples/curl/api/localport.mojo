# Converted from allexamples/localport.c
# Use CURLOPT_LOCALPORT to control the outgoing local port number

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    # Try to use a local port number between 20000–20009
    _ = easy.set_local_port(20000)
    # Number of consecutive port numbers to try if 20000 is unavailable
    _ = easy.local_port_range(10)

    _ = easy.url("https://curl.se/")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
