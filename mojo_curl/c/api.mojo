from std.ffi import _get_global, _Global
from std.sys import stderr
from std import os

from mojo_curl.c.bindings import curl
from mojo_curl.c.types import CURL_GLOBAL_DEFAULT, MutExternalPointer


def _init_global() -> Optional[MutExternalPointer[NoneType]]:
    var ptr = alloc[curl](1)
    try:
        ptr[] = curl()
    except e:
        print("Failed to initialize global curl handle:", e, file=stderr)
        os.abort()

    _ = ptr[].global_init(CURL_GLOBAL_DEFAULT)
    return ptr.bitcast[NoneType]()

def _destroy_global(lib: Optional[MutExternalPointer[NoneType]]):
    if not lib:
        return

    var p = lib.value().bitcast[curl]()
    p[].global_cleanup()
    lib.value().free()


@always_inline
def curl_ffi() -> MutExternalPointer[curl]:
    """Initializes or gets the global curl handle.

    DO NOT FREE THE POINTER MANUALLY. It will be freed automatically on program exit.

    Returns:
        A pointer to the global curl handle.
    """
    return _get_global["curl", _init_global, _destroy_global]().value().bitcast[curl]()
