# Converted from allexamples/persistent.c
# Reuse a single handle for two requests, demonstrating HTTP persistent connections

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    _ = easy.verbose(verbose=True)
    _ = easy.show_header(show=True)

    # First request
    _ = easy.url("https://example.com/")
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    # Second request to the same server — libcurl reuses the existing connection
    _ = easy.url("https://example.com/docs/")
    result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
