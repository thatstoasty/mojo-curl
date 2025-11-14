from sys.ffi import c_char, c_long, c_size_t

from curl.c.types import ExternalImmutOpaquePointer, ExternalImmutPointer, Option, Result
from curl.easy import Easy
from memory import OpaqueMutPointer, UnsafeImmutPointer
from curl.list import CurlList


fn write_callback(ptr: ExternalImmutPointer[c_char], size: c_size_t, nmemb: c_size_t, userdata: ExternalImmutOpaquePointer) -> c_size_t:
    print("write callback called with size:", size * nmemb)
    print(StringSlice(unsafe_from_utf8_ptr=ptr))
    return size * nmemb


# fn post_request():
#     var easy = Easy()

#     # Set the url
#     var url: String = "http://jsonplaceholder.typicode.com/todos"
#     var result = easy.url(url)
#     print("URL set Result:", result)

#     # Set the callback function to handle received data
#     result = easy.write_function(write_callback)
#     print("Write callback set result:", result)

#     # Set the POST data
#     var post_data: String = "field1=value1&field2=value2"
#     result = easy.post_fields(post_data)
#     print("POST fields set result:", result)

#     # Perform the transfer. The response will be sent to standard output by default.
#     result = easy.perform()
#     print("curl_easy_perform() result:", result)

#     # Check for errors
#     if result != Result.OK:
#         print("curl_easy_perform() failed with error code:", result)
#         print("Error message:", easy.describe_error(result))
#     else:
#         print("Request completed successfully!")

#     easy.cleanup()

fn main() raises:
    var easy = Easy()

    # Set the url
    var url: String = "https://example.com"
    result = easy.url(url)
    print("URL set Result:", result)

    # Set the callback function to handle received data
    result = easy.write_function(write_callback)
    print("Write callback set result:", result)

    # set headers
    var headers = {
        "User-Agent": "mojo-codecurl/1.0",
        "Accept": "application/json",
    }
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
