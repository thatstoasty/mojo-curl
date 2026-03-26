from std import os, pathlib, ffi
from std.pathlib import Path
from std.sys import CompilationTarget
from std.ffi import OwnedDLHandle, c_char, c_int, c_long, c_uint, c_size_t
from std.sys import get_defined_string

from mojo_curl.c.types import curl_slist, CURL, ImmutExternalPointer, MutExternalPointer, curl_rw_callback
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
        var curl_path = String(get_defined_string["LIBCURL_LIB_PATH", ""]())
        if curl_path == "":
            curl_path = os.getenv("LIBCURL_LIB_PATH")

        # Load curl library
        var wrapper_path = Path(get_defined_string["CURL_WRAPPER_LIB_PATH", ""]())
        if String(wrapper_path) == "":
            wrapper_path = Path(os.getenv("CURL_WRAPPER_LIB_PATH"))

        try:
            if curl_path == "":
                comptime if CompilationTarget.is_macos():
                    curl_path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.dylib")
                else:
                    curl_path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.so")

            if not Path(curl_path).exists():
                os.abort("libcurl library not found at: " + curl_path)

            if String(wrapper_path) == "":
                comptime if CompilationTarget.is_macos():
                    wrapper_path = pathlib.cwd() / ".pixi/envs/default/lib/libcurl_wrapper.dylib"
                else:
                    wrapper_path = pathlib.cwd() / ".pixi/envs/default/lib/libcurl_wrapper.so"

            if not wrapper_path.exists():
                os.abort("curl wrapper library not found at: " + String(wrapper_path))

            self.curl_lib = ffi.OwnedDLHandle(curl_path, ffi.RTLD.LAZY)
            self.wrapper_lib = ffi.OwnedDLHandle(wrapper_path, ffi.RTLD.LAZY)
        except e:
            print("Error loading libraries: ", e)
            os.abort()

    # Global libcurl functions
    fn curl_global_init(self, flags: c_long) -> CURLcode:
        """Global libcurl initialization."""
        return self.curl_lib.get_function[fn(type_of(flags)) -> CURLcode]("curl_global_init")(flags)

    fn curl_global_cleanup(self) -> NoneType:
        """Global libcurl cleanup."""
        return self.curl_lib.get_function[fn() -> NoneType]("curl_global_cleanup")()

    fn curl_version(self) -> ImmutExternalPointer[c_char]:
        """Return the version string of libcurl."""
        return self.curl_lib.get_function[fn() -> ImmutExternalPointer[c_char]]("curl_version")()

    # Easy interface functions
    fn curl_easy_init(self) -> CURL:
        """Start a libcurl easy session."""
        return self.curl_lib.get_function[fn() -> CURL]("curl_easy_init")()

    # Safe setopt functions using wrapper
    fn curl_easy_setopt_string[
        origin: ImmutOrigin, //
    ](self, easy: CURL, option: CURLoption, parameter: ImmutUnsafePointer[c_char, origin]) -> CURLcode:
        """Set a string option for a curl easy handle using safe wrapper.

        Parameters:
            origin: The origin of the `parameter` string to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The string parameter to set.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_string"
        )(easy, option, parameter)

    fn curl_easy_setopt_long(self, easy: CURL, option: CURLoption, parameter: c_long) -> CURLcode:
        """Set a long/integer option for a curl easy handle using safe wrapper.

        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The long/integer parameter to set.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_long"
        )(easy, option, parameter)

    fn curl_easy_setopt_pointer[
        origin: MutOrigin, //
    ](self, easy: CURL, option: CURLoption, parameter: MutOpaquePointer[origin]) -> CURLcode:
        """Set a pointer option for a curl easy handle using safe wrapper.

        Parameters:
            origin: The origin of the `parameter` pointer to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The pointer parameter to set.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_pointer"
        )(easy, option, parameter)

    fn curl_easy_setopt_callback(self, easy: CURL, option: CURLoption, parameter: curl_rw_callback) -> CURLcode:
        """Set a callback function for a curl easy handle using safe wrapper.

        Args:
            easy: The curl easy handle.
            option: The option to set (must be a callback option).
            parameter: The callback function to set.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(option), type_of(parameter)) -> CURLcode](
            "curl_easy_setopt_callback"
        )(easy, option, parameter)

    # Safe getinfo functions using wrapper
    fn curl_easy_getinfo_string[
        origin: MutOrigin
    ](self, easy: CURL, info: CURLINFO, parameter: Pointer[MutExternalPointer[c_char], origin],) -> CURLcode:
        """Get string info from a curl easy handle using safe wrapper.

        Parameters:
            origin: The origin of the `parameter` pointer to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            info: The info to get.
            parameter: Pointer to store the retrieved string info.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(info), type_of(parameter)) -> CURLcode](
            "curl_easy_getinfo_string"
        )(easy, info, parameter)

    fn curl_easy_getinfo_long[
        origin: MutOrigin
    ](self, easy: CURL, info: CURLINFO, parameter: Pointer[c_long, origin]) -> CURLcode:
        """Get long info from a curl easy handle using safe wrapper.

        Parameters:
            origin: The origin of the `parameter` pointer to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            info: The info to get.
            parameter: Pointer to store the retrieved long info.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(info), type_of(parameter)) -> CURLcode](
            "curl_easy_getinfo_long"
        )(easy, info, parameter)

    fn curl_easy_getinfo_float[
        origin: MutOrigin
    ](self, easy: CURL, info: CURLINFO, parameter: Pointer[Float64, origin]) -> CURLcode:
        """Get float info from a curl easy handle using safe wrapper.

        Parameters:
            origin: The origin of the `parameter` pointer to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            info: The info to get.
            parameter: Pointer to store the retrieved float info.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(info), type_of(parameter)) -> CURLcode](
            "curl_easy_getinfo_float"
        )(easy, info, parameter)

    fn curl_easy_getinfo_ptr[
        origin: MutOrigin,
        ptr_origin: MutOrigin,
    ](self, easy: CURL, info: CURLINFO, ptr: Pointer[MutUnsafePointer[NoneType, origin], ptr_origin]) -> CURLcode:
        """Get long info from a curl easy handle using safe wrapper.

        Parameters:
            origin: The origin of the `ptr` pointer to ensure safe memory access.
            ptr_origin: The origin of the inner pointer that `ptr` points to, to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            info: The info to get.
            ptr: Pointer to store the retrieved pointer info.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(info), type_of(ptr)) -> CURLcode](
            "curl_easy_getinfo_ptr"
        )(easy, info, ptr)

    fn curl_easy_getinfo_curl_slist[
        origin: MutOrigin,
        ptr_origin: MutOrigin,
    ](self, easy: CURL, info: CURLINFO, ptr: Pointer[MutUnsafePointer[curl_slist, origin], ptr_origin]) -> CURLcode:
        """Get long info from a curl easy handle using safe wrapper.

        Parameters:
            origin: The origin of the `ptr` pointer to ensure safe memory access.
            ptr_origin: The origin of the inner pointer that `ptr` points to, to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            info: The info to get.
            ptr: Pointer to store the retrieved curl_slist pointer info.

        Returns:
            CURLcode result code.
        """
        return self.wrapper_lib.get_function[fn(type_of(easy), type_of(info), type_of(ptr)) -> CURLcode](
            "curl_easy_getinfo_curl_slist"
        )(easy, info, ptr)

    fn curl_easy_perform(self, easy: CURL) -> CURLcode:
        """Perform a blocking file transfer.

        Args:
            easy: The curl easy handle.

        Returns:
            CURLcode result code.
        """
        return self.curl_lib.get_function[fn(type_of(easy)) -> CURLcode]("curl_easy_perform")(easy)

    fn curl_easy_cleanup(self, easy: CURL):
        """End a libcurl easy handle.

        Args:
            easy: The curl easy handle to clean up.
        """
        self.curl_lib.get_function[fn(type_of(easy)) -> NoneType]("curl_easy_cleanup")(easy)

    fn curl_easy_strerror(self, code: CURLcode) -> ImmutExternalPointer[c_char]:
        """Return string describing error code.

        Args:
            code: The CURLcode error code to get the string for.

        Returns:
            A pointer to a string describing the error code.
        """
        return self.curl_lib.get_function[fn(type_of(code)) -> ImmutExternalPointer[c_char]]("curl_easy_strerror")(code)

    # String list functions
    fn curl_slist_append[
        origin: ImmutOrigin, //
    ](self, list: MutExternalPointer[curl_slist], string: ImmutUnsafePointer[c_char, origin]) -> MutExternalPointer[
        curl_slist
    ]:
        """Append a string to a curl string list.

        Parameters:
            origin: The origin of the `string` data.

        Args:
            list: The existing string list (can be NULL).
            string: The string to append.

        Returns:
            A pointer to the new list, or NULL on error.
        """
        return self.curl_lib.get_function[fn(type_of(list), type_of(string)) -> MutExternalPointer[curl_slist]](
            "curl_slist_append"
        )(list, string)

    fn curl_slist_free_all(self, list: MutExternalPointer[curl_slist]):
        """Free an entire curl string list.

        Args:
            list: The string list to free.
        """
        self.curl_lib.get_function[fn(type_of(list)) -> NoneType]("curl_slist_free_all")(list)

    fn curl_easy_header[
        name_origin: ImmutOrigin, out_origin: MutOrigin, //
    ](
        self,
        easy: CURL,
        name: ImmutUnsafePointer[c_char, name_origin],
        index: c_size_t,
        origin: c_uint,
        request: c_int,
        hout: MutUnsafePointer[MutExternalPointer[curl_header], out_origin],
    ) -> c_int:
        """Get a specific header from a curl easy handle.

        Parameters:
            name_origin: The origin of the `name` string.
            out_origin: The origin of the `hout` pointer.

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
            fn(type_of(easy), type_of(name), type_of(index), type_of(origin), type_of(request), type_of(hout)) -> c_int
        ]("curl_easy_header")(easy, name, index, origin, request, hout)

    fn curl_easy_nextheader(
        self,
        easy: CURL,
        origin: c_uint,
        request: c_int,
        prev: MutExternalPointer[curl_header],
    ) -> MutExternalPointer[curl_header]:
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
            fn(type_of(easy), type_of(origin), type_of(request), type_of(prev)) -> MutExternalPointer[curl_header]
        ]("curl_easy_nextheader")(easy, origin, request, prev)

    fn curl_easy_escape[
        origin: ImmutOrigin, //
    ](self, easy: CURL, string: ImmutUnsafePointer[c_char, origin], length: c_int,) -> MutExternalPointer[c_char]:
        """URL-encode a string using curl easy handle.

        Parameters:
            origin: The origin of the string data.

        Args:
            easy: The curl easy handle.
            string: The string to encode.
            length: The length of the string (or 0 to calculate it automatically).

        Returns:
            A pointer to the URL-encoded string, or NULL on error.
        """
        return self.curl_lib.get_function[
            fn(type_of(easy), type_of(string), type_of(length)) -> MutExternalPointer[c_char]
        ]("curl_easy_escape")(easy, string, length)

    fn curl_easy_duphandle(self, easy: CURL) -> CURL:
        """Creates a new curl session handle with the same options set for the handle
        passed in. Duplicating a handle could only be a matter of cloning data and
        options, internal state info and things like persistent connections cannot
        be transferred. It is useful in multi-threaded applications when you can run
        curl_easy_duphandle() for each new thread to avoid a series of identical
        curl_easy_setopt() invokes in every thread.

        Args:
            easy: The curl easy handle to duplicate.

        Returns:
            A new curl easy handle that is a duplicate of the original, or NULL on error.
        """
        return self.curl_lib.get_function[fn(type_of(easy)) -> CURL]("curl_easy_duphandle")(easy)

    fn curl_easy_reset(self, easy: CURL):
        """Re-initializes a curl handle to the default values. This puts back the
        handle to the same state as it was in when it was just created.

        It does keep: live connections, the Session ID cache, the DNS cache and the
        cookies.

        Args:
            easy: The curl easy handle to reset.
        """
        self.curl_lib.get_function[fn(type_of(easy)) -> NoneType]("curl_easy_reset")(easy)

    fn curl_easy_recv[
        origin: MutOrigin, n_origin: MutOrigin, //
    ](
        self,
        easy: CURL,
        buffer: MutUnsafePointer[NoneType, origin],
        buflen: c_size_t,
        n: MutUnsafePointer[c_size_t, n_origin],
    ) -> CURLcode:
        """Receives data from the connected socket.
        Use after successful curl_easy_perform() with `CURLOPT_CONNECT_ONLY` option.

        Parameters:
            origin: The origin of the buffer data (e.g. which thread or component owns it) to ensure safe memory access.
            n_origin: The origin of the `n` pointer to ensure safe memory access.

        Args:
            easy: The curl easy handle.
            buffer: Pointer to the buffer to receive data.
            buflen: The size of the buffer.
            n: Pointer to store the number of bytes received.

        Returns:
            CURLcode result code.
        """
        return self.curl_lib.get_function[fn(type_of(easy), type_of(buffer), type_of(buflen), type_of(n)) -> CURLcode](
            "curl_easy_recv"
        )(easy, buffer, buflen, n)

    fn curl_easy_send[
        origin: ImmutOrigin, n_origin: MutOrigin, //
    ](
        self,
        easy: CURL,
        buffer: ImmutUnsafePointer[NoneType, origin],
        buflen: c_size_t,
        n: MutUnsafePointer[c_size_t, n_origin],
    ) -> CURLcode:
        """Sends data over the connected socket.
        Use after successful curl_easy_perform() with `CURLOPT_CONNECT_ONLY` option.

        Parameters:
            origin: The origin of the buffer data (e.g. which thread or component owns it).
            n_origin: The origin of the `n` pointer.

        Args:
            easy: The curl easy handle.
            buffer: Pointer to the data to send.
            buflen: The size of the data to send.
            n: Pointer to store the number of bytes sent.

        Returns:
            CURLcode result code.
        """
        return self.curl_lib.get_function[fn(type_of(easy), type_of(buffer), type_of(buflen), type_of(n)) -> CURLcode](
            "curl_easy_send"
        )(easy, buffer, buflen, n)

    fn curl_easy_upkeep(self, easy: CURL) -> CURLcode:
        """Performs connection upkeep for the given session handle.

        Args:
            easy: The curl easy handle.

        Returns:
            CURLcode result code.
        """
        return self.curl_lib.get_function[fn(type_of(easy)) -> CURLcode]("curl_easy_upkeep")(easy)
