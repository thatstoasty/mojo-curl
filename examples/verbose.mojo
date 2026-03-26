from mojo_curl import Easy
from mojo_curl.c.types import Result

fn main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/get")
    _ = easy.verbose(True)
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
