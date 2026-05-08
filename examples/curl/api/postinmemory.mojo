# Converted from allexamples/postinmemory.c
# Make an HTTP POST with data from memory and collect the response in memory

from std.ffi import c_char, c_size_t

from mojo_curl import Easy
from mojo_curl.c.types import MutExternalPointer, Result


def write_callback(
    contents: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalPointer[NoneType],
) abi("C") -> c_size_t:
    var realsize = size * nmemb
    var buf = userdata.bitcast[List[UInt8]]()
    for i in range(Int(realsize)):
        buf[].append(UInt8(Int(contents[i])))
    return realsize


def main() raises:
    var easy = Easy()
    var chunk = List[UInt8]()
    var postdata: String = "Field=1&Field=2&Field=3"

    _ = easy.url("https://www.example.org/")
    _ = easy.write_function(write_callback)
    _ = easy.write_data(UnsafePointer(to=chunk).bitcast[NoneType]())
    # Set POST data; postdata must remain alive through perform()
    _ = easy.post_fields(postdata.as_bytes())

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    print("Received", len(chunk), "bytes")
    print(String(unsafe_from_utf8=Span[UInt8](chunk)))
