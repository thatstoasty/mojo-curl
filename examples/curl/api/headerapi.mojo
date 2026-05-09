# Converted from allexamples/headerapi.c
# Extract response headers after a transfer using the header API

from std.ffi import c_char, c_size_t

from mojo_curl import Easy, Result
from mojo_curl.c.types import MutExternalPointer


def write_callback(
    data: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalPointer[NoneType],
) abi("C") -> c_size_t:
    # Discard the response body — we only care about headers in this example
    return size * nmemb


def main() raises:
    var easy = Easy()

    _ = easy.url("https://example.com")
    # Follow any redirect so we see the final response headers
    _ = easy.follow_location()
    # Suppress body output; all data goes to the discard callback
    _ = easy.write_function(write_callback)

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    # Retrieve all server response headers as a dict
    var hdrs = easy.headers()
    if "content-type" in hdrs:
        print(t"Got content-type: {hdrs["content-type"]}")

    print("All server headers:")
    for entry in hdrs.items():
        print(t" {entry.key}: {entry.value}")
