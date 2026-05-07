from std.ffi import c_char, c_size_t

from mojo_curl import Easy
from mojo_curl.c.types import MutExternalPointer, Result

def write_callback(
    ptr: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalPointer[NoneType],
) abi("C") -> c_size_t:
    print(StringSlice(unsafe_from_utf8_ptr=ptr))
    return size * nmemb

def main() raises:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.write_function(write_callback)
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
