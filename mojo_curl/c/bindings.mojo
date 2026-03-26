from std.ffi import c_char, c_uchar, c_int, c_long, c_size_t, c_uint

from mojo_curl.c.raw_bindings import _curl
from mojo_curl.c.types import (
    CURL,
    MutExternalPointer,
    ImmutExternalPointer,
    Info,
    Option,
    Result,
    curl_rw_callback,
    curl_slist,
)
from mojo_curl.c.header import curl_header


@fieldwise_init
struct curl:
    var lib: _curl

    fn __init__(out self):
        self.lib = _curl()

    # Global libcurl functions
    fn global_init(self, flags: c_long) -> Result:
        """Global libcurl initialization.
        
        Args:
            flags: Bitmask of CURL_GLOBAL_* flags to initialize.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_global_init(flags)

    fn global_cleanup(self):
        """Global libcurl cleanup."""
        self.lib.curl_global_cleanup()

    fn version(self) -> String:
        """Return the version string of libcurl.
        
        Returns:
            The version string of libcurl.
        """
        # TODO: Constructing StringSlice should technically work? Seems like an issue with
        # ExternalPointer external origins. It's not an AnyOrigin,
        # so there's probably some issue there that I'm not aware of.
        # It's ok, just allocate a small string here.
        return String(unsafe_from_utf8_ptr=self.lib.curl_version())

    # Easy interface functions
    fn easy_init(self) -> CURL:
        """Start a libcurl easy session.
        
        Returns:
            A new curl easy handle, or a NULL pointer on error.
        """
        return self.lib.curl_easy_init()

    fn easy_setopt(self, easy: CURL, option: Option, mut parameter: String) -> Result:
        """Set a string option for a curl easy handle using safe wrapper.
        
        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The string parameter to set.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_setopt_string(easy, option.value, parameter.as_c_string_slice().unsafe_ptr())
    
    fn easy_setopt[origin: ImmutOrigin, //](
        self, easy: CURL, option: Option, parameter: Span[UInt8, origin]
    ) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper.
        
        Parameters:
            origin: The origin of the string pointer.
        
        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The string parameter to set as a byte span.
        
        Returns:
            CURLcode result code.
        """
        var ptr = parameter.unsafe_ptr().bitcast[c_char]()
        return self.lib.curl_easy_setopt_string(easy, option.value, ptr)

    fn easy_setopt(self, easy: CURL, option: Option, parameter: c_long) -> Result:
        """Set a long/integer option for a curl easy handle using safe wrapper.
        
        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The long/integer parameter to set.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_setopt_long(easy, option.value, parameter)

    fn easy_setopt[origin: MutOrigin, //](
        self, easy: CURL, option: Option, parameter: MutOpaquePointer[origin]
    ) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper.
        
        Parameters:
            origin: The origin of the pointer.

        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The pointer parameter to set.

        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_setopt_pointer(easy, option.value, parameter)

    fn easy_setopt(self, easy: CURL, option: Option, parameter: curl_rw_callback) -> Result:
        """Set a callback function for a curl easy handle using safe wrapper.
        
        Args:
            easy: The curl easy handle.
            option: The option to set.
            parameter: The callback function to set.

        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_setopt_callback(easy, option.value, parameter)

    # Safe getinfo functions using wrapper
    fn easy_getinfo(self, easy: CURL, info: Info, mut parameter: MutExternalPointer[c_char]) -> Result:
        """Get string info from a curl easy handle using safe wrapper.
        
        The pointer is NULL or points to private memory. You **must not free it**.
        The memory gets freed automatically when you call `curl_easy_cleanup` on the corresponding curl handle.

        Args:
            easy: The curl easy handle.
            info: The info to get.
            parameter: Output parameter to receive the string info.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_getinfo_string(easy, info.value, Pointer(to=parameter))

    fn easy_getinfo(
        self,
        easy: CURL,
        info: Info,
        mut parameter: c_long,
    ) -> Result:
        """Get long info from a curl easy handle using safe wrapper.
        
        Args:
            easy: The curl easy handle.
            info: The info to get.
            parameter: Output parameter to receive the long/integer info.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_getinfo_long(easy, info.value, Pointer(to=parameter))

    fn easy_getinfo(
        self,
        easy: CURL,
        info: Info,
        mut parameter: Float64,
    ) -> Result:
        """Get long info from a curl easy handle using safe wrapper.
        
        Args:
            easy: The curl easy handle.
            info: The info to get.
            parameter: Output parameter to receive the double/float info.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_getinfo_float(easy, info.value, Pointer(to=parameter))
    
    fn easy_getinfo[origin: MutOrigin, //](
        self,
        easy: CURL,
        info: Info,
        mut ptr: MutOpaquePointer[origin],
    ) -> Result:
        """Get long info from a curl easy handle using safe wrapper.
        
        Parameters:
            origin: The origin of the pointer.
        
        Args:
            easy: The curl easy handle.
            info: The info to get.
            ptr: Output parameter to receive the pointer info.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_getinfo_ptr(easy, info.value, Pointer(to=ptr))
    
    fn easy_getinfo[origin: MutOrigin, //](
        self,
        easy: CURL,
        info: Info,
        mut ptr: MutUnsafePointer[curl_slist, origin],
    ) -> Result:
        """Get long info from a curl easy handle using safe wrapper.
        
        Parameters:
            origin: The origin of the pointer.
        
        Args:
            easy: The curl easy handle.
            info: The info to get.
            ptr: Output parameter to receive the pointer to curl_slist info.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_getinfo_curl_slist(easy, info.value, Pointer(to=ptr))

    fn easy_perform(self, easy: CURL) -> Result:
        """Perform a blocking file transfer.
        
        Args:
            easy: The curl easy handle.
        
        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_perform(easy)

    fn easy_cleanup(self, easy: CURL):
        """End a libcurl easy handle.
        
        Args:
            easy: The curl easy handle to clean up.
        """
        self.lib.curl_easy_cleanup(easy)

    fn easy_strerror(self, code: Result) -> ImmutExternalPointer[c_char]:
        """Return string describing error code.
        
        Args:
            code: The CURLcode error code to get the string for.
        
        Returns:
            A pointer to a string describing the error code.
        """
        return self.lib.curl_easy_strerror(code.value)

    # String list functions
    fn slist_append[origin: ImmutOrigin, //](self, list: MutExternalPointer[curl_slist], string: ImmutUnsafePointer[c_char, origin]) raises -> MutExternalPointer[curl_slist]:
        """Append a string to a curl string list.

        Parameters:
            origin: The origin of the string pointer.

        Args:
            list: The existing string list (can be NULL).
            string: The string to append.

        Returns:
            A pointer to the new list, or NULL on error.
        """
        var data = self.lib.curl_slist_append(list, string)
        if not data:
            raise Error("Failed to append to curl_slist")
        return data

    fn slist_free_all(self, mut list: MutExternalPointer[curl_slist]):
        """Free an entire curl string list.

        Args:
            list: The string list to free.
        """
        self.lib.curl_slist_free_all(list)

    fn easy_header(
        self,
        easy: CURL,
        mut name: String,
        index: c_size_t,
        origin: c_uint,
        request: c_int,
        mut hout: MutExternalPointer[curl_header],
    ) -> c_int:
        """Get a specific header from a curl easy handle.
        
        Args:
            easy: The curl easy handle.
            name: The name of the header to retrieve.
            index: The index of the header (0-based).
            origin: The origin bitmask to filter headers.
            request: The request number to filter headers.
            hout: Output parameter to receive the header.
        
        Returns:
            CURLHcode result code.
        """
        return self.lib.curl_easy_header(easy, name.as_c_string_slice().unsafe_ptr(), index, origin, request, UnsafePointer(to=hout))

    fn easy_nextheader(
        self,
        easy: CURL,
        origin: c_uint,
        request: c_int,
        mut prev: MutExternalPointer[curl_header],
    ) -> MutExternalPointer[curl_header]:
        """Get the next header in the list for a curl easy handle.
        
        Args:
            easy: The curl easy handle.
            origin: The origin bitmask to filter headers.
            request: The request number to filter headers.
            prev: The previous header pointer (NULL to get the first header).
        
        Returns:
            A pointer to the next header in the list, or NULL if there are no more headers.
        """
        return self.lib.curl_easy_nextheader(easy, origin, request, prev)

    fn easy_escape(
        self,
        easy: CURL,
        mut string: String,
        length: c_int,
    ) -> MutExternalPointer[c_char]:
        """URL-encode a string using curl easy handle.

        Args:
            easy: The curl easy handle.
            string: The string to encode.
            length: The length of the string (or 0 to calculate it automatically).

        Returns:
            A pointer to the URL-encoded string, or NULL on error.
        """
        return self.lib.curl_easy_escape(easy, string.as_c_string_slice().unsafe_ptr(), length)
    
    fn easy_duphandle(self, easy: CURL) -> CURL:
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
        return self.lib.curl_easy_duphandle(easy)
    
    fn easy_reset(self, easy: CURL):
        """Reset a curl easy handle to its default state."""
        self.lib.curl_easy_reset(easy)
    
    fn easy_recv[origin: MutOrigin](self, easy: CURL, buffer: Span[c_uchar, origin], capacity: c_size_t) -> Tuple[Result, c_size_t]:
        """Receive data from the connected peer.

        Args:
            easy: The curl easy handle.
            buffer: The buffer to receive data into.
            capacity: The capacity of the buffer.

        Returns:
            A tuple containing the CURLcode result code and the number of bytes received.
        """
        var bytes_received: c_size_t = 0
        var result = self.lib.curl_easy_recv(easy, buffer.unsafe_ptr().bitcast[NoneType](), capacity, UnsafePointer(to=bytes_received))
        return result, bytes_received

    fn easy_send[origin: ImmutOrigin](self, easy: CURL, buffer: Span[c_uchar, origin]) -> Tuple[Result, c_size_t]:
        """Send data to the connected peer.

        Args:
            easy: The curl easy handle.
            buffer: The buffer containing data to send.

        Returns:
            A tuple containing the CURLcode result code and the number of bytes sent.
        """
        var bytes_sent: c_size_t = 0
        var result = self.lib.curl_easy_send(easy, buffer.unsafe_ptr().bitcast[NoneType](), UInt(len(buffer)), UnsafePointer(to=bytes_sent))
        return result, bytes_sent

    fn easy_upkeep(self, easy: CURL) -> Result:
        """Perform upkeep tasks for a curl easy handle.

        This function is used to perform any necessary upkeep tasks for a curl easy handle,
        such as handling timeouts or processing pending events. It should be called periodically
        when using curl in a non-blocking manner.

        Args:
            easy: The curl easy handle.

        Returns:
            CURLcode result code.
        """
        return self.lib.curl_easy_upkeep(easy)