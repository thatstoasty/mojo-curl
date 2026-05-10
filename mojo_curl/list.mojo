from std.collections.string.string import CStringSlice
from mojo_curl.c.types import curl_slist, MutExternalPointer
from mojo_curl.c.api import curl_ffi


def _build_header_string(key: String, value: String) -> String:
    """Builds a header string in the format "Key: Value" or "Key;" if the value is empty.

    Args:
        key: The header key.
        value: The header value.

    Returns:
        A formatted header string.
    """
    var key_byte_length = key.byte_length()
    var value_byte_length = value.byte_length()
    var capacity_to_reserve = (key_byte_length + 2) if value_byte_length == 0 else (value_byte_length + key_byte_length + 2)
    var header = String(capacity=capacity_to_reserve)  # +2 for ": " or ";"
    header.write(key)
    if value_byte_length > 0:
        header.write(": ")
        header.write(value)
    else:
        header.write(";")
    return header^


# TODO: Add Boolable and Defaultable back in the next release, at the moment
# they conform to ImplicitlyDestructible, but that's been removed in the next Mojo release.
@explicit_destroy("CurlList must be explicitly destroyed using the `free` method.")
struct CurlList(Movable):
    """Represents a linked list of HTTP headers for use with libcurl."""

    var data: Optional[MutExternalPointer[curl_slist]]
    """The underlying pointer to the `curl_slist` structure."""

    def __init__(out self):
        self.data = None

    def __init__(out self, headers: Dict[String, String]) raises:
        self.data = None
        for pair in headers.items():
            var header = _build_header_string(pair.key, pair.value)
            try:
                self.append(header.as_c_string_slice())
            except e:
                self^.free()
                raise e^

    def __init__(
        out self,
        var headers: List[String],
        var values: List[String],
        __dict_literal__: (),
    ) raises:
        self.data = None
        for pair in zip(headers, values):
            var header = _build_header_string(pair[0], pair[1])
            try:
                self.append(header.as_c_string_slice())
            except e:
                self^.free()
                raise e^

    def __bool__(self) -> Bool:
        return Bool(self.data)
    
    def is_empty(self) -> Bool:
        """Checks if the list is empty.

        Returns:
            True if the list is empty, False otherwise.
        """
        return not self.data
    
    def append(mut self, var value: String) raises:
        """Appends a value to the string list.

        Args:
            value: The string value to append.
        
        Raises:
            Error: If appending to the list fails.
        """
        var ptr = curl_ffi()[].slist_append(self.data, value.as_c_string_slice().unsafe_ptr())
        if not ptr:
            raise Error("Failed to append to curl_slist")
        self.data = ptr

    def append(mut self, value: CStringSlice) raises:
        """Appends a value to the string list.

        Args:
            value: The string value to append.
        
        Raises:
            Error: If appending to the list fails.
        """
        var ptr = curl_ffi()[].slist_append(self.data, value.unsafe_ptr())
        if not ptr:
            raise Error("Failed to append to curl_slist")
        self.data = ptr

    def free(deinit self):
        """Frees the memory allocated for the string list."""
        if self.data:
            curl_ffi()[].slist_free_all(self.data.value())

    def unsafe_ptr[origin: Origin, //](ref[origin] self) -> Optional[UnsafePointer[curl_slist, origin]]:
        """Retrieves a pointer to the underlying memory.
        Parameters:
            origin: The origin of the `SocketAddress`.
            address_space: The `AddressSpace` of the `SocketAddress`.
        Returns:
            The pointer to the underlying memory.
        """
        if not self.data:
            return None
        return self.data.value().unsafe_mut_cast[origin.mut]().unsafe_origin_cast[origin]()

    @always_inline
    def __iter__(ref self) -> _CurlListIterator[origin_of(self)]:
        return _CurlListIterator(Pointer(to=self))


@fieldwise_init
struct _CurlListIterator[origin: Origin](Copyable, Iterable, Iterator):
    # TODO: Not sure if it's safe to use external origin string slices?
    comptime Element = StringSlice[MutExternalOrigin]
    comptime IteratorType[iterable_mut: Bool, //, iterable_origin: Origin[mut=iterable_mut]]: Iterator = Self

    var src: Pointer[CurlList, Self.origin]
    var curr: Optional[MutExternalPointer[curl_slist]]

    def __init__(out self, src: Pointer[CurlList, Self.origin]):
        self.src = src
        self.curr = src[].data

    def __has_next__(self) -> Bool:
        """Checks if there are more rows available.

        Returns:
            True if there are more rows to iterate over, False otherwise.
        """
        return Bool(self.curr)

    def __iter__(ref self) -> Self.IteratorType[origin_of(self)]:
        return self.copy()

    def __next_ref__(mut self) -> Self.Element:
        var old = self.curr
        self.curr = self.curr.value()[].next if self.curr else None

        return StringSlice(unsafe_from_utf8_ptr=old.value()[].data)

    def __next__(mut self) -> Self.Element:
        """Returns the next row in the result set.

        Returns:
            The next Row object.
        """
        return self.__next_ref__()
