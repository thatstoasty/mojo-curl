# Converted from allexamples/http-post.c
# Simple HTTP POST using the easy interface

from mojo_curl import Easy
from mojo_curl.c.types import Result


def main() raises:
    var easy = Easy()

    # First set the URL that is about to receive our POST
    _ = easy.url("http://postit.example.com/moo.cgi")
    # Now specify the POST data
    _ = easy.post_fields("name=daniel&project=curl".as_bytes())

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
