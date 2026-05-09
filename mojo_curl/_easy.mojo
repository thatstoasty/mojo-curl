from std.pathlib import Path
from std.ffi import c_long, c_char
from std.collections.string.string import CStringSlice

from mojo_curl.c import curl_ffi, curl, CURL
from mojo_curl.info import Info
from mojo_curl.option import Option
from mojo_curl.result import Result
from mojo_curl.c.types import MutExternalPointer, curl_slist, curl_write_callback, curl_read_callback, curl_header
from mojo_curl.header import HeaderOrigin


@explicit_destroy("The easy handle must be explicitly destroyed by calling `close()` to free resources.")
struct InnerEasy(Movable):
    """Represents a libcurl easy handle, which is used to perform individual transfers."""
    var easy: CURL
    """Internal external pointer to the libcurl easy handle."""

    def __init__(out self) raises:
        self.easy = curl_ffi()[].easy_init()

    def close(deinit self):
        curl_ffi()[].easy_cleanup(self.easy)

    def set_option(self, option: Option, parameter: CStringSlice) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option[origin: Origin, //](self, option: Option, parameter: Span[UInt8, origin]) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option(self, option: Option, parameter: c_long) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option[origin: ImmutOrigin, //](self, option: Option, parameter: Optional[OpaquePointer[origin]]) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option[origin: MutOrigin, //](self, option: Option, parameter: Optional[OpaquePointer[origin]]) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option(self, option: Option, parameter: curl_write_callback) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def get_info(self, info: Info) raises -> String:
        # Data is filled by data owned curl and must not be freed by the caller (this library) :)
        var data = MutExternalPointer[c_char].unsafe_dangling()
        var result = curl_ffi()[].easy_getinfo(self.easy, info, data)
        if result != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return String(StringSlice(unsafe_from_utf8_ptr=data))

    def get_info_long(self, info: Info) raises -> c_long:
        var response: c_long = 0
        var result = curl_ffi()[].easy_getinfo(self.easy, info, response)
        if result != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return response

    def get_info_float(self, info: Info) raises -> Float64:
        var response: Float64 = 0
        var result = curl_ffi()[].easy_getinfo(self.easy, info, response)
        if result != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return response

    def get_info_ptr[origin: MutOrigin, //](self, info: Info, mut ptr: MutOpaquePointer[origin]) raises:
        var result = curl_ffi()[].easy_getinfo(self.easy, info, ptr)
        if result != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

    def get_info_curl_slist(self, info: Info) raises -> CurlList:
        var list = CurlList()
        var result = curl_ffi()[].easy_getinfo(self.easy, info, list.data.value())
        if result != 0:
            list^.free()
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return list^

    def perform(self) -> Result:
        return curl_ffi()[].easy_perform(self.easy)

    def cleanup(self):
        curl_ffi()[].easy_cleanup(self.easy)

    def reset(self):
        curl_ffi()[].easy_reset(self.easy)

    def describe_error(self, code: Result) -> String:
        # TODO: StringSlice crashes, probably getting skill issued by
        # pointer lifetime. Theoretically StringSlice[ImmutAnyOrigin] should work.
        return String(unsafe_from_utf8_ptr=curl_ffi()[].easy_strerror(code.value))

    def headers(self, origin: HeaderOrigin) -> Dict[String, String]:
        var headers = Dict[String, String]()
        var prev: Optional[MutExternalPointer[curl_header]] = None

        while True:
            var h = curl_ffi()[].easy_nextheader(self.easy, origin.value, 0, prev)
            if not h:
                break
            prev = h
            headers[String(unsafe_from_utf8_ptr=h.value()[].name)] = String(unsafe_from_utf8_ptr=h.value()[].value)

        return headers^

    def escape(self, mut string: String) raises -> String:
        var data = curl_ffi()[].easy_escape(self.easy, string, 0)
        return String(unsafe_from_utf8_ptr=data)
