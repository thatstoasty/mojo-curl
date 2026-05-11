from std.ffi import c_char, c_size_t
from std.testing import TestSuite, assert_equal, assert_true

from mojo_curl import Easy, CurlList, Result, HTTPVersion
from mojo_curl.c.types import MutExternalPointer
from mojo_curl.ssl_options import SSLOption


# ── module-level read callback ────────────────────────────────────────────────


def _empty_read(
    buf: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalPointer[NoneType],
) abi("C") -> c_size_t:
    return 0  # EOF — empty body


# ── Lifecycle ─────────────────────────────────────────────────────────────────


def test_reset_allows_reuse() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/status/200")
    _ = easy.perform()
    easy.reset()
    _ = easy.url("https://httpbin.org/status/201")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 201)


def test_describe_error_ok_non_empty() raises -> None:
    # curl_easy_strerror(CURLE_OK) returns "No error" — non-empty
    var easy = Easy()
    var desc = easy.describe_error(Result.OK)
    assert_true(desc.byte_length() > 0)


# ── Behavioral tests ──────────────────────────────────────────────────────────


def test_fail_on_error_404_fails() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/status/404")
    _ = easy.fail_on_error()
    var result = easy.perform()
    assert_true(result != Result.OK)


def test_nobody_response_code_200() raises -> None:
    # NOBODY skips body download but still gets response headers
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.nobody()
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_http_version_11_accepted() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    var set_result = easy.http_version(HTTPVersion.V1_1)
    assert_equal(set_result, Result.OK)
    assert_equal(easy.perform(), Result.OK)

# TODO: Hangs
# def test_get_mode_accepted() raises -> None:
#     var easy = Easy()
#     _ = easy.url("https://httpbin.org/get")
#     var set_result = easy.get()
#     assert_equal(set_result, Result.OK)
#     assert_equal(easy.perform(), Result.OK)

# TODO: Hangs
# def test_post_mode_accepted() raises -> None:
#     var easy = Easy()
#     _ = easy.url("https://httpbin.org/post")
#     var set_result = easy.post()
#     assert_equal(set_result, Result.OK)
#     assert_equal(easy.perform(), Result.OK)


def test_cookie_string_accepted() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/cookies")
    var set_result = easy.cookie("session=abc123")
    assert_equal(set_result, Result.OK)
    assert_equal(easy.perform(), Result.OK)


def test_connect_to_accepted() raises -> None:
    var easy = Easy()
    var list = CurlList()
    try:
        list.append("httpbin.org:443:httpbin.org:443")
        _ = easy.connect_to(list)
    except e:
        list^.free()
        raise e^
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    list^.free()
    assert_equal(result, Result.OK)


def test_upload_with_read_function() raises -> None:
    # Tests: upload(), read_function(), read_file_size()
    var easy = Easy()
    _ = easy.url("https://httpbin.org/put")
    _ = easy.upload()
    _ = easy.read_function(_empty_read)
    _ = easy.read_file_size(0)
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


# ── Simple option-acceptance tests ────────────────────────────────────────────


def test_progress_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.progress(), Result.OK)
    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    assert_equal(result, Result.OK)


def test_signal_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.signal(), Result.OK)


def test_path_as_is_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.path_as_is(), Result.OK)


def test_buffer_size_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.buffer_size(65536), Result.OK)


def test_tcp_nodelay_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.tcp_nodelay(), Result.OK)


def test_autoreferer_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.autoreferer(), Result.OK)


def test_transfer_encoding_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.transfer_encoding(), Result.OK)


def test_unrestricted_auth_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.unrestricted_auth(), Result.OK)


def test_post_redirections_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.post_redirections(3), Result.OK)


def test_post_field_size_large_returns_ok() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/post")
    assert_equal(easy.post_field_size_large(0), Result.OK)


def test_cookie_jar_returns_ok() raises -> None:
    # No path → cookies are discarded after transfer
    var easy = Easy()
    assert_equal(easy.cookie_jar(), Result.OK)


def test_cookie_session_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.cookie_session(), Result.OK)


def test_ignore_content_length_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.ignore_content_length(), Result.OK)


def test_http_content_decoding_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.http_content_decoding(), Result.OK)


def test_http_transfer_decoding_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.http_transfer_decoding(), Result.OK)


def test_resume_from_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.resume_from(0), Result.OK)


def test_fetch_filetime_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.fetch_filetime(), Result.OK)


def test_max_filesize_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.max_filesize(10_000_000), Result.OK)


def test_low_speed_limit_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.low_speed_limit(1), Result.OK)


def test_low_speed_time_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.low_speed_time(30), Result.OK)


def test_max_send_speed_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.max_send_speed(0), Result.OK)


def test_max_recv_speed_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.max_recv_speed(0), Result.OK)


def test_maxage_conn_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.maxage_conn(300), Result.OK)


def test_fresh_connect_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.fresh_connect(), Result.OK)


def test_forbid_reuse_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.forbid_reuse(), Result.OK)


def test_port_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.port(443), Result.OK)


def test_ssl_verify_host_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.ssl_verify_host(), Result.OK)


def test_ssl_verify_peer_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.ssl_verify_peer(), Result.OK)


def test_ssl_cipher_list_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.ssl_cipher_list("HIGH:!aNULL"), Result.OK)


def test_ssl_sessionid_cache_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.ssl_sessionid_cache(), Result.OK)


def test_ssl_options_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.ssl_options(SSLOption.NO_PARTIALCHAIN), Result.OK)


def test_expect_100_timeout_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.expect_100_timeout(1000), Result.OK)


def test_wildcard_match_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.wildcard_match(), Result.OK)


def test_doh_url_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.doh_url("https://cloudflare-dns.com/dns-query"), Result.OK)


def test_pipewait_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.pipewait(), Result.OK)


def test_http_09_allowed_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.http_09_allowed(), Result.OK)


def test_certinfo_returns_ok() raises -> None:
    var easy = Easy()
    assert_equal(easy.certinfo(), Result.OK)


# def test_dns_servers_returns_ok() raises -> None:
#     var easy = Easy()
#     assert_equal(easy.dns_servers("8.8.8.8"), Result.OK)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
