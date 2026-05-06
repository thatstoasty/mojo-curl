from std.ffi import _get_global, _Global

from mojo_curl.c.bindings import curl
from mojo_curl.c.types import CURL_GLOBAL_DEFAULT, MutExternalOpaquePointer


def _init_global() -> MutExternalOpaquePointer:
    var ptr = alloc[curl](1)
    ptr[] = curl()
    _ = ptr[].global_init(CURL_GLOBAL_DEFAULT)
    return ptr.bitcast[NoneType]()


def _destroy_global(lib: Optional[UnsafePointer[NoneType, MutExternalOrigin]]):
    if not lib:
        return

    var p = lib.value().bitcast[curl]()
    p[].global_cleanup()
    lib.value().free()


@always_inline
def curl_ffi() -> UnsafePointer[curl, MutExternalOrigin]:
    """Initializes or gets the global curl handle.

    DO NOT FREE THE POINTER MANUALLY. It will be freed automatically on program exit.

    Returns:
        A pointer to the global curl handle.
    """
    return _get_global["curl", _init_global, _destroy_global]().value().bitcast[curl]()
