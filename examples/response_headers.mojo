from mojo_curl import Easy
from mojo_curl.c.types import Result

def main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    var response_headers = easy.headers()
    for pair in response_headers.items():
        print(String(pair.key, ": ", pair.value))
