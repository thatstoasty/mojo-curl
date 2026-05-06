from mojo_curl.c.types import curl_slist, MutExternalPointer
from mojo_curl.c.api import curl_ffi


@explicit_destroy("CurlList must be explicitly destroyed using the `free` method.")
struct CurlList(Boolable, Defaultable, Movable):
    """Represents a linked list of HTTP headers for use with libcurl."""

    var data: MutExternalPointer[curl_slist]
    """The underlying pointer to the `curl_slist` structure."""

    def __init__(out self):
        self.data = MutExternalPointer[curl_slist]()

    def __init__(out self, headers: Dict[String, String]) raises:
        self.data = MutExternalPointer[curl_slist]()
        for pair in headers.items():
            var header = pair.key.copy()
            if len(pair.value) > 0:
                header.write(": ")
                header.write(pair.value)
            else:
                header.write(";")

            try:
                self.append(header)
            except e:
                self^.free()
                raise e^

    def __init__(
        out self,
        var headers: List[String],
        var values: List[String],
        __dict_literal__: (),
    ) raises:
        self.data = MutExternalPointer[curl_slist]()
        for pair in zip(headers, values):
            var header = pair[0]
            if len(pair[1]) > 0:
                header.write(": ")
                header.write(pair[1])
            else:
                header.write(";")

            try:
                self.append(header)
            except e:
                self^.free()
                raise e^

    def __bool__(self) -> Bool:
        return Bool(self.data)

    def append(mut self, mut header: String) raises:
        var ptr = curl_ffi()[].slist_append(self.data, header.as_c_string_slice().unsafe_ptr())
        if not ptr:
            raise Error("Failed to append to curl_slist")
        self.data = ptr

    def free(deinit self):
        if self.data:
            curl_ffi()[].slist_free_all(self.data)

    def unsafe_ptr[
        origin: Origin, address_space: AddressSpace, //
    ](ref[origin, address_space] self) -> UnsafePointer[curl_slist, origin, address_space=address_space]:
        """Retrieves a pointer to the underlying memory.
        Parameters:
            origin: The origin of the `SocketAddress`.
            address_space: The `AddressSpace` of the `SocketAddress`.
        Returns:
            The pointer to the underlying memory.
        """
        return self.data.unsafe_mut_cast[origin.mut]().unsafe_origin_cast[origin]().address_space_cast[address_space]()

    @always_inline
    def __iter__(ref self) -> _CurlListIterator[origin_of(self)]:
        return _CurlListIterator(Pointer(to=self))


@fieldwise_init
struct _CurlListIterator[origin: Origin](Copyable, Iterable, Iterator):
    # TODO: Not sure if it's safe to use external origin string slices?
    comptime Element = StringSlice[MutExternalOrigin]
    comptime IteratorType[iterable_mut: Bool, //, iterable_origin: Origin[mut=iterable_mut]]: Iterator = Self

    var src: Pointer[CurlList, Self.origin]
    var curr: MutExternalPointer[curl_slist]

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
        self.curr = self.curr[].next

        return StringSlice(unsafe_from_utf8_ptr=old[].data)

    def __next__(mut self) -> Self.Element:
        """Returns the next row in the result set.

        Returns:
            The next Row object.
        """
        return self.__next_ref__()
