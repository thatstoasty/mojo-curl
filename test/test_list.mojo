from std.testing import TestSuite, assert_equal, assert_true, assert_false

from mojo_curl import CurlList
from mojo_curl.c.types import curl_slist


def _count_nodes(list: CurlList) -> Int:
    """Traverses the underlying curl_slist linked list and returns the node count."""
    if list.is_empty():
        return 0
    var count = 1
    var node_ptr = list.data.value()
    while Int(node_ptr[].next) != 0:
        node_ptr = node_ptr[].next
        count += 1
    return count


def test_empty_init_is_falsy() raises -> None:
    var list = CurlList()
    var is_empty = list.is_empty()
    list^.free()
    assert_true(is_empty)


def test_append_single_makes_list_truthy() raises -> None:
    var list = CurlList()
    try:
        list.append("Content-Type: application/json")
    except e:
        list^.free()
        raise e^
    var is_empty = list.is_empty()
    list^.free()
    assert_false(is_empty)


def test_append_increments_node_count() raises -> None:
    var list = CurlList()
    try:
        list.append("X-First: one")
        list.append("X-Second: two")
        list.append("X-Third: three")
    except e:
        list^.free()
        raise e^
    var count = _count_nodes(list)
    list^.free()
    assert_equal(count, 3)


def test_init_from_empty_dict_is_falsy() raises -> None:
    var headers = Dict[String, String]()
    var list = CurlList(headers)
    var is_empty = list.is_empty()
    list^.free()
    assert_true(is_empty)


def test_init_from_dict_is_truthy() raises -> None:
    var headers = Dict[String, String]()
    headers["Content-Type"] = "application/json"
    headers["Authorization"] = "Bearer token"
    var list = CurlList(headers)
    var is_empty = list.is_empty()
    var count = _count_nodes(list)
    list^.free()
    assert_false(is_empty)
    assert_equal(count, 2)


def test_free_empty_list_does_not_crash() raises -> None:
    var list = CurlList()
    list^.free()


def test_free_nonempty_list_does_not_crash() raises -> None:
    var list = CurlList()
    try:
        list.append("X-Test: value")
    except e:
        list^.free()
        raise e^
    list^.free()


def test_append_suppress_header_format() raises -> None:
    # A header appended with trailing ";" suppresses that header in the request.
    var list = CurlList()
    try:
        list.append("Accept;")
    except e:
        list^.free()
        raise e^
    var is_empty = list.is_empty()
    var count = _count_nodes(list)
    list^.free()
    assert_false(is_empty)
    assert_equal(count, 1)


def test_single_node_count() raises -> None:
    var list = CurlList()
    try:
        list.append("X-Only: header")
    except e:
        list^.free()
        raise e^
    var count = _count_nodes(list)
    list^.free()
    assert_equal(count, 1)


def test_iteration_yields_items_in_order() raises -> None:
    var list = CurlList()
    try:
        list.append("X-First: one")
        list.append("X-Second: two")
        list.append("X-Third: three")
    except e:
        list^.free()
        raise e^

    var collected = List[String]()
    for item in list:
        collected.append(String(item))
    list^.free()

    assert_equal(len(collected), 3)
    assert_equal(collected[0], "X-First: one")
    assert_equal(collected[1], "X-Second: two")
    assert_equal(collected[2], "X-Third: three")


def test_iteration_over_empty_list_yields_nothing() raises -> None:
    var list = CurlList()
    var count = 0
    for _ in list:
        count += 1
    list^.free()
    assert_equal(count, 0)


def main() raises -> None:
    TestSuite.discover_tests[__functions_in_module()]().run()
