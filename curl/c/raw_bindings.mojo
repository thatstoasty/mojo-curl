import os
import pathlib
from sys import ffi, env_get_string, CompilationTarget
from sys.ffi import OwnedDLHandle, c_char, c_int, c_long
from curl.c.types import ExternalImmutOpaquePointer, ExternalImmutPointer, CURL, curl_write_callback

alias CURLcode = c_int
alias CURLoption = c_int
alias CURLINFO = c_int

@fieldwise_init
struct _curl(Movable):
    """Safe CURL Easy interface that uses wrapper functions to avoid variadic FFI issues."""

    var curl_lib: OwnedDLHandle
    var wrapper_lib: OwnedDLHandle

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

            self.curl_lib = ffi.OwnedDLHandle(curl_path, ffi.RTLD.LAZY)
            self.wrapper_lib = ffi.OwnedDLHandle(wrapper_path, ffi.RTLD.LAZY)
        except e:
            self.curl_lib = os.abort[ffi.OwnedDLHandle](String("Failed to load libraries: ", e))
            self.wrapper_lib = os.abort[ffi.OwnedDLHandle](String("Failed to load libraries: ", e))

    # Global libcurl functions
    fn curl_global_init(self, flags: c_long) -> CURLcode:
        """Global libcurl initialization."""
        return self.curl_lib.get_function[fn (type_of(flags)) -> CURLcode]("curl_global_init")(flags)

    fn curl_global_cleanup(self) -> NoneType:
        """Global libcurl cleanup."""
        return self.curl_lib.get_function[fn () -> NoneType]("curl_global_cleanup")()

    fn curl_version(self) -> ExternalImmutPointer[c_char]:
        """Return the version string of libcurl."""
        return self.curl_lib.get_function[fn () -> ExternalImmutPointer[c_char]]("curl_version")()

    # Easy interface functions
    fn curl_easy_init(self) -> CURL:
        """Start a libcurl easy session."""
        return self.curl_lib.get_function[fn () -> CURL]("curl_easy_init")()

    # Safe setopt functions using wrapper
    fn curl_easy_setopt_string(self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: UnsafeImmutPointer[c_char]) -> CURLcode:
        """Set a string option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode
        ]("curl_easy_setopt_string")(curl, option, parameter)

    fn curl_easy_setopt_long(self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: c_long) -> CURLcode:
        """Set a long/integer option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode
        ]("curl_easy_setopt_long")(curl, option, parameter)

    fn curl_easy_setopt_pointer[origin: MutOrigin](self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: OpaqueMutPointer[origin]) -> CURLcode:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode
        ]("curl_easy_setopt_pointer")(curl, option, parameter)

    fn curl_easy_setopt_callback(self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: curl_write_callback) -> CURLcode:
        """Set a callback function for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode
        ]("curl_easy_setopt_callback")(curl, option, parameter)

    # Safe getinfo functions using wrapper
    fn curl_easy_getinfo_string[origin: ImmutOrigin, origin2: MutOrigin](self, curl: ExternalImmutOpaquePointer, info: CURLINFO, parameter: UnsafeMutPointer[UnsafeImmutPointer[c_char, origin], origin2]) -> CURLcode:
        """Get string info from a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (type_of(curl), type_of(info), type_of(parameter)) -> CURLcode
        ]("curl_easy_getinfo_string")(curl, info, parameter)

    fn curl_easy_getinfo_long[origin: MutOrigin](self, curl: ExternalImmutOpaquePointer, info: CURLINFO, parameter: UnsafeMutPointer[c_long, origin]) -> CURLcode:
        """Get long info from a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[
            fn (type_of(curl), type_of(info), type_of(parameter)) -> CURLcode
        ]("curl_easy_getinfo_long")(curl, info, parameter)

    fn curl_easy_perform(self, curl: ExternalImmutOpaquePointer) -> CURLcode:
        """Perform a blocking file transfer."""
        return self.curl_lib.get_function[fn (type_of(curl)) -> CURLcode]("curl_easy_perform")(curl)

    fn curl_easy_cleanup(self, curl: ExternalImmutOpaquePointer) -> NoneType:
        """End a libcurl easy handle."""
        return self.curl_lib.get_function[fn (type_of(curl)) -> NoneType]("curl_easy_cleanup")(curl)

    fn curl_easy_strerror(self, code: CURLcode) -> ExternalImmutPointer[c_char]:
        """Return string describing error code."""
        return self.curl_lib.get_function[fn (type_of(code)) -> ExternalImmutPointer[c_char]]("curl_easy_strerror")(code)
