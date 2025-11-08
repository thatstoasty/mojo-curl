import os
import pathlib
from sys import ffi, env_get_string, CompilationTarget
from sys.ffi import DLHandle, c_char, c_int, c_uint, c_size_t, c_long

from memory import OpaquePointer, UnsafePointer

# Type aliases for curl
alias CURL = OpaquePointer
alias CURLcode = c_int
alias CURLoption = c_int
alias CURLINFO = c_int

# Callback function types
alias curl_write_callback = fn (UnsafePointer[c_char], c_size_t, c_size_t, OpaquePointer) -> c_size_t

@fieldwise_init
struct SafeCurl(Copyable, Movable):
    """Safe CURL Easy interface that uses wrapper functions to avoid variadic FFI issues."""

    var curl_lib: DLHandle
    var wrapper_lib: DLHandle

    fn __init__(out self):
        """Initialize the Safe CURL binding by loading both libraries."""
        var curl_path = String(env_get_string["LIBCURL_LIB_PATH", ""]())
        var wrapper_path = String("curl/c/libcurl_wrapper.dylib")

        # Load curl library
        if curl_path == "":
            curl_path = os.getenv("LIBCURL_LIB_PATH")

        try:
            if curl_path == "":
                @parameter
                if CompilationTarget.is_macos():
                    curl_path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.dylib")
                else:
                    curl_path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.so")

            if not pathlib.Path(curl_path).exists():
                os.abort("libcurl library not found at: " + curl_path)
            
            if not pathlib.Path(wrapper_path).exists():
                os.abort("curl wrapper library not found at: " + wrapper_path)

            self.curl_lib = ffi.DLHandle(curl_path, ffi.RTLD.LAZY)
            self.wrapper_lib = ffi.DLHandle(wrapper_path, ffi.RTLD.LAZY)
        except e:
            self.curl_lib = os.abort[ffi.DLHandle](String("Failed to load libraries: ", e))
            self.wrapper_lib = os.abort[ffi.DLHandle](String("Failed to load libraries: ", e))

    # Global libcurl functions
    fn curl_global_init(self, flags: c_long) -> CURLcode:
        """Global libcurl initialization."""
        return self.curl_lib.get_function[fn (c_long) -> CURLcode]("curl_global_init")(flags)

    fn curl_global_cleanup(self) -> NoneType:
        """Global libcurl cleanup."""
        return self.curl_lib.get_function[fn () -> NoneType]("curl_global_cleanup")()

    fn curl_version(self) -> UnsafePointer[c_char]:
        """Return the version string of libcurl."""
        return self.curl_lib.get_function[fn () -> UnsafePointer[c_char]]("curl_version")()

    # Easy interface functions
    fn curl_easy_init(self) -> CURL:
        """Start a libcurl easy session."""
        return self.curl_lib.get_function[fn () -> CURL]("curl_easy_init")()

    # Safe setopt functions using wrapper
    fn curl_easy_setopt_string(self, curl: CURL, option: CURLoption, mut parameter: String) -> CURLcode:
        """Set a string option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (CURL, CURLoption, UnsafePointer[c_char, mut=False]) -> CURLcode
        ]("curl_easy_setopt_string_wrapper")(curl, option, parameter.unsafe_cstr_ptr())

    fn curl_easy_setopt_long(self, curl: CURL, option: CURLoption, parameter: c_long) -> CURLcode:
        """Set a long/integer option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (CURL, CURLoption, c_long) -> CURLcode
        ]("curl_easy_setopt_long_wrapper")(curl, option, parameter)

    fn curl_easy_setopt_pointer(self, curl: CURL, option: CURLoption, parameter: OpaquePointer) -> CURLcode:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (CURL, CURLoption, OpaquePointer) -> CURLcode
        ]("curl_easy_setopt_pointer_wrapper")(curl, option, parameter)

    fn curl_easy_setopt_callback(self, curl: CURL, option: CURLoption, parameter: curl_write_callback) -> CURLcode:
        """Set a callback function for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (CURL, CURLoption, curl_write_callback) -> CURLcode
        ]("curl_easy_setopt_callback_wrapper")(curl, option, parameter)

    # Safe getinfo functions using wrapper
    fn curl_easy_getinfo_string(self, curl: CURL, info: CURLINFO, parameter: UnsafePointer[UnsafePointer[c_char]]) -> CURLcode:
        """Get string info from a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (CURL, CURLINFO, UnsafePointer[UnsafePointer[c_char]]) -> CURLcode
        ]("curl_easy_getinfo_string_wrapper")(curl, info, parameter)

    fn curl_easy_getinfo_long(self, curl: CURL, info: CURLINFO, parameter: UnsafePointer[c_long]) -> CURLcode:
        """Get long info from a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (CURL, CURLINFO, UnsafePointer[c_long]) -> CURLcode
        ]("curl_easy_getinfo_long_wrapper")(curl, info, parameter)

    fn curl_easy_perform(self, curl: CURL) -> CURLcode:
        """Perform a blocking file transfer."""
        return self.curl_lib.get_function[fn (CURL) -> CURLcode]("curl_easy_perform")(curl)

    fn curl_easy_cleanup(self, curl: CURL) -> NoneType:
        """End a libcurl easy handle."""
        return self.curl_lib.get_function[fn (CURL) -> NoneType]("curl_easy_cleanup")(curl)

    fn curl_easy_strerror(self, code: CURLcode) -> UnsafePointer[c_char]:
        """Return string describing error code."""
        return self.curl_lib.get_function[fn (CURLcode) -> UnsafePointer[c_char]]("curl_easy_strerror")(code)
