# Converted from allexamples/connect-to.c
# Use CURLOPT_CONNECT_TO to physically connect to a different host than the URL

from mojo_curl import Easy, CurlList
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    # Each entry uses the format HOST:PORT:CONNECT-TO-HOST:CONNECT-TO-PORT
    # This connects to example.com:443 while the URL says curl.se:443.
    var host = CurlList()
    try:
        host.append("curl.se:443:example.com:443")
        _ = easy.connect_to(host)
    except e:
        host^.free()
        raise e^
    _ = easy.verbose()
    _ = easy.url("https://curl.se/")

    # The TLS certificate belongs to example.com, not curl.se — disable host
    # name verification so the connection succeeds despite the mismatch.
    _ = easy.ssl_verify_host(verify=False)

    var result = easy.perform()
    if result != Result.OK:
        host^.free()
        raise Error(easy.describe_error(result))

    host^.free()
