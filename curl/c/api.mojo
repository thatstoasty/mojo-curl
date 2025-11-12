from sys.ffi import _get_global, _Global

from memory.legacy_unsafe_pointer import LegacyUnsafePointer
from curl.c.bindings import curl
from curl.c.types import CURL_GLOBAL_DEFAULT


fn _init_global() -> LegacyUnsafePointer[NoneType]:
    var ptr = alloc[curl](1)
    ptr[] = curl()
    _ = ptr[].global_init(CURL_GLOBAL_DEFAULT)
    return ptr.bitcast[NoneType]()


fn _destroy_global(lib: LegacyUnsafePointer[NoneType]):
    var p = lib.bitcast[curl]()
    p[].global_cleanup()
    lib.free()


@always_inline
fn get_curl_handle() -> LegacyUnsafePointer[curl]:
    """Initializes or gets the global curl handle.

    DO NOT FREE THE POINTER MANUALLY. It will be freed automatically on program exit.

    Returns:
        A pointer to the global curl handle.
    """
    return _get_global["curl", _init_global, _destroy_global]().bitcast[curl]()
