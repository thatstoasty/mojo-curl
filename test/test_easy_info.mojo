from std.testing import TestSuite, assert_equal, assert_true

from mojo_curl import Easy, Result


# All tests perform a GET to https://httpbin.org/get and then query info
# getters. Timing values are cumulative from the start of the transfer.


def test_request_size_is_positive() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.request_size() > 0)


def test_local_ip_is_set() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    var ip = easy.local_ip()
    assert_true(ip.byte_length() > 0)


def test_local_port_is_positive() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.local_port() > 0)


def test_total_time_is_positive() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.total_time() > 0.0)


def test_namelookup_time_is_nonnegative() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.namelookup_time() >= 0.0)


def test_connect_time_is_nonnegative() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.connect_time() >= 0.0)


def test_pretransfer_time_is_nonnegative() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.pretransfer_time() >= 0.0)


def test_starttransfer_time_is_nonnegative() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.starttransfer_time() >= 0.0)


def test_appconnect_time_positive_for_tls() raises -> None:
    # TLS handshake time must be > 0 for any HTTPS connection
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.appconnect_time() > 0.0)


def test_speed_download_is_nonnegative() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_true(easy.speed_download() >= 0.0)


def test_os_errno_is_zero_on_success() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.os_errno(), 0)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
