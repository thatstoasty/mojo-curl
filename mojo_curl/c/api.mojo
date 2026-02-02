from sys.ffi import _get_global, _Global

from mojo_curl.c.bindings import curl
from mojo_curl.c.types import CURL_GLOBAL_DEFAULT

comptime MutExternalOpaquePointer = UnsafePointer[NoneType, MutExternalOrigin]


fn _init_global() -> MutExternalOpaquePointer:
    var ptr = alloc[curl](1)
    ptr[] = curl()
    _ = ptr[].global_init(CURL_GLOBAL_DEFAULT)
    return ptr.bitcast[NoneType]()


fn _destroy_global(lib: MutExternalOpaquePointer):
    var p = lib.bitcast[curl]()
    p[].global_cleanup()
    lib.free()


@always_inline
fn curl_ffi() -> UnsafePointer[curl, MutExternalOrigin]:
    """Initializes or gets the global curl handle.

    DO NOT FREE THE POINTER MANUALLY. It will be freed automatically on program exit.

    Returns:
        A pointer to the global curl handle.
    """
    return _get_global["curl", _init_global, _destroy_global]().bitcast[curl]()
