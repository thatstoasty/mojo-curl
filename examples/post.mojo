from mojo_curl import Easy
from mojo_curl.c.types import Result

def main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/post")
    _ = easy.post_fields("field1=value1&field2=value2".as_bytes())

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
