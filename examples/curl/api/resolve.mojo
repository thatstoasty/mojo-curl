# Converted from allexamples/resolve.c
# Use CURLOPT_RESOLVE to provide custom IP addresses for hostname:port pairs

from mojo_curl import Easy, CurlList
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()

    # Each entry uses the format HOST:PORT:ADDRESS
    # This routes example.com:443 to 127.0.0.1 instead of the real DNS result.
    var hosts = CurlList()
    var entry: String = "example.com:443:127.0.0.1"
    try:
        hosts.append(entry.as_c_string_slice())
        _ = easy.resolve(hosts)
    except e:
        hosts^.free()
        raise e^
    _ = easy.url("https://example.com")

    var result = easy.perform()
    if result != Result.OK:
        hosts^.free()
        raise Error(easy.describe_error(result))

    hosts^.free()
