from sys.ffi import c_long
from curl.c.bindings import curl
from curl.c.api import get_curl_handle
from curl.c.types import CURL, Option, Result, Info, curl_write_callback


struct InnerEasy:
    var easy: CURL

    fn __init__(out self):
        self.easy = get_curl_handle()[].easy_init()
    
    fn set_option(
        self,
        option: Option,
        mut parameter: String
    ) -> Result:
        """Set a string option for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn set_option(
        self,
        option: Option,
        parameter: Int
    ) -> Result:
        """Set a long/integer option for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn set_option[origin: MutOrigin](
        self,
        option: Option,
        parameter: OpaqueMutPointer[origin]
    ) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn set_option(
        self,
        option: Option,
        parameter: curl_write_callback
    ) -> Result:
        """Set a callback function for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn get_info(
        self,
        info: Info,
    ) raises -> String:
        """Get string info from a curl easy handle using safe wrapper."""
        var response = String()
        var ptr = UnsafePointer(response.unsafe_cstr_ptr())
        var result = get_curl_handle()[].easy_getinfo(self.easy, info, ptr)
        if result.value != 0:
            raise Error("Failed to get info: ", self.describe_error(result))
        
        return response^

    fn get_info_long(
        self,
        info: Info,
    ) raises -> c_long:
        """Get long info from a curl easy handle using safe wrapper."""
        var response: c_long = 0
        var result = get_curl_handle()[].easy_getinfo(self.easy, info, response)
        if result.value != 0:
            raise Error("Failed to get info: ", self.describe_error(result))
        
        return response

    fn perform(self) -> Result:
        """Perform a blocking file transfer."""
        return get_curl_handle()[].easy_perform(self.easy)

    fn cleanup(self) -> NoneType:
        """End a libcurl easy handle."""
        return get_curl_handle()[].easy_cleanup(self.easy)

    fn describe_error(self, code: Result) -> StringSlice[ImmutAnyOrigin]:
        """Return string describing error code."""
        return StringSlice(unsafe_from_utf8_ptr=get_curl_handle()[].easy_strerror(code))
    