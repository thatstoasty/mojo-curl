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


fn _handle_post(easy: Easy, body: Optional[Body]) raises:
    if body:
        var result = easy.post_fields(body.value().as_bytes())
        if result != Result.OK:
            raise Error("_handle_post: Failed to set POST fields: ", easy.describe_error(result))
    else:
        # Set POST with zero-length body
        var result = easy.post(True)
        if result != Result.OK:
            raise Error("_handle_post: Failed to set POST method: ", easy.describe_error(result))

fn _handle_put(easy: Easy) raises:
    var result = easy.upload(True)
    if result != Result.OK:
        raise Error("_handle_put: Failed to set PUT method: ", easy.describe_error(result))


fn _handle_delete(easy: Easy) raises:
    var http_method = "DELETE"
    var result = easy.custom_request(http_method)
    if result != Result.OK:
        raise Error("_handle_delete: Failed to set DELETE method: ", easy.describe_error(result))


fn _handle_patch(easy: Easy, body: Optional[Body]) raises:
    var http_method = "PATCH"
    var result = easy.custom_request(http_method)
    if result != Result.OK:
        raise Error("_handle_patch: Failed to set PATCH method: ", easy.describe_error(result))
    
    if body:
        var result = easy.post_fields(body.value().as_bytes())
        if result != Result.OK:
            raise Error("_handle_patch: Failed to set POST fields: ", easy.describe_error(result))


fn _handle_head(easy: Easy) raises:
    var http_method = "HEAD"
    var result = easy.custom_request(http_method)
    if result != Result.OK:
        raise Error("_handle_head: Failed to set HEAD method: ", easy.describe_error(result))


fn _handle_options(easy: Easy) raises:
    var http_method = "OPTIONS"
    var result = easy.custom_request(http_method)
    if result != Result.OK:
        raise Error("_handle_options: Failed to set OPTIONS method: ", easy.describe_error(result))


struct Session:
    var allow_redirects: Bool
    var easy: Easy

    fn __init__(
        out self,
        allow_redirects: Bool = False,
    ):
        self.allow_redirects = allow_redirects
        self.easy = Easy()
    
    fn raise_if_error(self, code: Result) raises:
        if code != Result.OK:
            raise Error("Session: Curl error: ", self.easy.describe_error(code))

    fn send[method: RequestMethod](
        self,
        mut url: String,
        var headers: Dict[String, String],
        body: Optional[Body] = None,
        timeout: Optional[Int] = None,
        query_parameters: Dict[String, String] = {},
    ) raises -> HTTPResponse:
        """Sends an HTTP request and returns the corresponding response.

        Params:
            method: The HTTP method to use for the request.

        Args:
            url: The URL to which the request is sent.
            headers: A dictionary of HTTP headers to include in the request.
            body: An optional Body object representing the request body.
            timeout: An optional timeout in seconds for the request.
            query_parameters: An optional dictionary of query parameters to include in the URL. GET requests only.

        Returns:
            The received response as an `HTTPResponse` object.

        Raises:
            Error: If there is a failure in sending or receiving the message.
        """
        # Set the url
        if query_parameters:
            # URL-encode the parameter values
            # TODO: This is inefficient w/ string copies, but it's ok for now. I'm not sure if we can get mutable
            # references to the values in the dictionary as we iterate rn.
            var params: List[String] = []
            for pair in query_parameters.items():
                var value = pair.value
                params.append(String(pair.key, "=", self.easy.escape(value)))
            
            # Append the query parameters to the URL. Thi
            var full_url = String(url, "?", "&".join(params))
            print("Full URL with query parameters: ", full_url)
            self.raise_if_error(self.easy.url(full_url))
        else:
            self.raise_if_error(self.easy.url(url))
        
        # Set the buffer to load the response into
        var response_body = List[UInt8]()
        self.raise_if_error(self.easy.write_data(UnsafePointer(to=response_body).bitcast[NoneType]()))

        # Set the write callback to load the response data into the above buffer.
        self.raise_if_error(self.easy.write_function(write_callback))
        
        # Set method specific curl options
        @parameter
        if method == RequestMethod.POST:
            _handle_post(self.easy, body)
        elif method == RequestMethod.PUT:
            _handle_put(self.easy)
        elif method == RequestMethod.DELETE:
            _handle_delete(self.easy)
        elif method == RequestMethod.PATCH:
            _handle_patch(self.easy, body)
        elif method == RequestMethod.HEAD:
            _handle_head(self.easy)
        elif method == RequestMethod.OPTIONS:
            _handle_options(self.easy)

        var list = CurlList(headers^)
        try:
            # Set headers
            self.raise_if_error(self.easy.http_headers(list))
            
            # Perform the transfer
            self.raise_if_error(self.easy.perform())
        finally:
            list^.free()

        return HTTPResponse.from_bytes(self.easy, response_body)

    fn get(
        self,
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
            query_parameters=query_parameters,
        )

    fn post(
        self,
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
    
    fn post[origin: Origin](
        self,
        var url: String,
        data: Span[Byte, origin],
        var headers: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a POST request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            data: The data to include in the body of the POST request.
            headers: HTTP headers to include in the request.
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
        self,
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
    
    fn put[origin: Origin](
        self,
        var url: String,
        data: Span[Byte, origin],
        var headers: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a PUT request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            data: The data to include in the body of the PUT request.
            headers: HTTP headers to include in the request.
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
        self,
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
        self,
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
    
    fn patch[origin: Origin](
        self,
        var url: String,
        data: Span[Byte, origin],
        var headers: Dict[String, String] = {},
        timeout: Optional[Int] = None,
    ) raises -> HTTPResponse:
        """Sends a GET request to the specified URL.

        Args:
            url: The URL to which the request is sent.
            data: The data to include in the body of the PATCH request.
            headers: HTTP headers to include in the request.
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
        self,
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
        self,
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