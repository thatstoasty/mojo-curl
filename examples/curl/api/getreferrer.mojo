# Converted from allexamples/getreferrer.c
# Show how to extract the referrer header sent in a request.

from mojo_curl import Easy
from mojo_curl.c.types import Info, Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://example.com")
    # Set the Referer: header value to send in the request
    _ = easy.referer("https://example.org/referrer")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    # CURLINFO_REFERER returns the Referer: header actually sent in the request
    var hdr = easy.get_info(Info.REFERER)
    print("Referrer header:", hdr)
