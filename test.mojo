from curl.c.bindings import curl, CURL_HTTP_VERSION_NONE, CURL_HTTP_VERSION_2_0, CURL_HTTP_VERSION_3, CURL_HTTP_VERSION_1_1, CURL_GLOBAL_DEFAULT, curl_write_callback
from curl.c.curl import CURLOPT, CURLINFO
from sys import stdout

fn write_callback(ptr: UnsafePointer[Int8], size: UInt, nmemb: UInt, userdata: UnsafePointer[NoneType]) -> UInt:
    var s = stdout
    print("write callback called with size:", size * nmemb)
    s.write(StringSlice(unsafe_from_utf8_ptr=ptr))
    return size * nmemb


fn main():
    var bindings = curl()
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
    
    var url: String = "https://example.com"
    print("url:", url)
    result = bindings.curl_easy_setopt_string(curl, CURLOPT.CURLOPT_URL.value, url)
    print("URL set Result:", result)

    # var effective_url = UnsafePointer[Int8]()
    # getinfo_result = bindings.curl_easy_getinfo(curl, CURLINFO.CURLINFO_EFFECTIVE_URL.value, effective_url.bitcast[NoneType]())
    # print("getinfo Result:", getinfo_result, getinfo_result == 0)
    # print("Effective URL:", StringSlice(unsafe_from_utf8_ptr=effective_url))
    # if getinfo_result == 0:
    #     print("Effective URL:", StringSlice(unsafe_from_utf8_ptr=effective_url))
    # else:
    #     print("Failed to get effective URL:", getinfo_result)
    #     bindings.curl_easy_cleanup(curl)
    #     bindings.curl_global_cleanup()
    #     return

    result = bindings.curl_easy_setopt_long(curl, CURLOPT.CURLOPT_HTTP_VERSION.value, CURL_HTTP_VERSION_NONE)
    if result != 0:
        print("curl_easy_setopt_long() failed:", StringSlice(unsafe_from_utf8_ptr=bindings.curl_easy_strerror(result)))
        bindings.curl_easy_cleanup(curl)
        bindings.curl_global_cleanup()
        return

    # Set the callback function to handle received data
    result = bindings.curl_easy_setopt_write_function(curl, CURLOPT.CURLOPT_WRITEFUNCTION.value, write_callback)
    print("callback Result:", result)

    # # Pass the address of our string buffer to the callback function
    # var read_buffer = UnsafePointer[Int8]()
    # result = bindings.curl_easy_setopt(curl, CURLOPT.CURLOPT_WRITEDATA.value, read_buffer.bitcast[NoneType]())
    # print("read buffer Result:", result)

    # var effective_url = UnsafePointer[Int8]()
    # getinfo_result = bindings.curl_easy_getinfo(curl, CURLINFO.CURLINFO_EFFECTIVE_URL.value, effective_url.bitcast[NoneType]())
    # print("getinfo Result:", getinfo_result)
    # if getinfo_result == 0:
    #     print("Effective URL:", StringSlice(unsafe_from_utf8_ptr=effective_url))
    # else:
    #     print("Failed to get effective URL:", getinfo_result)
    #     bindings.curl_easy_cleanup(curl)
    #     bindings.curl_global_cleanup()
    #     return

    # result = bindings.curl_easy_setopt_long(curl, CURLOPT.CURLOPT_SSL_VERIFYHOST.value, 0)
    # print("disable verify result Result:", result)

    # result = bindings.curl_easy_setopt_long(curl, CURLOPT.CURLOPT_CA_CACHE_TIMEOUT.value, 604800)
    # print("CA cache timeout Result:", result)

    # Perform the transfer. The response will be sent to standard output by default.
    res = bindings.curl_easy_perform(curl)

    # Check for errors.
    if res != 0:
      print("curl_easy_perform() failed:", StringSlice(unsafe_from_utf8_ptr=bindings.curl_easy_strerror(res)))

    bindings.curl_easy_cleanup(curl)
    bindings.curl_global_cleanup()
