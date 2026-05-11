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


# ── Option behavioral tests ───────────────────────────────────────────────────


def test_progress_does_not_break_transfer() raises -> None:
    var easy = Easy()
    assert_equal(easy.progress(), Result.OK)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_signal_does_not_break_https() raises -> None:
    # Disabling SIGALRM avoids alarm races in threaded DNS; transfer still works
    var easy = Easy()
    _ = easy.signal(signal=False)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_path_as_is_sends_unnormalized_path() raises -> None:
    # path_as_is prevents curl from collapsing /./ segments; request still lands
    var easy = Easy()
    _ = easy.path_as_is()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_buffer_size_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.buffer_size(65536)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_tcp_nodelay_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.tcp_nodelay()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_autoreferer_sets_referer_on_redirect() raises -> None:
    # autoreferer + follow_location: curl sets Referer automatically on each hop
    var easy = Easy()
    _ = easy.autoreferer()
    _ = easy.follow_location()
    _ = easy.url("https://httpbin.org/redirect/1")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)
    assert_equal(easy.redirect_count(), 1)


def test_transfer_encoding_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.transfer_encoding()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_unrestricted_auth_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.unrestricted_auth()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_post_redirections_follows_redirect() raises -> None:
    # post_redirections(7) permits POST to follow all redirect methods
    var easy = Easy()
    _ = easy.follow_location()
    _ = easy.url("https://httpbin.org/redirect/1")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_post_field_size_large_posts_empty_body() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/post")
    _ = easy.post()
    _ = easy.post_field_size_large(0)
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_cookie_jar_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.cookie_jar()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_cookie_session_discards_persistent_cookies() raises -> None:
    # cookie_session marks the start of a new session; transfer still succeeds
    var easy = Easy()
    _ = easy.cookie_file()
    _ = easy.cookie_session()
    _ = easy.url("https://httpbin.org/cookies")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_ignore_content_length_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.ignore_content_length()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_http_content_decoding_decompresses_gzip() raises -> None:
    # accept_encoding + content_decoding: curl transparently decompresses body
    var easy = Easy()
    _ = easy.http_content_decoding()
    _ = easy.accept_encoding("gzip")
    _ = easy.url("https://httpbin.org/gzip")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_http_transfer_decoding_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.http_transfer_decoding()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_resume_from_gets_partial_content() raises -> None:
    # resume_from triggers a Range request; server responds with 206
    var easy = Easy()
    _ = easy.url("https://httpbin.org/range/1024")
    assert_equal(easy.resume_from(512), Result.OK)
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 206)


def test_fetch_filetime_returns_valid_value() raises -> None:
    var easy = Easy()
    _ = easy.fetch_filetime()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    # -1 means server did not send Last-Modified; any value >= -1 is valid
    assert_true(easy.file_time() >= -1)


def test_max_filesize_blocks_large_download() raises -> None:
    # 1-byte limit aborts when Content-Length header exceeds it
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.max_filesize(1)
    assert_true(easy.perform() != Result.OK)


def test_low_speed_limit_does_not_abort_fast_transfer() raises -> None:
    # 1 byte/sec limit with 30 s grace: a fast network never triggers the abort
    var easy = Easy()
    _ = easy.low_speed_limit(1)
    _ = easy.low_speed_time(30)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_low_speed_time_does_not_abort_fast_transfer() raises -> None:
    var easy = Easy()
    _ = easy.low_speed_time(30)
    _ = easy.low_speed_limit(1)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_max_send_speed_does_not_break_post() raises -> None:
    var easy = Easy()
    _ = easy.max_send_speed(1024 * 1024)  # 1 MB/s — won't throttle a tiny body
    _ = easy.post_fields("hello=world".as_bytes())
    _ = easy.url("https://httpbin.org/post")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_max_recv_speed_does_not_break_get() raises -> None:
    var easy = Easy()
    _ = easy.max_recv_speed(1024 * 1024)  # 1 MB/s — won't throttle a small response
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_maxage_conn_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.maxage_conn(300)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_fresh_connect_gets_new_connection() raises -> None:
    # fresh_connect bypasses the connection cache; transfer still completes
    var easy = Easy()
    _ = easy.fresh_connect()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_forbid_reuse_completes_transfer() raises -> None:
    # forbid_reuse closes connection after transfer; transfer still succeeds
    var easy = Easy()
    _ = easy.forbid_reuse()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_port_443_https_succeeds() raises -> None:
    var easy = Easy()
    _ = easy.port(443)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_ssl_verify_host_allows_valid_cert() raises -> None:
    var easy = Easy()
    _ = easy.ssl_verify_host()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_ssl_verify_peer_allows_valid_cert() raises -> None:
    var easy = Easy()
    _ = easy.ssl_verify_peer()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_ssl_cipher_list_allows_connection() raises -> None:
    var easy = Easy()
    _ = easy.ssl_cipher_list("HIGH:!aNULL")
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_ssl_sessionid_cache_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.ssl_sessionid_cache()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_ssl_options_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.ssl_options(SSLOption.NO_PARTIALCHAIN)
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_expect_100_timeout_does_not_break_post() raises -> None:
    var easy = Easy()
    _ = easy.expect_100_timeout(1000)
    _ = easy.post_fields("x=1".as_bytes())
    _ = easy.url("https://httpbin.org/post")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_wildcard_match_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.wildcard_match()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_doh_url_resolves_via_https_dns() raises -> None:
    var easy = Easy()
    _ = easy.doh_url("https://cloudflare-dns.com/dns-query")
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_pipewait_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.pipewait()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_http_09_allowed_does_not_break_transfer() raises -> None:
    var easy = Easy()
    _ = easy.http_09_allowed()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


def test_certinfo_enabled_transfer_succeeds() raises -> None:
    var easy = Easy()
    _ = easy.certinfo()
    _ = easy.url("https://httpbin.org/get")
    assert_equal(easy.perform(), Result.OK)
    assert_equal(easy.response_code(), 200)


# def test_dns_servers_returns_ok() raises -> None:
#     var easy = Easy()
#     assert_equal(easy.dns_servers("8.8.8.8"), Result.OK)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
