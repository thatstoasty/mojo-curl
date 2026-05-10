# Converted from allexamples/getinmemory.c
# Shows how the write callback function can be used to download data into a
# chunk of memory instead of storing it in a file.

from std.ffi import c_char, c_size_t

from mojo_curl import Easy, Result
from mojo_curl.c.types import MutExternalPointer


def write_callback(
    contents: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalPointer[NoneType],
) abi("C") -> c_size_t:
    var realsize = size * nmemb
    # Cast the userdata pointer back to our List[UInt8] buffer and append bytes
    var buf = userdata.bitcast[List[UInt8]]()
    buf[].extend(Span(ptr=contents.bitcast[UInt8](), length=Int(realsize)))
    return realsize


def main() raises:
    var easy = Easy()
    var chunk = List[UInt8]()

    _ = easy.url("https://www.example.com/")
    _ = easy.write_function(write_callback)
    # Pass a pointer to our buffer so the callback can append data into it
    _ = easy.write_data(UnsafePointer(to=chunk).bitcast[NoneType]())
    _ = easy.useragent("libcurl-agent/1.0")

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    print(t"Downloaded {len(chunk)} bytes")
    # Print the downloaded content as a string
    print(StringSlice(unsafe_from_utf8=Span(chunk)))
