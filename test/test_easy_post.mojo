from std.testing import TestSuite, assert_equal, assert_true

from mojo_curl import Easy, Result


def test_post_fields() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/post")
    var set_result = easy.post_fields("field1=value1&field2=value2".as_bytes())
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def test_post_fields_copy() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/post")
    var data: String = "copied=true&key=value"
    var set_result = easy.post_fields_copy(data.as_bytes())
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def test_post_field_size() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/post")
    var postdata: String = "name=daniel&project=curl"
    _ = easy.post_fields(postdata.as_bytes())
    var set_result = easy.post_field_size(postdata.byte_length())
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def test_custom_request_put() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/put")
    var set_result = easy.custom_request("PUT")
    assert_equal(set_result, Result.OK)
    # PUT with no body needs an explicit content-length of 0
    _ = easy.post_field_size(0)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def test_custom_request_delete() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/delete")
    var set_result = easy.custom_request("DELETE")
    assert_equal(set_result, Result.OK)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def test_custom_request_patch() raises -> None:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/patch")
    var set_result = easy.custom_request("PATCH")
    assert_equal(set_result, Result.OK)
    _ = easy.post_field_size(0)
    var result = easy.perform()
    assert_equal(result, Result.OK)
    assert_equal(easy.response_code(), 200)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
