"""Raw C bindings to libcurl library."""

from std import os, pathlib, ffi
from std.pathlib import Path
from std.sys import CompilationTarget, stderr
from std.ffi import OwnedDLHandle, RTLD, c_char, c_int, c_long, c_uint, c_size_t, c_double
from std.sys import get_defined_string
from std.memory import MutPointer

from mojo_curl.c.types import (
    curl_slist,
    CURL,
    ImmExternalPointer,
    MutExternalPointer,
    curl_write_callback,
    curl_header,
    CURLcode,
    CURLHcode,
    CURLoption,
    CURLINFO,
)


def _find_libcurl_library() raises -> String:
    """Locate ``libcurl`` via ``$CONDA_PREFIX`` (pixi).

    Returns:
        Library path string for ``OwnedDLHandle``.

    Raises:
        Error: If the library path cannot be determined from either the environment variable or the conda prefix.
    """
    var path = os.getenv("LIBCURL_LIB_PATH")
    if path != "":
        return path

    var prefix = os.getenv("CONDA_PREFIX", "")
    if prefix != "":
        comptime if CompilationTarget.is_macos():
            return String(t"{prefix}/lib/libcurl.dylib")
        else:
            return String(t"{prefix}/lib/libcurl.so")
    else:
        raise Error(
            "The path to the libcurl library is not set. Set the path as either a compilation variable with `-D"
            " LIBCURL_LIB_PATH=/path/to/libcurl.dylib` or `-D LIBCURL_LIB_PATH=/path/to/libcurl.so`."
            " Or set the `LIBCURL_LIB_PATH` environment variable to the path to the libcurl library like"
            " `LIBCURL_LIB_PATH=/path/to/libcurl.dylib` or `LIBCURL_LIB_PATH=/path/to/libcurl.so`."
        )


def _find_libcurl_wrapper_library() raises -> String:
    """Locate ``libcurl_wrapper`` via ``$CONDA_PREFIX`` (pixi).

    Returns:
        Library path string for ``OwnedDLHandle``.

    Raises:
        Error: If the library path cannot be determined from either the environment variable or the conda prefix.
    """
    var path = os.getenv("CURL_WRAPPER_LIB_PATH")
    if path != "":
        return path

    var prefix = os.getenv("CONDA_PREFIX", "")
    if prefix != "":
        comptime if CompilationTarget.is_macos():
            return String(t"{prefix}/lib/libcurl_wrapper.dylib")
        else:
            return String(t"{prefix}/lib/libcurl_wrapper.so")
    else:
        raise Error(
            "The path to the libcurl wrapper library is not set. Set the path as either a compilation variable with `-D"
            " CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.dylib` or `-D"
            " CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.so`. Or set the `CURL_WRAPPER_LIB_PATH` environment"
            " variable to the path to the libcurl wrapper library like"
            " `CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.dylib` or"
            " `CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.so`."
        )


