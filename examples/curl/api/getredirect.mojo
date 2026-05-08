# Converted from allexamples/getredirect.c
# Show how to extract Location: header and URL to redirect to.

from mojo_curl import Easy
from mojo_curl.c.types import Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://example.com")
    # Do not automatically follow the redirect; we want to inspect it

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    var response_code = easy.response_code()
    if (response_code // 100) != 3:
        # A redirect implies a 3xx response code
        print("Not a redirect.")
    else:
        # CURLINFO_REDIRECT_URL gives the absolute URL of the redirect target,
        # even when the server responded with a relative Location: header.
        var location = easy.redirect_url()
        print("Redirected to:", location)
