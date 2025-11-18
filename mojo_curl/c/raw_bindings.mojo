import os
import pathlib
from pathlib import Path
from sys import CompilationTarget, env_get_string, ffi
from sys.ffi import OwnedDLHandle, c_char, c_int, c_long, c_uint, c_size_t

from mojo_curl.c.types import curl_slist, CURL, ExternalImmutOpaquePointer, ExternalImmutPointer, ExternalMutPointer, curl_write_callback
from mojo_curl.c.header import curl_header

comptime CURLcode = c_int
comptime CURLoption = c_int
comptime CURLINFO = c_int


@fieldwise_init
struct _curl(Movable):
    """Safe CURL Easy interface that uses wrapper functions to avoid variadic FFI issues."""

    var curl_lib: OwnedDLHandle
    var wrapper_lib: OwnedDLHandle

    fn __init__(out self):
        """Initialize the Safe CURL binding by loading both libraries."""
        # Load curl library
        var curl_path = String(env_get_string["LIBCURL_LIB_PATH", ""]())
        if curl_path == "":
            curl_path = os.getenv("LIBCURL_LIB_PATH")

        # Load curl library
        var wrapper_path = Path(env_get_string["LIBCURL_LIB_PATH", ""]())
        if String(wrapper_path) == "":
            wrapper_path = Path(os.getenv("LIBCURL_LIB_PATH"))

        try:
            if curl_path == "":
                @parameter
                if CompilationTarget.is_macos():
                    curl_path = String(pathlib.cwd() / ".pixi/envs/default/lib/libmojo_curl.dylib")
                else:
                    curl_path = String(pathlib.cwd() / ".pixi/envs/default/lib/libmojo_curl.so")

            if not Path(curl_path).exists():
                os.abort("libcurl library not found at: " + curl_path)

            if String(wrapper_path) == "":
                @parameter
                if CompilationTarget.is_macos():
                    wrapper_path = pathlib.cwd() / ".pixi/envs/default/lib/libcurl_wrapper.dylib"
                else:
                    wrapper_path = pathlib.cwd() / ".pixi/envs/default/lib/libcurl_wrapper.so"

            if not wrapper_path.exists():
                os.abort("curl wrapper library not found at: " + String(wrapper_path))

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
        """Return the version string of libmojo_curl."""
        return self.curl_lib.get_function[fn () -> ExternalImmutPointer[c_char]]("curl_version")()

    # Easy interface functions
    fn curl_easy_init(self) -> CURL:
        """Start a libcurl easy session."""
        return self.curl_lib.get_function[fn () -> CURL]("curl_easy_init")()

    # Safe setopt functions using wrapper
    fn curl_easy_setopt_string(
        self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: UnsafeImmutPointer[c_char]
    ) -> CURLcode:
        """Set a string option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_string"
        )(curl, option, parameter)

    fn curl_easy_setopt_long(self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: c_long) -> CURLcode:
        """Set a long/integer option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_long"
        )(curl, option, parameter)

    fn curl_easy_setopt_pointer[
        origin: MutOrigin
    ](self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: OpaqueMutPointer[origin]) -> CURLcode:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_pointer"
        )(curl, option, parameter)

    fn curl_easy_setopt_callback(
        self, curl: ExternalImmutOpaquePointer, option: CURLoption, parameter: curl_write_callback
    ) -> CURLcode:
        """Set a callback function for a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[fn (type_of(curl), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_callback"
        )(curl, option, parameter)

    # Safe getinfo functions using wrapper
    fn curl_easy_getinfo_string[origin: MutOrigin](
        self,
        curl: ExternalImmutOpaquePointer,
        info: CURLINFO,
        parameter: UnsafeMutPointer[ExternalMutPointer[c_char], origin],
    ) -> CURLcode:
        """Get string info from a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[fn (type_of(curl), type_of(info), type_of(parameter)) -> CURLcode](
            "curl_easy_getinfo_string"
        )(curl, info, parameter)

    fn curl_easy_getinfo_long[
        origin: MutOrigin
    ](self, curl: ExternalImmutOpaquePointer, info: CURLINFO, parameter: UnsafeMutPointer[c_long, origin]) -> CURLcode:
        """Get long info from a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[fn (type_of(curl), type_of(info), type_of(parameter)) -> CURLcode](
            "curl_easy_getinfo_long"
        )(curl, info, parameter)

    fn curl_easy_getinfo_float[
        origin: MutOrigin
    ](self, curl: ExternalImmutOpaquePointer, info: CURLINFO, parameter: UnsafeMutPointer[Float64, origin]) -> CURLcode:
        """Get long info from a curl easy handle using safe wrapper."""
        return self.wrapper_lib.get_function[fn (type_of(curl), type_of(info), type_of(parameter)) -> CURLcode](
            "curl_easy_getinfo_float"
        )(curl, info, parameter)

    fn curl_easy_perform(self, curl: ExternalImmutOpaquePointer) -> CURLcode:
        """Perform a blocking file transfer."""
        return self.curl_lib.get_function[fn (type_of(curl)) -> CURLcode]("curl_easy_perform")(curl)

    fn curl_easy_cleanup(self, curl: ExternalImmutOpaquePointer) -> NoneType:
        """End a libcurl easy handle."""
        return self.curl_lib.get_function[fn (type_of(curl)) -> NoneType]("curl_easy_cleanup")(curl)

    fn curl_easy_strerror(self, code: CURLcode) -> ExternalImmutPointer[c_char]:
        """Return string describing error code."""
        return self.curl_lib.get_function[fn (type_of(code)) -> ExternalImmutPointer[c_char]]("curl_easy_strerror")(
            code
        )

    # String list functions
    fn curl_slist_append(self, list: ExternalMutPointer[curl_slist], string: UnsafeImmutPointer[c_char]) -> ExternalMutPointer[curl_slist]:
        """Append a string to a curl string list.

        Args:
            list: The existing string list (can be NULL).
            string: The string to append.

        Returns:
            A pointer to the new list, or NULL on error.
        """
        return self.curl_lib.get_function[
            fn (type_of(list), type_of(string)) -> ExternalMutPointer[curl_slist]
        ]("curl_slist_append")(list, string)

    fn curl_slist_free_all(self, list: ExternalMutPointer[curl_slist]):
        """Free an entire curl string list.

        Args:
            list: The string list to free.
        """
        self.curl_lib.get_function[fn (type_of(list)) -> NoneType]("curl_slist_free_all")(list)

    fn curl_easy_header(
        self,
        easy: ExternalImmutOpaquePointer,
        name: UnsafeImmutPointer[c_char],
        index: c_size_t,
        origin: c_uint,
        request: c_int,
        hout: UnsafeMutPointer[ExternalMutPointer[curl_header]],
    ) -> c_int:
        """Get a specific header from a curl easy handle.
        
        Args:
            easy: The curl easy handle.
            name: The name of the header to retrieve.
            index: The index of the header to retrieve (0-based).
            origin: The origin bitmask to filter headers.
            request: The request number to filter headers.
            hout: Pointer to store the retrieved header.
        
        Returns:
            CURLHcode result code.
        """
        return self.curl_lib.get_function[
            fn (type_of(easy), type_of(name), type_of(index), type_of(origin), type_of(request), type_of(hout)) -> c_int
        ]("curl_easy_header")(easy, name, index, origin, request, hout)


    fn curl_easy_nextheader(
        self,
        easy: ExternalImmutOpaquePointer,
        origin: c_uint,
        request: c_int,
        prev: ExternalMutPointer[curl_header],
    ) -> ExternalMutPointer[curl_header]:
        """Get the next header in the list for a curl easy handle.

        Args:
            easy: The curl easy handle.
            origin: The origin bitmask to filter headers.
            request: The request number to filter headers.
            prev: The previous header in the list (NULL to start from the beginning).

        Returns:
            A pointer to the next header in the list, or NULL if there are no more headers.
        """
        return self.curl_lib.get_function[
            fn (type_of(easy), type_of(origin), type_of(request), type_of(prev)) -> ExternalMutPointer[curl_header]
        ]("curl_easy_nextheader")(easy, origin, request, prev)

    fn curl_easy_escape(
        self,
        easy: ExternalImmutOpaquePointer,
        string: UnsafeImmutPointer[c_char],
        length: c_int,
    ) -> ExternalMutPointer[c_char]:
        """URL-encode a string using curl easy handle.

        Args:
            easy: The curl easy handle.
            string: The string to encode.
            length: The length of the string (or 0 to calculate it automatically).

        Returns:
            A pointer to the URL-encoded string, or NULL on error.
        """
        return self.curl_lib.get_function[
            fn (type_of(easy), type_of(string), type_of(length)) -> ExternalMutPointer[c_char]
        ]("curl_easy_escape")(easy, string, length)