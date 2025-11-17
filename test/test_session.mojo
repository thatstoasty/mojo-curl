from testing import TestSuite, assert_equal
from curl.session import Session
from curl.http import StatusCode


fn test_get() raises -> None:
    var client = Session()
    var response = client.get(
        "https://example.com",
        {"Content-Type": "application/json"}
    )

    assert_equal(response.status_code, StatusCode.OK)
    print("Headers:")
    for pair in response.headers.items():
        print(String(pair.key, ": ", pair.value))

    # print("Is connection set to connection-close? ", response.connection_close())

    print(response.body.as_string_slice())


fn test_get_query_parameters() raises -> None:
    var client = Session()
    var response = client.get(
        "https://httpbin.org/get",
        query_parameters={
            "param1": "value1",
            "param2": "value2",
        }
    )

    assert_equal(response.status_code, StatusCode.OK)
    print("Headers:")
    for pair in response.headers.items():
        print(String(pair.key, ": ", pair.value))

    # print("Is connection set to connection-close? ", response.connection_close())

    print(response.body.as_string_slice())


fn test_post() raises -> None:
    var client = Session()
    var response = client.post(
        "https://jsonplaceholder.typicode.com/todos",
        {
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        data={"key1": "value1", "key2": "value2"},
    )
    assert_equal(response.status_code, StatusCode.CREATED)
    print("Body:")
    for pair in response.body.as_dict().items():
        print(String(pair.key, ": ", pair.value))


fn test_put() raises -> None:
    var client = Session()
    var response = client.put(
        "https://jsonplaceholder.typicode.com/posts/1",
        {
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        data={"key1": "updated_value1", "key2": "updated_value2"},
    )
    print("PUT Response Body:")
    print(response.body.as_string_slice())
    assert_equal(response.status_code.value, 200)


fn test_patch() raises -> None:
    var client = Session()
    var response = client.patch(
        "https://jsonplaceholder.typicode.com/posts/1",
        {
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        data={"key1": "patched_value"},
    )
    assert_equal(response.status_code, StatusCode.OK)
    print("PATCH Response Body:")
    print(response.body.as_string_slice())


fn test_delete() raises -> None:
    var client = Session()
    var response = client.delete("https://jsonplaceholder.typicode.com/posts/1")
    assert_equal(response.status_code, StatusCode.OK)
    print("DELETE Response Body:")
    print(response.body.as_string_slice())


# fn test_head() raises -> None:
#     var client = Session()
#     var response = client.head(
#         "https://httpbin.org/get",
#         {"Accept": "application/json"},
#     )
#     print("HEAD Response Status Code:", response.status_code)
#     print("HEAD Response Headers:")
#     for pair in response.headers.items():
#         print(String(pair.key, ": ", pair.value))
#     print("HEAD Response Body Length:", len(response.body.as_string_slice()))


# fn test_options() raises -> None:
#     var client = Session()
#     var response = client.options(
#         "https://httpbin.org/get",
#         {"Accept": "application/json"},
#     )
#     print("OPTIONS Response Status Code:", response.status_code)
#     print("OPTIONS Response Headers:")
#     for pair in response.headers.items():
#         print(String(pair.key, ": ", pair.value))
#     print("OPTIONS Response Body:")
#     print(response.body.as_string_slice())


fn main() raises -> None:
    # TestSuite.discover_tests[__functions_in_module()]().run()
    var suite = TestSuite()
    suite.test[test_put]()
    suite^.run()
