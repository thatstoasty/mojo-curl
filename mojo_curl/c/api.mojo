"""Global CURL FFI API singleton instance."""

from std.ffi import _get_global, _Global
from std.sys import stderr
from std import os
from std.memory.alloc import unsafe_alloc

from mojo_curl.c.bindings import curl
from mojo_curl.c.types import CURL_GLOBAL_DEFAULT, MutExternalPointer


def _init_global() -> Optional[MutExternalPointer[NoneType]]:
    var ptr = unsafe_alloc[curl](1)
    try:
        ptr.unsafe_write(curl())
    except e:
        # TODO: I'd like to remove aborting, but it'll make curl_ffi raising and viral.
        print("Failed to initialize global curl handle:", e, file=stderr)
        os.abort()

    _ = ptr[].global_init(CURL_GLOBAL_DEFAULT)
    return ptr.unsafe_bitcast[NoneType]()


def _destroy_global(lib: Optional[MutExternalPointer[NoneType]]):
    if not lib:
        return

    var p = lib.value().unsafe_bitcast[curl]()
    p[].global_cleanup()
    # Deliberately leak the OwnedDLHandles held by `curl` by freeing the
    # allocation without running the destructor. `dlclose()`ing libcurl at
    # process exit unloads it and its TLS backend on Linux, whose ELF
    # destructors then run after `curl_global_cleanup()` has already torn that
    # state down, crashing inside ld.so. The OS reclaims the mappings at exit
    # anyway; this is the standard treatment for dlopen'd libs with global state.
    p.unsafe_free()


@always_inline
def curl_ffi() -> MutExternalPointer[curl]:
    """Initializes or gets the global curl handle.

    DO NOT FREE THE POINTER MANUALLY. It will be freed automatically on program exit.

    Returns:
        A pointer to the global curl handle.
    """
    return _get_global["curl", _init_global, _destroy_global]().value().unsafe_bitcast[curl]()