@fieldwise_init
struct _curl(Movable):
    """Safe CURL Easy interface that uses wrapper functions to avoid variadic FFI issues."""

    var curl_lib: OwnedDLHandle
    var wrapper_lib: OwnedDLHandle

    def __init__(out self) raises:
        """Initialize the Safe CURL binding by loading both libraries."""
        var defined_path = get_defined_string["CURL_LIB_PATH", ""]()
        var wrapper_defined_path = get_defined_string["CURL_WRAPPER_LIB_PATH", ""]()
        try:
            if defined_path != "":
                self.curl_lib = OwnedDLHandle(defined_path, RTLD.LAZY)
            else:
                self.curl_lib = OwnedDLHandle(_find_libcurl_library(), RTLD.LAZY)

            if wrapper_defined_path != "":
                self.wrapper_lib = OwnedDLHandle(wrapper_defined_path, RTLD.LAZY)
            else:
                self.wrapper_lib = OwnedDLHandle(_find_libcurl_wrapper_library(), RTLD.LAZY)
        except e:
            raise Error(t"Error loading libcurl libraries: {e}")

    # Global libcurl functions
    def curl_global_init(self, flags: c_long) -> CURLcode:
        """Global libcurl initialization.

        Args:
            flags: Bitmask of global initialization options (e.g. `CURL_GLOBAL_DEFAULT`).

        Returns:
            CURLcode result code.
        """
        comptime fn_name: StaticString = "curl_global_init"
        try:
            return self.curl_lib.get_function[CURLcode](fn_name)(flags)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_global_cleanup(self):
        """Global libcurl cleanup."""
        comptime fn_name: StaticString = "curl_global_cleanup"
        try:
            self.curl_lib.get_function[NoneType](fn_name)()
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_version(self) -> ImmExternalPointer[c_char]:
        """Return the version string of libcurl.

        Returns:
            A pointer to a string containing the libcurl version information.
        """
        comptime fn_name: StaticString = "curl_version"
        try:
            return self.curl_lib.get_function[ImmExternalPointer[c_char]](fn_name)()
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    # Easy interface functions
    def curl_easy_init(self) -> Optional[CURL]:
        """Start a libcurl easy session.

        Returns:
            A new CURL easy handle, or NULL on error.
        """
        comptime fn_name: StaticString = "curl_easy_init"
        try:
            return self.curl_lib.get_function[Optional[CURL]](fn_name)()
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    # Safe setopt functions using wrapper
    def curl_easy_setopt_string[
        origin: ImmOrigin,
        //,
    ](self, easy: CURL, option: CURLoption, parameter: ImmPointer[c_char, origin]) -> CURLcode:
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
        comptime fn_name: StaticString = "curl_easy_setopt_string"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(
                easy, option, parameter.unsafe_origin_cast[ImmUntrackedOrigin]()
            )
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_setopt_long(self, easy: CURL, option: CURLoption, parameter: c_long) -> CURLcode:
        """Set a long/integer option for a curl easy handle using safe wrapper.

        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The long/integer parameter to set.

        Returns:
            CURLcode result code.
        """
        comptime fn_name: StaticString = "curl_easy_setopt_long"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, option, parameter)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_setopt_pointer[
        origin: Origin, //
    ](self, easy: CURL, option: CURLoption, parameter: Optional[Pointer[NoneType, origin]]) -> CURLcode:
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
        comptime fn_name: StaticString = "curl_easy_setopt_pointer"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, option, parameter)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_setopt_callback(self, easy: CURL, option: CURLoption, parameter: curl_write_callback) -> CURLcode:
        """Set a callback function for a curl easy handle using safe wrapper.

        Args:
            easy: The curl easy handle.
            option: The option to set (must be a callback option).
            parameter: The callback function to set.

        Returns:
            CURLcode result code.
        """
        comptime fn_name: StaticString = "curl_easy_setopt_callback"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, option, parameter)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    # Safe getinfo functions using wrapper
    def curl_easy_getinfo_string[
        origin: MutOrigin, //
    ](self, easy: CURL, info: CURLINFO, parameter: MutPointer[MutExternalPointer[c_char], origin]) -> CURLcode:
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
        comptime fn_name: StaticString = "curl_easy_getinfo_string"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, info, parameter)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_getinfo_long[
        origin: MutOrigin, //
    ](self, easy: CURL, info: CURLINFO, parameter: MutPointer[c_long, origin]) -> CURLcode:
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
        comptime fn_name: StaticString = "curl_easy_getinfo_long"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, info, parameter)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_getinfo_double[
        origin: MutOrigin, //
    ](self, easy: CURL, info: CURLINFO, parameter: MutPointer[c_double, origin]) -> CURLcode:
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
        comptime fn_name: StaticString = "curl_easy_getinfo_double"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, info, parameter)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_getinfo_ptr[
        origin: MutOrigin, ptr_origin: MutOrigin, //
    ](self, easy: CURL, info: CURLINFO, ptr: MutPointer[MutPointer[NoneType, origin], ptr_origin]) -> CURLcode:
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
        comptime fn_name: StaticString = "curl_easy_getinfo_ptr"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, info, ptr)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_getinfo_curl_slist[
        origin: MutOrigin, ptr_origin: MutOrigin, //
    ](
        self, easy: CURL, info: CURLINFO, ptr: MutPointer[Optional[MutPointer[curl_slist, origin]], ptr_origin]
    ) -> CURLcode:
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
        comptime fn_name: StaticString = "curl_easy_getinfo_curl_slist"
        try:
            return self.wrapper_lib.get_function[CURLcode](fn_name)(easy, info, ptr)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_perform(self, easy: CURL) -> CURLcode:
        """Perform a blocking file transfer.

        Args:
            easy: The curl easy handle.

        Returns:
            CURLcode result code.
        """
        comptime fn_name: StaticString = "curl_easy_perform"
        try:
            return self.curl_lib.get_function[CURLcode](fn_name)(easy)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_cleanup(self, easy: CURL):
        """End a libcurl easy handle.

        Args:
            easy: The curl easy handle to clean up.
        """
        comptime fn_name: StaticString = "curl_easy_cleanup"
        try:
            self.curl_lib.get_function[NoneType](fn_name)(easy)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_strerror(self, code: CURLcode) -> ImmExternalPointer[c_char]:
        """Return string describing error code.

        Args:
            code: The CURLcode error code to get the string for.

        Returns:
            A pointer to a string describing the error code.
        """
        comptime fn_name: StaticString = "curl_easy_strerror"
        try:
            return self.curl_lib.get_function[ImmExternalPointer[c_char]](fn_name)(code)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    # String list functions
    def curl_slist_append[
        origin: ImmOrigin, //
    ](self, list: Optional[MutExternalPointer[curl_slist]], string: ImmPointer[c_char, origin]) -> Optional[
        MutExternalPointer[curl_slist]
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
        comptime fn_name: StaticString = "curl_slist_append"
        try:
            return self.curl_lib.get_function[Optional[MutExternalPointer[curl_slist]]](fn_name)(list, string)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_slist_free_all(self, list: MutExternalPointer[curl_slist]):
        """Free an entire curl string list.

        Args:
            list: The string list to free.
        """
        comptime fn_name: StaticString = "curl_slist_free_all"
        try:
            self.curl_lib.get_function[NoneType](fn_name)(list)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_header[
        name_origin: ImmOrigin, out_origin: MutOrigin, //
    ](
        self,
        easy: CURL,
        name: ImmPointer[c_char, name_origin],
        index: c_size_t,
        origin: c_uint,
        request: c_int,
        hout: MutPointer[MutExternalPointer[curl_header], out_origin],
    ) -> CURLHcode:
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
        comptime fn_name: StaticString = "curl_easy_header"
        try:
            return self.curl_lib.get_function[CURLHcode](fn_name)(easy, name, index, origin, request, hout)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_nextheader(
        self,
        easy: CURL,
        origin: c_uint,
        request: c_int,
        prev: Optional[MutExternalPointer[curl_header]],
    ) -> Optional[MutExternalPointer[curl_header]]:
        """Get the next header in the list for a curl easy handle.

        Args:
            easy: The curl easy handle.
            origin: The origin bitmask to filter headers.
            request: The request number to filter headers.
            prev: The previous header in the list (NULL to start from the beginning).

        Returns:
            A pointer to the next header in the list, or NULL if there are no more headers.
        """
        comptime fn_name: StaticString = "curl_easy_nextheader"
        try:
            return self.curl_lib.get_function[Optional[MutExternalPointer[curl_header]]](fn_name)(
                easy, origin, request, prev
            )
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_escape[
        origin: ImmOrigin, //
    ](self, easy: CURL, string: ImmPointer[c_char, origin], length: c_int) -> Optional[MutExternalPointer[c_char]]:
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
        comptime fn_name: StaticString = "curl_easy_escape"
        try:
            return self.curl_lib.get_function[Optional[MutExternalPointer[c_char]]](fn_name)(easy, string, length)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_duphandle(self, easy: CURL) -> Optional[CURL]:
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
        comptime fn_name: StaticString = "curl_easy_duphandle"
        try:
            return self.curl_lib.get_function[Optional[CURL]](fn_name)(easy)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_reset(self, easy: CURL):
        """Re-initializes a curl handle to the default values. This puts back the
        handle to the same state as it was in when it was just created.

        It does keep: live connections, the Session ID cache, the DNS cache and the
        cookies.

        Args:
            easy: The curl easy handle to reset.
        """
        comptime fn_name: StaticString = "curl_easy_reset"
        try:
            self.curl_lib.get_function[NoneType](fn_name)(easy)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_recv[
        origin: MutOrigin, n_origin: MutOrigin, //
    ](
        self,
        easy: CURL,
        buffer: MutPointer[NoneType, origin],
        buflen: c_size_t,
        n: MutPointer[c_size_t, n_origin],
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
        comptime fn_name: StaticString = "curl_easy_recv"
        try:
            return self.curl_lib.get_function[CURLcode](fn_name)(easy, buffer, buflen, n)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_send[
        origin: ImmOrigin, n_origin: MutOrigin, //
    ](
        self,
        easy: CURL,
        buffer: ImmPointer[NoneType, origin],
        buflen: c_size_t,
        n: MutPointer[c_size_t, n_origin],
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
        comptime fn_name: StaticString = "curl_easy_send"
        try:
            return self.curl_lib.get_function[CURLcode](fn_name)(easy, buffer, buflen, n)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")

    def curl_easy_upkeep(self, easy: CURL) -> CURLcode:
        """Performs connection upkeep for the given session handle.

        Args:
            easy: The curl easy handle.

        Returns:
            CURLcode result code.
        """
        comptime fn_name: StaticString = "curl_easy_send"
        try:
            return self.curl_lib.get_function[CURLcode](fn_name)(easy)
        except:
            os.abort(t"Couldn't find function {fn_name} in linked libcurl.")
