from sys.ffi import c_char, c_int, c_long, c_size_t, c_uint

from mojo_curl.c.raw_bindings import _curl
from mojo_curl.c.types import (
    CURL,
    ExternalImmutOpaquePointer,
    ExternalImmutPointer,
    Info,
    Option,
    Result,
    curl_write_callback,
    ExternalMutPointer,
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
        """Global libcurl initialization."""
        return self.lib.curl_global_init(flags)

    fn global_cleanup(self):
        """Global libcurl cleanup."""
        self.lib.curl_global_cleanup()

    fn version(self) -> String:
        """Return the version string of libmojo_curl."""
        # TODO: Constructing StringSlice should technically work? Seems like an issue with
        # ExternalPointer external origins. It's not an AnyOrigin,
        # so there's probably some issue there that I'm not aware of.
        # It's ok, just allocate a small string here.
        return String(unsafe_from_utf8_ptr=self.lib.curl_version())

    # Easy interface functions
    fn easy_init(self) -> CURL:
        """Start a libcurl easy session."""
        return self.lib.curl_easy_init()

    fn easy_setopt(self, easy: ExternalImmutOpaquePointer, option: Option, mut parameter: String) -> Result:
        """Set a string option for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_string(easy, option.value, parameter.unsafe_cstr_ptr())
    
    fn easy_setopt[origin: ImmutOrigin](
        self, easy: ExternalImmutOpaquePointer, option: Option, parameter: Span[UInt8, origin]
    ) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        var ptr = parameter.unsafe_ptr().bitcast[c_char]()
        return self.lib.curl_easy_setopt_string(easy, option.value, ptr)

    fn easy_setopt(self, easy: ExternalImmutOpaquePointer, option: Option, parameter: c_long) -> Result:
        """Set a long/integer option for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_long(easy, option.value, parameter)

    fn easy_setopt[origin: MutOrigin](
        self, easy: ExternalImmutOpaquePointer, option: Option, parameter: OpaqueMutPointer[origin]
    ) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_pointer(easy, option.value, parameter)

    fn easy_setopt(self, easy: ExternalImmutOpaquePointer, option: Option, parameter: curl_write_callback) -> Result:
        """Set a callback function for a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_setopt_callback(easy, option.value, parameter)

    # Safe getinfo functions using wrapper
    fn easy_getinfo(self, easy: ExternalImmutOpaquePointer, info: Info, mut parameter: ExternalMutPointer[c_char]) -> Result:
        """Get string info from a curl easy handle using safe wrapper.
        
        The pointer is NULL or points to private memory. You **must not free it**.
        The memory gets freed automatically when you call `curl_easy_cleanup` on the corresponding curl handle.
        """
        return self.lib.curl_easy_getinfo_string(easy, info.value, UnsafePointer(to=parameter))

    fn easy_getinfo(
        self,
        easy: ExternalImmutOpaquePointer,
        info: Info,
        mut parameter: c_long,
    ) -> Result:
        """Get long info from a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_getinfo_long(easy, info.value, UnsafePointer(to=parameter))

    fn easy_getinfo(
        self,
        easy: ExternalImmutOpaquePointer,
        info: Info,
        mut parameter: Float64,
    ) -> Result:
        """Get long info from a curl easy handle using safe wrapper."""
        return self.lib.curl_easy_getinfo_float(easy, info.value, UnsafePointer(to=parameter))

    fn easy_perform(self, easy: ExternalImmutOpaquePointer) -> Result:
        """Perform a blocking file transfer."""
        return self.lib.curl_easy_perform(easy)

    fn easy_cleanup(self, easy: ExternalImmutOpaquePointer) -> NoneType:
        """End a libcurl easy handle."""
        return self.lib.curl_easy_cleanup(easy)

    fn easy_strerror(self, code: Result) -> ExternalImmutPointer[c_char]:
        """Return string describing error code."""
        return self.lib.curl_easy_strerror(code.value)

    # String list functions
    fn slist_append(self, list: ExternalMutPointer[curl_slist], string: UnsafeImmutPointer[c_char]) raises -> ExternalMutPointer[curl_slist]:
        """Append a string to a curl string list.

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

    fn slist_free_all(self, mut list: ExternalMutPointer[curl_slist]):
        """Free an entire curl string list.

        Args:
            list: The string list to free.
        """
        self.lib.curl_slist_free_all(list)

    fn easy_header(
        self,
        easy: ExternalImmutOpaquePointer,
        mut name: String,
        index: c_size_t,
        origin: c_uint,
        request: c_int,
        mut hout: ExternalMutPointer[curl_header],
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
        return self.lib.curl_easy_header(easy, name.unsafe_cstr_ptr(), index, origin, request, UnsafePointer(to=hout))

    fn easy_nextheader(
        self,
        easy: ExternalImmutOpaquePointer,
        origin: c_uint,
        request: c_int,
        mut prev: ExternalMutPointer[curl_header],
    ) -> ExternalMutPointer[curl_header]:
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
        easy: ExternalImmutOpaquePointer,
        mut string: String,
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
        return self.lib.curl_easy_escape(easy, string.unsafe_cstr_ptr(), length)