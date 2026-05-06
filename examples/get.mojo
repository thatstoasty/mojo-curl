from mojo_curl import Easy
from mojo_curl.c.types import Result

def main() raises:
    var easy = Easy()

    # # Set the URL to request
    # _ = easy.url("https://httpbin.org/get")

    # # Perform the request (response goes to stdout by default)
    # var result = easy.perform()
    # if result != Result.OK:
    #     raise Error(easy.describe_error(result))
