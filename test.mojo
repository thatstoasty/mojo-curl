from curl.c.safe_bindings import SafeCurl
from curl.c.curl import CURLOPT, CURLINFO
from curl.c.bindings import CURL_GLOBAL_DEFAULT
from sys import stdout
from sys.ffi import c_char, c_size_t
from memory import OpaquePointer

fn write_callback(ptr: UnsafePointer[c_char], size: c_size_t, nmemb: c_size_t, userdata: OpaquePointer) -> c_size_t:
    var s = stdout
    print("write callback called with size:", size * nmemb)
    s.write(StringSlice(unsafe_from_utf8_ptr=ptr.bitcast[Int8]()))
    return size * nmemb


fn main():
    var bindings = SafeCurl()
    var result = bindings.curl_global_init(CURL_GLOBAL_DEFAULT)
    print("init result", result)
    if result != 0:
        print("Failed to initialize curl:", result)
        return

    print(StringSlice(unsafe_from_utf8_ptr=bindings.curl_version()))

    var curl = bindings.curl_easy_init()
    if not curl:
        print("Failed to create curl easy handle")
        bindings.curl_global_cleanup()
        return
    
    # Now test the safe URL setting
    var url: String = "http://httpbin.org/get"
    print("Setting URL:", url)
    
    # Use the safe string setopt method
    result = bindings.curl_easy_setopt_string(curl, CURLOPT.CURLOPT_URL.value, url)
    print("URL set result:", result)
    
    if result != 0:
        print("Failed to set URL:", result)
        bindings.curl_easy_cleanup(curl)
        bindings.curl_global_cleanup()
        return
    
    # Set write callback
    result = bindings.curl_easy_setopt_callback(curl, CURLOPT.CURLOPT_WRITEFUNCTION.value, write_callback)
    print("Write callback set result:", result)
    
    # Perform the transfer
    print("Performing HTTP request...")
    res = bindings.curl_easy_perform(curl)
    print("curl_easy_perform() result:", res)

    # Check for errors
    if res != 0:
        print("curl_easy_perform() failed with error code:", res)
        print("Error message:", StringSlice(unsafe_from_utf8_ptr=bindings.curl_easy_strerror(res)))
    else:
        print("Request completed successfully!")

    bindings.curl_easy_cleanup(curl)
    bindings.curl_global_cleanup()
