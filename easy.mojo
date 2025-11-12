from curl.easy import InnerEasy
from curl.c.types import Option, Result, ExternalImmutPointer, ExternalImmutOpaquePointer
from sys.ffi import c_char, c_size_t, c_long
from memory import OpaqueMutPointer, UnsafeImmutPointer


fn write_callback(ptr: ExternalImmutPointer[c_char], size: c_size_t, nmemb: c_size_t, userdata: ExternalImmutOpaquePointer) -> c_size_t:
    print("write callback called with size:", size * nmemb)
    print(StringSlice(unsafe_from_utf8_ptr=ptr))
    return size * nmemb


fn main():
    var easy = InnerEasy()

    # Set the url
    var url: String = "https://example.com"
    result = easy.set_option(Option.URL, url)
    print("URL set Result:", result)

    # Set the callback function to handle received data
    result = easy.set_option(Option.WRITE_FUNCTION, write_callback)
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
