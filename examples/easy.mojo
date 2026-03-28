from std.ffi import c_char, c_long, c_size_t

from mojo_curl.c.types import MutExternalOpaquePointer, MutExternalPointer, Option, Result
from mojo_curl.easy import Easy
from mojo_curl.list import CurlList


fn write_callback(ptr: MutExternalPointer[c_char], size: c_size_t, nmemb: c_size_t, userdata: MutExternalOpaquePointer) -> c_size_t:
    print("write callback called with size:", size * nmemb)
    print(StringSlice(unsafe_from_utf8_ptr=ptr))
    return size * nmemb


fn main() raises:
    var easy = Easy()

    # Set the url
    result = easy.url("https://google.com")
    print("URL set Result:", result)

    # Set the callback function to handle received data
    result = easy.write_function(write_callback)
    print("Write callback set result:", result)

    # set headers
    var list = CurlList({"User-Agent": "mojo-codecurl/1.0", "Accept": "application/json"})
    result = easy.http_headers(list)
    print("HTTP headers set result:", result)

    # Perform the transfer. The response will be sent to standard output by default.
    result = easy.perform()
    print("curl_easy_perform() result:", result)

    print("Response Headers:")
    var response_headers = easy.headers()
    for pair in response_headers.items():
        print(String(pair.key, ": ", pair.value))

    # Check for errors
    if result != Result.OK:
        print("curl_easy_perform() failed with error code:", result)
        list^.free()
        raise Error(easy.describe_error(result))
    else:
        print("Request completed successfully!")

    list^.free()
    easy.cleanup()
