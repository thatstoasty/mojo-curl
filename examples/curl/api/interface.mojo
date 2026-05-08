# Converted from allexamples/interface.c
# Use CURLOPT_INTERFACE to bind the outgoing socket to a specific interface

from mojo_curl import Easy
from mojo_curl.c.types import Result


def main() raises:
    var easy = Easy()

    # Bind the outgoing socket to a local network interface by name, IP, or
    # hostname. Replace "enp3s0" with an interface that exists on your system.
    _ = easy.interface("enp3s0")

    _ = easy.url("https://curl.se/")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
