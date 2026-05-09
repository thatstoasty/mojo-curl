# Converted from allexamples/simplepost.c
# Simple HTTP POST

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()
    var postdata: String = "moo mooo moo moo"

    _ = easy.url("https://example.com")
    # Set the POST data; libcurl does not copy, so postdata must remain alive
    _ = easy.post_fields(postdata.as_bytes())
    # Tell libcurl the size explicitly (optional when using post_fields)
    _ = easy.post_field_size(postdata.byte_length())

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
