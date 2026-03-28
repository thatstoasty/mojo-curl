from mojo_curl import Easy, CurlList
from mojo_curl.c.types import Result

fn main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/get")

    # Headers are passed as a dictionary
    var headers = CurlList({
        "User-Agent": "mojo-curl/1.0",
        "Accept": "application/json",
    })
    _ = easy.http_headers(headers)

    result = easy.perform()
    if result != Result.OK:
        headers^.free()
        raise Error(easy.describe_error(result))

    headers^.free()
