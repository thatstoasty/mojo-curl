# Converted from allexamples/https.c
# Simple HTTPS GET

from mojo_curl import Easy
from mojo_curl.c.types import Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://example.com/")

    # Uncomment to skip peer certificate verification (NOT recommended in
    # production — disabling this makes the connection insecure):
    # _ = easy.ssl_verify_peer(verify=False)

    # Uncomment to skip hostname verification (NOT recommended):
    # _ = easy.ssl_verify_host(verify=False)

    # Cache the CA cert bundle in memory for a week (604800 seconds)
    _ = easy.dns_cache_timeout(604800)

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
