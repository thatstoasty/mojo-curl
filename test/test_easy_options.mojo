from std.ffi import c_long
from std.testing import TestSuite, assert_equal, assert_true

from mojo_curl import Easy, CurlList, Option, Result


# ── Behavior options ──────────────────────────────────────────────────────────

def test_verbose_returns_ok() raises -> None:
    var easy = Easy()
    var set_result = easy.verbose(verbose=True)
    assert_equal(set_result, Result.OK)
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_accept_encoding_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.accept_encoding("gzip")
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


# ── Connection options ────────────────────────────────────────────────────────

def test_dns_cache_timeout_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.dns_cache_timeout(60)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_timeout_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.timeout(10_000)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_connect_timeout_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.connect_timeout(5_000)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_ip_resolve_any_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    # CURL_IPRESOLVE_WHATEVER = 0
    var set_result = easy.ip_resolve(0)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_tcp_keepalive_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.tcp_keepalive(enable=True)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_tcp_keepidle_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.tcp_keepalive(enable=True)
    var set_result = easy.tcp_keepidle(60)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_tcp_keepintvl_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.tcp_keepalive(enable=True)
    var set_result = easy.tcp_keepintvl(30)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_max_connects_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.max_connects(1)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_set_local_port_range_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var r1 = easy.set_local_port(0)
    assert_equal(r1, Result.OK)
    var r2 = easy.local_port_range(1)
    assert_equal(r2, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_max_redirections_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/redirect/1")
    _ = easy.follow_location()
    var set_result = easy.max_redirections(5)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_resolve_overrides_dns() raises -> None:
    # Map httpbin.org:443 to a known IP so curl skips DNS lookup
    var easy = Easy()
    var hosts = CurlList()
    try:
        hosts.append("httpbin.org:443:54.211.60.7")
        _ = easy.resolve(hosts)
    except e:
        hosts^.free()
        raise e^
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    hosts^.free()
    assert_equal(result, Result.OK)


# ── Protocol options ──────────────────────────────────────────────────────────

def test_range_bytes() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/range/1024")
    var set_result = easy.range("0-511")
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    # Server returns 206 Partial Content for a byte-range request
    assert_equal(easy.response_code(), 206)


# ── Cookie options ────────────────────────────────────────────────────────────

def test_cookie_file_enables_engine() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/cookies/set?session=abc")
    _ = easy.follow_location()
    var set_result = easy.cookie_file()
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_cookie_list_adds_cookie() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.cookie_file()
    var set_result = easy.cookie_list(
        ".httpbin.org\tTRUE\t/\tFALSE\t4102444800\tsession\tabc"
    )
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_cookies_returns_list() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/cookies/set?k=v")
    _ = easy.follow_location()
    _ = easy.cookie_file()
    var result = easy.perform()
    assert_equal(result, Result.OK)
    var jar = easy.cookies()
    # The jar is valid (may or may not contain cookies depending on redirect handling)
    jar^.free()


# ── Utility ───────────────────────────────────────────────────────────────────

def test_escape_encodes_spaces() raises -> None:
    var easy = Easy()
    var encoded = easy.escape("hello world")
    assert_true("hello" in encoded)
    assert_true("world" in encoded)
    # Space should be encoded (as %20 or +)
    assert_true(" " not in encoded)


def test_netrc_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    # CURL_NETRC_OPTIONAL = 1
    var set_result = easy.netrc(1)
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
