from std.testing import TestSuite, assert_equal, assert_true

from mojo_curl import Easy, CurlList, Result
from mojo_curl.header import HeaderOrigin


def test_http_headers_set_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var headers = CurlList({
        "X-Custom-Header": "test-value",
        "Accept": "application/json",
    })
    var set_result = easy.http_headers(headers)
    var perform_result = easy.perform()
    headers^.free()
    assert_equal(set_result, Result.OK)
    assert_equal(perform_result, Result.OK)


def test_response_headers_not_empty() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    var hdrs = easy.headers()
    assert_true(len(hdrs) > 0)


def test_response_headers_has_content_type() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/json")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    var hdrs = easy.headers()
    assert_true("content-type" in hdrs)
    assert_true("json" in hdrs["content-type"])


def test_show_header_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.show_header(show=True)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_referer_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.referer("https://httpbin.org/referrer")
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_follow_location_follows_redirect() raises -> None:
    var easy = Easy()
    # /redirect/1 returns a 302 to /get
    _ = easy.url("https://httpbin.org/redirect/1")
    var set_result = easy.follow_location()
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def test_redirect_count_after_follow() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/redirect/2")
    _ = easy.follow_location()
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.redirect_count(), 2)


def test_redirect_url_without_follow() raises -> None:
    var easy = Easy()
    # Do NOT follow the redirect so redirect_url is populated
    _ = easy.url("https://httpbin.org/redirect-to?url=https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)
    var code = easy.response_code()
    if (code // 100) == 3:
        var rurl = easy.redirect_url()
        assert_true(rurl.byte_length() > 0)


def test_http_headers_remove_accept() raises -> None:
    # Empty value removes the header
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var headers = CurlList({"Accept": ""})
    _ = easy.http_headers(headers)
    var result = easy.perform()
    headers^.free()
    assert_equal(result, Result.OK)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
