from curl.response import HTTPResponse
from curl.easy import Easy, Result
from curl.list import CurlList
from curl.http import RequestMethod
from curl.c.types import c_char, c_size_t, ExternalImmutPointer, ExternalMutOpaquePointer
from curl.body import Body


fn write_callback(ptr: ExternalImmutPointer[c_char], size: c_size_t, nmemb: c_size_t, userdata: ExternalMutOpaquePointer) -> c_size_t:
    var body = userdata.bitcast[List[UInt8]]()
    var s = Span(ptr=ptr.bitcast[UInt8](), length=Int(size * nmemb))
    body[] = List[UInt8](span=s)
    return size * nmemb


struct Session:
    var allow_redirects: Bool

    fn __init__(
        out self,
        allow_redirects: Bool = False,
    ):
        self.allow_redirects = allow_redirects

    fn send[method: RequestMethod](
        mut self,
        mut url: String,
        var headers: Dict[String, String],
        body: Optional[Body] = None,
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends an HTTP request and returns the corresponding response.

        Params:
            method: The HTTP method to use for the request.

        Args:
            url: The URL to which the request is sent.
            headers: A dictionary of HTTP headers to include in the request.
            body: An optional Body object representing the request body.
            timeout: An optional timeout in seconds for the request.

        Returns:
            The received response as an `HTTPResponse` object.

        Raises:
            Error: If there is a failure in sending or receiving the message.
        """
        var easy = Easy()

        # Set the url
        var result = easy.url(url)
        if result != Result.OK:
            raise Error("Session.send: Failed to set URL: ", easy.describe_error(result))

        # Set the buffer to load the response into
        var response_body = List[UInt8]()
        result = easy.write_data(UnsafePointer(to=response_body).bitcast[NoneType]())
        if result != Result.OK:
            raise Error("Session.send: Failed to set write data ptr: ", easy.describe_error(result))
        
        # Set the write callback to load the response data into the above buffer.
        result = easy.write_function(write_callback)
        if result != Result.OK:
            raise Error("Session.send: Failed to set write function: ", easy.describe_error(result))
        
        @parameter
        if method == RequestMethod.POST:
            if body:
                result = easy.post_fields(body.value().as_bytes())
                if result != Result.OK:
                    raise Error("Session.send: Failed to set POST fields: ", easy.describe_error(result))
            else:
                # Set POST with zero-length body
                result = easy.post(True)
                if result != Result.OK:
                    raise Error("Session.send: Failed to set POST method: ", easy.describe_error(result))
        # elif method == RequestMethod.PUT:
        #     result = easy.put(True)
        #     if result != Result.OK:
        #         raise Error("Session.send: Failed to set PUT method: ", easy.describe_error(result))

        # Set headers
        var list = CurlList(headers^)
        result = easy.http_headers(list)
        if result != Result.OK:
            list^.free()
            raise Error("Session.send: Failed to set HTTP headers: ", easy.describe_error(result))
        
        # Perform the transfer
        var response = easy.perform()
        if response != Result.OK:
            list^.free()
            raise Error("Session.send: Failed to perform request: ", easy.describe_error(response))

        list^.free()
        return HTTPResponse.from_bytes(easy, response_body)

    fn get(
        mut self,
        var url: String,
        var headers: Dict[String, String] = {},
        query_parameters: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a GET request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            headers: HTTP headers to include in the request.
            query_parameters: Query parameters to include in the request.
            timeout: An optional timeout in seconds for the request.
        
        Returns:
            The received response as an `HTTPResponse` object.
        """
        return self.send[RequestMethod.GET](
            url=url,
            headers=headers^,
            timeout=timeout,
        )

    fn post(
        mut self,
        var url: String,
        var headers: Dict[String, String] = {},
        data: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a POST request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            headers: HTTP headers to include in the request.
            data: The data to include in the body of the POST request.
            timeout: An optional timeout in seconds for the request.
        
        Returns:
            The received response as an `HTTPResponse` object.
        """
        return self.send[RequestMethod.POST](
            url=url,
            headers=headers^,
            body=Body(data),
            timeout=timeout,
        )

    fn put(
        mut self,
        var url: String,
        var headers: Dict[String, String] = {},
        data: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a PUT request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            headers: HTTP headers to include in the request.
            data: The data to include in the body of the PUT request.
            timeout: An optional timeout in seconds for the request.
        
        Returns:
            The received response as an `HTTPResponse` object.
        """
        return self.send[RequestMethod.PUT](
            url=url,
            headers=headers^,
            body=Body(data),
            timeout=timeout,
        )

    fn delete(
        mut self,
        var url: String,
        var headers: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a DELETE request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            headers: HTTP headers to include in the request.
            timeout: An optional timeout in seconds for the request.
        
        Returns:
            The received response as an `HTTPResponse` object.
        """
        return self.send[RequestMethod.DELETE](
            url=url,
            headers=headers^,
            timeout=timeout,
        )

    fn patch(
        mut self,
        var url: String,
        var headers: Dict[String, String] = {},
        data: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a GET request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            headers: HTTP headers to include in the request.
            data: The data to include in the body of the PATCH request.
            timeout: An optional timeout in seconds for the request.
        
        Returns:
            The received response as an `HTTPResponse` object.
        """
        return self.send[RequestMethod.PATCH](
            url=url,
            headers=headers^,
            body=Body(data),
            timeout=timeout,
        )

    fn head(
        mut self,
        var url: String,
        var headers: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a HEAD request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            headers: HTTP headers to include in the request.
            timeout: An optional timeout in seconds for the request.
        
        Returns:
            The received response as an `HTTPResponse` object.
        """
        return self.send[RequestMethod.HEAD](
            url=url,
            headers=headers^,
            timeout=timeout,
        )

    fn options(
        mut self,
        var url: String,
        var headers: Dict[String, String] = {},
        data: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends an OPTIONS request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            headers: HTTP headers to include in the request.
            data: The data to include in the body of the OPTIONS request.
            timeout: An optional timeout in seconds for the request.
        
        Returns:
            The received response as an `HTTPResponse` object.
        """
        return self.send[RequestMethod.OPTIONS](
            url=url,
            headers=headers^,
            body=Body(data),
            timeout=timeout,
        )