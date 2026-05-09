# Converted from allexamples/range.c
# GET only a byte range of an HTTP resource

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://curl.se/")
    # Request only bytes 200 through 999 of the resource
    _ = easy.range("200-999")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
