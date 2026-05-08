# Converted from allexamples/netrc.c
# Use credentials stored in a .netrc file

from mojo_curl import Easy
from mojo_curl.c.types import Option, Result


def main() raises:
    var easy = Easy()

    # CURL_NETRC_OPTIONAL = 1: use .netrc when available, fall back to URL creds
    _ = easy.netrc(1)

    # Override the default .netrc file path
    var netrc_path: String = "/home/daniel/s3cr3ts.txt"
    _ = easy.set_option(Option.NETRC_FILE, netrc_path.as_c_string_slice())

    _ = easy.url("https://curl.se/")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
