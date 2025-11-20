from mojo_curl.c.types import curl_slist, ExternalMutPointer
from mojo_curl.c.api import get_curl_handle


@explicit_destroy("CurlList must be explicitly destroyed using the `free` method.")
struct CurlList(Movable):
    var raw: ExternalMutPointer[curl_slist]

    fn __init__(out self, raw: ExternalMutPointer[curl_slist] = ExternalMutPointer[curl_slist]()):
        self.raw = raw
    
    fn __init__(out self, headers: Dict[String, String]) raises:
        self.raw = ExternalMutPointer[curl_slist]()
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
                raise e
            
    fn __init__(
        out self,
        var headers: List[String],
        var values: List[String],
        __dict_literal__: (),
    ) raises:
        self.raw = ExternalMutPointer[curl_slist]()
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
                raise e
        
    fn append(mut self, mut data: String) raises:
        var ptr = get_curl_handle()[].slist_append(self.raw, data.unsafe_cstr_ptr())
        if not ptr:
            raise Error("Failed to append to curl_slist")
        self.raw = ptr
    
    fn free(deinit self):
        if self.raw:
            get_curl_handle()[].slist_free_all(self.raw)
        
    @always_inline
    fn __iter__(ref self) -> _CurlListIterator[origin_of(self)]:
        return _CurlListIterator(Pointer(to=self))


@fieldwise_init
struct _CurlListIterator[origin: Origin](Iterator, Iterable):
    # TODO: Not sure if it's safe to use external origin string slices?
    comptime Element = StringSlice[MutOrigin.external]
    comptime IteratorType[
        iterable_mut: Bool, //, iterable_origin: Origin[iterable_mut]
    ]: Iterator = Self

    var src: Pointer[CurlList, origin]
    var curr: ExternalMutPointer[curl_slist]

    fn __init__(out self, src: Pointer[CurlList, origin]):
        self.src = src
        self.curr = src[].raw

    fn __has_next__(self) -> Bool:
        """Checks if there are more rows available.

        Returns:
            True if there are more rows to iterate over, False otherwise.
        """
        return Bool(self.curr)
    
    fn __iter__(ref self) -> Self.IteratorType[origin_of(self)]:
        return self.copy()
    
    fn __next_ref__(mut self) -> Self.Element:
        var old = self.curr
        self.curr = self.curr[].next

        return StringSlice(unsafe_from_utf8_ptr=old[].data)

    fn __next__(mut self) -> Self.Element:
        """Returns the next row in the result set.

        Returns:
            The next Row object.
        """
        return self.__next_ref__()

