from sys.ffi import c_char, c_int, c_long

from curl.c.raw_bindings import _curl
from curl.c.types import ExternalImmutOpaquePointer, ExternalImmutPointer, CURL, Info, Result, Option, curl_write_callback


@fieldwise_init
struct curl:

    var lib: _curl

    fn __init__(out self):
        self.lib = _curl()
    
    # Global libcurl functions
    fn global_init(self, flags: c_long) -> Result:
        """Global libcurl initialization."""
        return self.lib.curl_global_init(flags)

    fn global_cleanup(self):
        """Global libcurl cleanup."""
        self.lib.curl_global_cleanup()

    fn version(self) -> StringSlice[ImmutAnyOrigin]:
        """Return the version string of libcurl."""
        return StringSlice(unsafe_from_utf8_ptr=self.lib.curl_version())

    # Easy interface functions
    fn easy_init(self) -> CURL:
        """Start a libcurl easy session."""
        return self.lib.curl_easy_init()

    fn easy_setopt(
        self,
        curl: ExternalImmutOpaquePointer,
        option: Option,
        mut parameter: String
    ) -> Result:
        """Set a string option for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_string(curl, option.value, parameter.unsafe_cstr_ptr())

    fn easy_setopt(
        self,
        curl: ExternalImmutOpaquePointer,
        option: Option,
        parameter: c_long
    ) -> Result:
        """Set a long/integer option for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_long(curl, option.value, parameter)

    fn easy_setopt[origin: MutOrigin](
        self,
        curl: ExternalImmutOpaquePointer,
        option: Option,
        parameter: OpaqueMutPointer[origin]
    ) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_pointer(curl, option.value, parameter)

    fn easy_setopt(
        self,
        curl: ExternalImmutOpaquePointer,
        option: Option,
        parameter: curl_write_callback
    ) -> Result:
        """Set a callback function for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_callback(curl, option.value, parameter)

    # Safe getinfo functions using wrapper
    fn easy_getinfo[origin: ImmutOrigin](
        self,
        curl: ExternalImmutOpaquePointer,
        info: Info,
        mut parameter: UnsafeImmutPointer[c_char, origin]
    ) -> Result:
        """Get string info from a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_getinfo_string(curl, info.value, UnsafePointer(to=parameter))

    fn easy_getinfo(
        self,
        curl: ExternalImmutOpaquePointer,
        info: Info,
        mut parameter: c_long,
    ) -> Result:
        """Get long info from a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_getinfo_long(curl, info.value, UnsafePointer(to=parameter))

    fn easy_perform(self, curl: ExternalImmutOpaquePointer) -> Result:
        """Perform a blocking file transfer."""
        return self.lib.curl_easy_perform(curl)

    fn easy_cleanup(self, curl: ExternalImmutOpaquePointer) -> NoneType:
        """End a libcurl easy handle."""
        return self.lib.curl_easy_cleanup(curl)

    fn easy_strerror(self, code: Result) -> ExternalImmutPointer[c_char]:
        """Return string describing error code."""
        return self.lib.curl_easy_strerror(code.value)
