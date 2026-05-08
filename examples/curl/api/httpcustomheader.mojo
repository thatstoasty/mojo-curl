# Converted from allexamples/httpcustomheader.c
# HTTP request with custom modified, removed and added headers

from mojo_curl import Easy, CurlList
from mojo_curl.c.types import Result


def main() raises:
    var easy = Easy()

    # Remove a header curl would otherwise add by itself (empty value = remove)
    # Add custom headers, modify existing ones, and blank-content headers
    var headers = CurlList({
        "Accept": "",           # Remove Accept header (empty value)
        "Another": "yes",       # Add a custom header
        "Host": "example.com",  # Override the Host header
    })

    # Add a header with blank content using a semicolon (no value after colon)
    # The CurlList constructor uses ";" suffix for empty values automatically
    # For CURLOPT_HTTPHEADER, "Header;" means a header with no value at all
    _ = easy.http_headers(headers)

    _ = easy.url("localhost")
    _ = easy.verbose(verbose=True)

    var result = easy.perform()
    if result != Result.OK:
        headers^.free()
        raise Error(easy.describe_error(result))

    headers^.free()
