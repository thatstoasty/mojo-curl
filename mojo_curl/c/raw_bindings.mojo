from std import os, pathlib, ffi
from std.pathlib import Path
from std.sys import CompilationTarget, stderr
from std.ffi import OwnedDLHandle, RTLD, c_char, c_int, c_long, c_uint, c_size_t, c_double
from std.sys import get_defined_string
from std.memory import MutPointer

from mojo_curl.c.types import curl_slist, CURL, ImmutExternalPointer, MutExternalPointer, WriteCallbackFn
from mojo_curl.c.header import curl_header

comptime CURLcode = c_int
comptime CURLoption = c_int
comptime CURLINFO = c_int


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
            " CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.dylib` or `-D CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.so`."
            " Or set the `CURL_WRAPPER_LIB_PATH` environment variable to the path to the libcurl wrapper library like"
            " `CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.dylib` or `CURL_WRAPPER_LIB_PATH=/path/to/libcurl_wrapper.so`."
        )


comptime curl_global_init = def(c_long) abi("C") thin -> CURLcode
comptime curl_global_cleanup = def() abi("C") thin -> NoneType
comptime curl_version = def() abi("C") thin -> ImmutExternalPointer[c_char]
comptime curl_easy_init = def() abi("C") thin -> CURL
comptime curl_easy_setopt_string = def(CURL, CURLoption, ImmutExternalPointer[c_char]) abi("C") thin -> CURLcode
comptime curl_easy_setopt_long = def(CURL, CURLoption, c_long) abi("C") thin -> CURLcode
comptime curl_easy_setopt_pointer = def(CURL, CURLoption, Optional[ImmutExternalPointer[NoneType]]) abi("C") thin -> CURLcode
comptime curl_easy_setopt_pointer_mut = def(CURL, CURLoption, Optional[MutExternalPointer[NoneType]]) abi("C") thin -> CURLcode
comptime curl_easy_setopt_callback = def(CURL, CURLoption, WriteCallbackFn) abi("C") thin -> CURLcode
comptime curl_easy_getinfo_string = def(CURL, CURLINFO, MutExternalPointer[MutExternalPointer[c_char]]) abi("C") thin -> CURLcode
comptime curl_easy_getinfo_long = def(CURL, CURLINFO, MutExternalPointer[c_long]) abi("C") thin -> CURLcode
comptime curl_easy_getinfo_double = def(CURL, CURLINFO, MutExternalPointer[c_double]) abi("C") thin -> CURLcode
comptime curl_easy_perform = def(CURL) abi("C") thin -> CURLcode
comptime curl_easy_cleanup = def(CURL) abi("C") thin -> NoneType
comptime curl_easy_strerror = def(CURLcode) abi("C") thin -> ImmutExternalPointer[c_char]
comptime curl_slist_append = def(Optional[MutExternalPointer[curl_slist]], ImmutExternalPointer[c_char]) abi("C") thin -> Optional[MutExternalPointer[curl_slist]]
comptime curl_slist_free_all = def(MutExternalPointer[curl_slist]) abi("C") thin -> NoneType
comptime curl_easy_nextheader = def(CURL, c_uint, c_int, Optional[MutExternalPointer[curl_header]]) abi("C") thin -> Optional[MutExternalPointer[curl_header]]
comptime curl_easy_escape = def(CURL, ImmutExternalPointer[c_char], c_int) abi("C") thin -> Optional[MutExternalPointer[c_char]]
comptime curl_easy_duphandle = def(CURL) abi("C") thin -> Optional[CURL]
comptime curl_easy_reset = def(CURL) abi("C") thin -> NoneType
comptime curl_easy_recv = def(CURL, MutExternalPointer[NoneType], c_size_t, MutExternalPointer[c_size_t]) abi("C") thin -> CURLcode
comptime curl_easy_send = def(CURL, ImmutExternalPointer[NoneType], c_size_t, MutExternalPointer[c_size_t]) abi("C") thin -> CURLcode
comptime curl_easy_upkeep = def(CURL) abi("C") thin -> CURLcode


