# Converted from allexamples/simple.c
# Simple HTTP GET

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://example.com")
    # example.com is redirected, so we tell libcurl to follow redirection
    _ = easy.follow_location(enable=True)

    # Perform the request; response is written to stdout by default
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
