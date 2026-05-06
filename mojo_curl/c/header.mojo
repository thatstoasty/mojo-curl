from std.ffi import c_size_t, c_uint, c_char, c_int
from mojo_curl.c.types import MutExternalPointer, MutExternalOpaquePointer


struct curl_header:
    """Struct representing a single header in the CURLH API."""
    var name: MutExternalPointer[c_char]
    """Pointer to the header name string."""
    var value: MutExternalPointer[c_char]
    """Pointer to the header value string."""
    var amount: c_size_t
    """Amount of data in the header."""
    var index: c_size_t
    """Index of the header."""
    var origin: c_uint
    """Origin of the header."""
    var anchor: MutExternalOpaquePointer
    """Pointer to the anchor."""


struct HeaderOrigin(TrivialRegisterPassable):
    """CURLH origin bits."""

    var value: c_uint
    """[CURLH] Header origin bits for `curl_easy_nextheader`."""

    comptime HEADER: Self = (1 << 0)
    """[CURLH_HEADER] Plain server header."""
    comptime TRAILER: Self = (1 << 1)
    """[CURLH_TRAILER] Trailers."""
    comptime CONNECT: Self = (1 << 2)
    """[CURLH_CONNECT] Connect response headers."""
    comptime _1XX: Self = (1 << 3)
    """[CURLH_1XX] 1xx headers."""
    comptime PSEUDO: Self = (1 << 4)
    """[CURLH_PSEUDO] Pseudo headers."""

    @implicit
    def __init__(out self, value: Int):
        self.value = c_uint(value)


struct CurlHeaderResult(TrivialRegisterPassable):
    """CURLHcode result codes."""

    var value: c_int
    """[CURLHcode] Result codes for `curl_easy_nextheader`."""

    comptime OK: Self = 0
    """[CURLHE_OK] Header exists, but not with this index."""
    comptime BAD_INDEX: Self = 1
    """[CURLHE_BADINDEX] No such header exists."""
    comptime MISSING: Self = 2
    """[CURLHE_MISSING] No headers at all exist (yet)."""
    comptime NO_HEADERS: Self = 3
    """[CURLHE_NOHEADERS] No request with this number was used."""
    comptime NO_REQUEST: Self = 4
    """[CURLHE_NOREQUEST] Out of memory while processing."""
    comptime OUT_OF_MEMORY: Self = 5
    """[CURLHE_OUT_OF_MEMORY] A function argument was not okay."""
    comptime BAD_ARGUMENT: Self = 6
    """[CURLHE_BAD_ARGUMENT] If API was disabled in the build."""
    comptime NOT_BUILT_IN: Self = 7
    """[CURLHE_NOT_BUILT_IN] If API was disabled in the build."""

    @implicit
    def __init__(out self, value: Int):
        self.value = c_int(value)
