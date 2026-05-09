# Converted from allexamples/ipv6.c
# HTTPS GET using IPv6 only

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    # CURL_IPRESOLVE_V6 = 2: restrict name resolves to IPv6 addresses only
    _ = easy.ip_resolve(2)

    _ = easy.url("https://curl.se/")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
