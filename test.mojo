from curl.c.bindings import curl
from curl.c.curl import CURLOPT, CURL_GLOBAL_DEFAULT, CURLINFO, curl_write_callback
from sys import stdout

fn write_callback(ptr: UnsafePointer[Byte], size: UInt, nmemb: UInt, userdata: UnsafePointer[NoneType]) -> Int:
    var s = stdout
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
    
    var url = String("https://example.com")
    print("url:", url)
    result = bindings.curl_easy_setopt_string(curl, CURLOPT.CURLOPT_URL.value, url.unsafe_cstr_ptr())
    print("URL set Result:", result)

    # Set the callback function to handle received data
    result = bindings.curl_easy_setopt(curl, CURLOPT.CURLOPT_WRITEFUNCTION.value, UnsafePointer(to=write_callback).bitcast[NoneType]())
    print("callback Result:", result)

    # Pass the address of our string buffer to the callback function
    var read_buffer = UnsafePointer[Int8]()
    result = bindings.curl_easy_setopt(curl, CURLOPT.CURLOPT_WRITEDATA.value, read_buffer.bitcast[NoneType]())
    print("read buffer Result:", result)

    # var effective_url = UnsafePointer[Int8]()
    # res = curl.curl_easy_getinfo(easy, CURLINFO.CURLINFO_EFFECTIVE_URL.value, effective_url.bitcast[NoneType]())
    # if res == 0:
    #     print("Effective URL:", StringSlice(unsafe_from_utf8_ptr=effective_url))
    # else:
    #     print("Failed to get effective URL:", res)
    #     curl.curl_easy_cleanup(easy)
    #     curl.curl_global_cleanup()
    #     return
    result = bindings.curl_easy_setopt(curl, Int32(321), UnsafePointer(to=604800).bitcast[NoneType]())
    print("opt Result:", result)

    # Perform the transfer. The response will be sent to standard output by default.
    res = bindings.curl_easy_perform(curl)

    # Check for errors.
    if res != 0:
      print("curl_easy_perform() failed:", StringSlice(unsafe_from_utf8_ptr=bindings.curl_easy_strerror(res)))

    bindings.curl_easy_cleanup(curl)
    bindings.curl_global_cleanup()
