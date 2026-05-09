# Converted from allexamples/http-options.c
# Issue an HTTP OPTIONS request

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://example.com")
    # Issue an OPTIONS request instead of the default GET
    _ = easy.custom_request("OPTIONS")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
