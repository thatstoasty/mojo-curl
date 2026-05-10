from std.ffi import c_char, c_size_t
from std.testing import TestSuite, assert_equal, assert_true

from mojo_curl import Easy, Result
from mojo_curl.c.types import MutExternalPointer


# ── module-level callbacks ────────────────────────────────────────────────────

def _count_callback(
    ptr: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalPointer[NoneType],
) abi("C") -> c_size_t:
    var total = size * nmemb
    var counter = userdata.bitcast[Int]()
    counter[] += Int(total)
    return total


def _buffer_callback(
    contents: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalPointer[NoneType],
) abi("C") -> c_size_t:
    var realsize = size * nmemb
    var buf = userdata.bitcast[List[UInt8]]()
    buf[].extend(Span(ptr=contents.bitcast[UInt8](), length=Int(realsize)))
    return realsize


# ── tests ─────────────────────────────────────────────────────────────────────

def test_write_function_receives_bytes() raises -> None:
    var easy = Easy()
    var byte_count: Int = 0
    _ = easy.url("https://httpbin.org/get")
    _ = easy.write_function(_count_callback)
    _ = easy.write_data(UnsafePointer(to=byte_count).bitcast[NoneType]())
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_true(byte_count > 0)


def test_write_function_and_write_data_fill_buffer() raises -> None:
    var easy = Easy()
    var chunk = List[UInt8]()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.write_function(_buffer_callback)
    _ = easy.write_data(UnsafePointer(to=chunk).bitcast[NoneType]())
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_true(len(chunk) > 0)


def test_useragent_is_accepted() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.useragent("mojo-curl-test/1.0")
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_response_code_200() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/status/200")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def test_response_code_404() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/status/404")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 404)


def test_content_type_json() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/json")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    var ct = easy.content_type()
    assert_true("json" in ct)


def test_effective_url_matches_request() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    var url = easy.effective_url()
    assert_true("httpbin.org" in url)


def test_get_scheme_is_https() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.get_scheme(), "https")


def test_header_size_is_positive() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_true(easy.header_size() > 0)


def test_primary_ip_is_set() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    var ip = easy.primary_ip()
    assert_true(ip.byte_length() > 0)


def test_primary_port_is_443() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.primary_port(), 443)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
