from mojo_curl.c.types import MutExternalPointer, MutExternalOpaquePointer
from sys.ffi import c_size_t, c_uint, c_char, c_int


struct curl_header:
    var name: MutExternalPointer[c_char]
    var value: MutExternalPointer[c_char]
    var amount: c_size_t
    var index: c_size_t
    var origin: c_uint
    var anchor: MutExternalOpaquePointer


struct HeaderOrigin:
    """CURLH origin bits."""
    var value: c_uint
    """[CURLH] Header origin bits for `curl_easy_nextheader`."""

    comptime HEADER: Self = (1<<0)
    """[CURLH_HEADER] Plain server header."""
    comptime TRAILER: Self = (1<<1)
    """[CURLH_TRAILER] Trailers."""
    comptime CONNECT: Self = (1<<2)
    """[CURLH_CONNECT] Connect response headers."""
    comptime _1XX: Self = (1<<3)
    """[CURLH_1XX] 1xx headers."""
    comptime PSEUDO: Self = (1<<4)
    """[CURLH_PSEUDO] Pseudo headers."""

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


struct CurlHeaderResult:
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
    fn __init__(out self, value: Int):
        self.value = value
