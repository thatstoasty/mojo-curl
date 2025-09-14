from sys.ffi import _get_global

from memory import UnsafePointer
from curl.c.bindings import curl


fn _init_global() -> UnsafePointer[NoneType]:
    var ptr = UnsafePointer[curl].alloc(1)
    ptr[] = curl()
    return ptr.bitcast[NoneType]()


fn _destroy_global(lib: UnsafePointer[NoneType]):
    var p = lib.bitcast[curl]()
    p[].lib.close()
    lib.free()


@always_inline
fn _get_global_curl_itf() -> _CurlInterfaceImpl:
    var ptr = _get_global["curl", _init_global, _destroy_global]()
    return _CurlInterfaceImpl(ptr.bitcast[curl]())


struct _CurlInterfaceImpl:
    var _curl: UnsafePointer[curl]

    fn __init__(out self, sqlite: UnsafePointer[curl]):
        self._curl = sqlite

    fn __copyinit__(out self, existing: Self):
        self._curl = existing._curl

    fn curl(self) -> curl:
        return self._curl[]


fn _impl() -> curl:
    return _get_global_curl_itf().curl()
