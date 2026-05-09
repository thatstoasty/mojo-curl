# Converted from allexamples/maxconnects.c
# Set maximum number of persistent connections to 1 and loop over several URLs

from mojo_curl import Easy
from mojo_curl.result import Result


def main() raises:
    var easy = Easy()
    var urls = List[String]()
    urls.append("https://example.com/")
    urls.append("https://curl.se/")
    urls.append("https://www.example.com/")

    # Limit the connection cache to a single persistent connection
    _ = easy.max_connects(1)
    _ = easy.verbose(verbose=True)

    for i in range(len(urls)):
        _ = easy.url(urls[i])
        var result = easy.perform()
        if result != Result.OK:
            print("curl_easy_perform() failed:", easy.describe_error(result))
