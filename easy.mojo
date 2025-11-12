from sys.ffi import c_char, c_long, c_size_t

from curl.c.types import ExternalImmutOpaquePointer, ExternalImmutPointer, Option, Result
from curl.easy import Easy
from memory import OpaqueMutPointer, UnsafeImmutPointer


fn write_callback(ptr: ExternalImmutPointer[c_char], size: c_size_t, nmemb: c_size_t, userdata: ExternalImmutOpaquePointer) -> c_size_t:
    print("write callback called with size:", size * nmemb)
    print(StringSlice(unsafe_from_utf8_ptr=ptr))
    return size * nmemb


fn main():
    var easy = Easy()

    # Set the url
    var url: String = "https://example.com"
    result = easy.url(url)
    print("URL set Result:", result)

    # Set the callback function to handle received data
    result = easy.write_function(write_callback)
    print("Write callback set result:", result)

    # Perform the transfer. The response will be sent to standard output by default.
    result = easy.perform()
    print("curl_easy_perform() result:", result)

    # Check for errors
    if result != Result.OK:
        print("curl_easy_perform() failed with error code:", result)
        print("Error message:", easy.describe_error(result))
    else:
        print("Request completed successfully!")

    easy.cleanup()
