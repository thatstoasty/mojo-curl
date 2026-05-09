# Converted from allexamples/getinfo.c
# Use curl_easy_getinfo to retrieve content-type after a completed transfer.

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://www.example.com/")
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    # Ask for the content-type of the received response
    print(t"We received Content-Type: {easy.content_type()}")