@fieldwise_init
struct _curl(Movable):
    """Safe CURL Easy interface that uses wrapper functions to avoid variadic FFI issues."""

    var curl_lib: OwnedDLHandle
    var wrapper_lib: OwnedDLHandle

    var _fn_curl_global_init: curl_global_init
    var _fn_curl_global_cleanup: curl_global_cleanup
    var _fn_curl_version: curl_version
    var _fn_curl_easy_init: curl_easy_init
    var _fn_curl_easy_setopt_string: curl_easy_setopt_string
    var _fn_curl_easy_setopt_long: curl_easy_setopt_long
    var _fn_curl_easy_setopt_pointer: curl_easy_setopt_pointer
    var _fn_curl_easy_setopt_pointer_mut: curl_easy_setopt_pointer_mut
    var _fn_curl_easy_setopt_callback: curl_easy_setopt_callback
    var _fn_curl_easy_getinfo_string: curl_easy_getinfo_string
    var _fn_curl_easy_getinfo_long: curl_easy_getinfo_long
    var _fn_curl_easy_getinfo_float: curl_easy_getinfo_double
    var _fn_curl_easy_perform: curl_easy_perform
    var _fn_curl_easy_cleanup: curl_easy_cleanup
    var _fn_curl_easy_strerror: curl_easy_strerror
    var _fn_curl_slist_append: curl_slist_append
    var _fn_curl_slist_free_all: curl_slist_free_all
    var _fn_curl_easy_nextheader: curl_easy_nextheader
    var _fn_curl_easy_escape: curl_easy_escape
    var _fn_curl_easy_duphandle: curl_easy_duphandle
    var _fn_curl_easy_reset: curl_easy_reset
    var _fn_curl_easy_recv: curl_easy_recv
    var _fn_curl_easy_send: curl_easy_send
    var _fn_curl_easy_upkeep: curl_easy_upkeep

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
        
        self._fn_curl_global_init = self.curl_lib.get_function[curl_global_init]("curl_global_init")
        self._fn_curl_global_cleanup = self.curl_lib.get_function[curl_global_cleanup]("curl_global_cleanup")
        self._fn_curl_version = self.curl_lib.get_function[curl_version]("curl_version")
        self._fn_curl_easy_init = self.curl_lib.get_function[curl_easy_init]("curl_easy_init")
        self._fn_curl_easy_setopt_string = self.wrapper_lib.get_function[curl_easy_setopt_string]("curl_easy_setopt_string")
        self._fn_curl_easy_setopt_long = self.wrapper_lib.get_function[curl_easy_setopt_long]("curl_easy_setopt_long")
        self._fn_curl_easy_setopt_pointer = self.wrapper_lib.get_function[curl_easy_setopt_pointer]("curl_easy_setopt_pointer")
        self._fn_curl_easy_setopt_pointer_mut = self.wrapper_lib.get_function[curl_easy_setopt_pointer_mut]("curl_easy_setopt_pointer")
        self._fn_curl_easy_setopt_callback = self.wrapper_lib.get_function[curl_easy_setopt_callback]("curl_easy_setopt_callback")
        self._fn_curl_easy_getinfo_string = self.wrapper_lib.get_function[curl_easy_getinfo_string]("curl_easy_getinfo_string")
        self._fn_curl_easy_getinfo_long = self.wrapper_lib.get_function[curl_easy_getinfo_long]("curl_easy_getinfo_long")
        self._fn_curl_easy_getinfo_float = self.wrapper_lib.get_function[curl_easy_getinfo_double]("curl_easy_getinfo_double")
        self._fn_curl_easy_perform = self.curl_lib.get_function[curl_easy_perform]("curl_easy_perform")
        self._fn_curl_easy_cleanup = self.curl_lib.get_function[curl_easy_cleanup]("curl_easy_cleanup")
        self._fn_curl_easy_strerror = self.curl_lib.get_function[curl_easy_strerror]("curl_easy_strerror")
        self._fn_curl_slist_append = self.curl_lib.get_function[curl_slist_append]("curl_slist_append")
        self._fn_curl_slist_free_all = self.curl_lib.get_function[curl_slist_free_all]("curl_slist_free_all")
        self._fn_curl_easy_nextheader = self.curl_lib.get_function[curl_easy_nextheader]("curl_easy_nextheader")
        self._fn_curl_easy_escape = self.curl_lib.get_function[curl_easy_escape]("curl_easy_escape")
        self._fn_curl_easy_duphandle = self.curl_lib.get_function[curl_easy_duphandle]("curl_easy_duphandle")
        self._fn_curl_easy_reset = self.curl_lib.get_function[curl_easy_reset]("curl_easy_reset")
        self._fn_curl_easy_recv = self.curl_lib.get_function[curl_easy_recv]("curl_easy_recv")
        self._fn_curl_easy_send = self.curl_lib.get_function[curl_easy_send]("curl_easy_send")
        self._fn_curl_easy_upkeep = self.curl_lib.get_function[curl_easy_upkeep]("curl_easy_upkeep")

    # Global libcurl functions
    def curl_global_init(self, flags: c_long) -> CURLcode:
        """Global libcurl initialization.
        
        Args:
            flags: Bitmask of global initialization options (e.g. `CURL_GLOBAL_DEFAULT`).
        
        Returns:
            CURLcode result code.
        """
        return self._fn_curl_global_init(flags)

    def curl_global_cleanup(self):
        """Global libcurl cleanup."""
        self._fn_curl_global_cleanup()

    def curl_version(self) -> ImmutExternalPointer[c_char]:
        """Return the version string of libcurl.
        
        Returns:
            A pointer to a string containing the libcurl version information.
        """
        return self._fn_curl_version()

    # Easy interface functions
    def curl_easy_init(self) -> Optional[CURL]:
        """Start a libcurl easy session.
        
        Returns:
            A new CURL easy handle, or NULL on error.
        """
        return self._fn_curl_easy_init()

    # Safe setopt functions using wrapper
    def curl_easy_setopt_string[
        origin: ImmutOrigin, //,
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
        return self._fn_curl_easy_setopt_string(easy, option, parameter.unsafe_origin_cast[ImmutExternalOrigin]())

    def curl_easy_setopt_long(self, easy: CURL, option: CURLoption, parameter: c_long) -> CURLcode:
        """Set a long/integer option for a curl easy handle using safe wrapper.

        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The long/integer parameter to set.

        Returns:
            CURLcode result code.
        """
        return self._fn_curl_easy_setopt_long(easy, option, parameter)

    def curl_easy_setopt_pointer[origin: ImmutOrigin, //](self, easy: CURL, option: CURLoption, parameter: Optional[UnsafePointer[NoneType, origin]]) -> CURLcode:
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
        if parameter is None:
            return self._fn_curl_easy_setopt_pointer(easy, option, None)
        
        return self._fn_curl_easy_setopt_pointer(easy, option, parameter.value().unsafe_origin_cast[ImmutExternalOrigin]())
    
    def curl_easy_setopt_pointer_mut[origin: MutOrigin, //](self, easy: CURL, option: CURLoption, parameter: Optional[UnsafePointer[NoneType, origin]]) -> CURLcode:
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
        if parameter is None:
            return self._fn_curl_easy_setopt_pointer_mut(easy, option, None)
        
        return self._fn_curl_easy_setopt_pointer_mut(easy, option, parameter.value().unsafe_origin_cast[MutExternalOrigin]())
    
    def curl_easy_setopt_callback(self, easy: CURL, option: CURLoption, parameter: WriteCallbackFn) -> CURLcode:
        """Set a callback function for a curl easy handle using safe wrapper.

        Args:
            easy: The curl easy handle.
            option: The option to set (must be a callback option).
            parameter: The callback function to set.

        Returns:
            CURLcode result code.
        """
        return self._fn_curl_easy_setopt_callback(easy, option, parameter)

    # Safe getinfo functions using wrapper
    def curl_easy_getinfo_string[
        origin: MutOrigin, //
    ](self, easy: CURL, info: CURLINFO, parameter: MutUnsafePointer[MutExternalPointer[c_char], origin]) -> CURLcode:
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
        return self._fn_curl_easy_getinfo_string(easy, info, parameter.unsafe_origin_cast[MutExternalOrigin]())

    def curl_easy_getinfo_long[
        origin: MutOrigin, //
    ](self, easy: CURL, info: CURLINFO, parameter: MutUnsafePointer[c_long, origin]) -> CURLcode:
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
        return self._fn_curl_easy_getinfo_long(easy, info, parameter.unsafe_origin_cast[MutExternalOrigin]())

    def curl_easy_getinfo_double[
        origin: MutOrigin, //
    ](self, easy: CURL, info: CURLINFO, parameter: MutUnsafePointer[c_double, origin]) -> CURLcode:
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
        return self._fn_curl_easy_getinfo_float(easy, info, parameter.unsafe_origin_cast[MutExternalOrigin]())

    def curl_easy_getinfo_ptr[
        origin: MutOrigin,
        ptr_origin: MutOrigin,
        //
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
        return self.wrapper_lib.get_function[def(type_of(easy), type_of(info), type_of(ptr))abi("C") thin -> CURLcode](
            "curl_easy_getinfo_ptr"
        )(easy, info, ptr)

    def curl_easy_getinfo_curl_slist[
        origin: MutOrigin,
        ptr_origin: MutOrigin,
        //
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
        return self.wrapper_lib.get_function[def(type_of(easy), type_of(info), type_of(ptr))abi("C") thin -> CURLcode](
            "curl_easy_getinfo_curl_slist"
        )(easy, info, ptr)

    def curl_easy_perform(self, easy: CURL) -> CURLcode:
        """Perform a blocking file transfer.

        Args:
            easy: The curl easy handle.

        Returns:
            CURLcode result code.
        """
        return self._fn_curl_easy_perform(easy)

    def curl_easy_cleanup(self, easy: CURL):
        """End a libcurl easy handle.

        Args:
            easy: The curl easy handle to clean up.
        """
        self._fn_curl_easy_cleanup(easy)

    def curl_easy_strerror(self, code: CURLcode) -> ImmutExternalPointer[c_char]:
        """Return string describing error code.

        Args:
            code: The CURLcode error code to get the string for.

        Returns:
            A pointer to a string describing the error code.
        """
        return self._fn_curl_easy_strerror(code)

    # String list functions
    def curl_slist_append[
        origin: ImmutOrigin, //
    ](self, list: Optional[MutExternalPointer[curl_slist]], string: ImmutUnsafePointer[c_char, origin]) -> Optional[MutExternalPointer[curl_slist]]:
        """Append a string to a curl string list.

        Parameters:
            origin: The origin of the `string` data.

        Args:
            list: The existing string list (can be NULL).
            string: The string to append.

        Returns:
            A pointer to the new list, or NULL on error.
        """
        return self._fn_curl_slist_append(list, string.unsafe_origin_cast[ImmutExternalOrigin]())

    def curl_slist_free_all(self, list: MutExternalPointer[curl_slist]):
        """Free an entire curl string list.

        Args:
            list: The string list to free.
        """
        self._fn_curl_slist_free_all(list)

    def curl_easy_header[
        name_origin: ImmutOrigin, out_origin: MutOrigin, //
    ](
        self,
        easy: CURL,
        name: ImmutUnsafePointer[c_char, name_origin],
        index: c_size_t,
        origin: c_uint,
        request: c_int,
        hout: MutPointer[MutExternalPointer[curl_header], out_origin],
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
            def(type_of(easy), type_of(name), type_of(index), type_of(origin), type_of(request), type_of(hout)) abi("C") thin -> c_int
        ]("curl_easy_header")(easy, name, index, origin, request, hout)

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
        return self._fn_curl_easy_nextheader(easy, origin, request, prev)

    def curl_easy_escape[
        origin: ImmutOrigin, //
    ](self, easy: CURL, string: ImmutUnsafePointer[c_char, origin], length: c_int) -> Optional[MutExternalPointer[c_char]]:
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
        return self._fn_curl_easy_escape(easy, string.unsafe_origin_cast[ImmutExternalOrigin](), length)

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
        return self._fn_curl_easy_duphandle(easy)

    def curl_easy_reset(self, easy: CURL):
        """Re-initializes a curl handle to the default values. This puts back the
        handle to the same state as it was in when it was just created.

        It does keep: live connections, the Session ID cache, the DNS cache and the
        cookies.

        Args:
            easy: The curl easy handle to reset.
        """
        self._fn_curl_easy_reset(easy)

    def curl_easy_recv[
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
        return self._fn_curl_easy_recv(easy, buffer.unsafe_origin_cast[MutExternalOrigin](), buflen, n.unsafe_origin_cast[MutExternalOrigin]())

    def curl_easy_send[
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
        return self._fn_curl_easy_send(easy, buffer.unsafe_origin_cast[ImmutExternalOrigin](), buflen, n.unsafe_origin_cast[MutExternalOrigin]())

    def curl_easy_upkeep(self, easy: CURL) -> CURLcode:
        """Performs connection upkeep for the given session handle.

        Args:
            easy: The curl easy handle.

        Returns:
            CURLcode result code.
        """
        return self._fn_curl_easy_upkeep(easy)
