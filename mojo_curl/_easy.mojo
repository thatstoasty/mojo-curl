from sys.ffi import c_long, c_char

from mojo_curl.c import get_curl_handle, curl, CURL, Info, Option, Result, curl_write_callback, HeaderOrigin, curl_header
from mojo_curl.c.types import ExternalMutPointer


struct InnerEasy:
    var easy: CURL

    fn __init__(out self):
        self.easy = get_curl_handle()[].easy_init()
    
    fn __del__(deinit self):
        if self.easy:
            get_curl_handle()[].easy_cleanup(self.easy)

    fn set_option(self, option: Option, mut parameter: String) -> Result:
        """Set a string option for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)
    
    fn set_option[origin: ImmutOrigin](self, option: Option, parameter: Span[UInt8, origin]) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn set_option(self, option: Option, parameter: Int) -> Result:
        """Set a long/integer option for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn set_option[origin: MutOrigin](self, option: Option, parameter: MutOpaquePointer[origin]) -> Result:
        """Set a pointer option for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn set_option(self, option: Option, parameter: curl_write_callback) -> Result:
        """Set a callback function for a curl easy handle using safe wrapper."""
        return get_curl_handle()[].easy_setopt(self.easy, option.value, parameter)

    fn get_info(
        self,
        info: Info,
    ) raises -> String:
        """Get string info from a curl easy handle using safe wrapper."""
        # Data is filled by data owned curl and must not be freed by the caller (this library) :)
        var data = ExternalMutPointer[c_char]()
        var result = get_curl_handle()[].easy_getinfo(self.easy, info, data)
        if result.value != 0:
            raise Error("Failed to get info: ", self.describe_error(result))

        return String(StringSlice(unsafe_from_utf8_ptr=data))

    fn get_info_long(
        self,
        info: Info,
    ) raises -> c_long:
        """Get long info from a curl easy handle using safe wrapper."""
        var response: c_long = 0
        var result = get_curl_handle()[].easy_getinfo(self.easy, info, response)
        if result.value != 0:
            raise Error("Failed to get info: ", self.describe_error(result))

        return response

    fn get_info_float(
        self,
        info: Info,
    ) raises -> Float64:
        """Get long info from a curl easy handle using safe wrapper."""
        var response: Float64 = 0
        var result = get_curl_handle()[].easy_getinfo(self.easy, info, response)
        if result.value != 0:
            raise Error("Failed to get info: ", self.describe_error(result))

        return response

    fn perform(self) -> Result:
        """Perform a blocking file transfer."""
        return get_curl_handle()[].easy_perform(self.easy)

    fn cleanup(self) -> NoneType:
        """End a libcurl easy handle."""
        return get_curl_handle()[].easy_cleanup(self.easy)

    fn describe_error(self, code: Result) -> String:
        """Return string describing error code."""
        # TODO: StringSlice crashes, probably getting skill issued by
        # pointer lifetime. Theoretically StringSlice[ImmutAnyOrigin] should work.
        return String(unsafe_from_utf8_ptr=get_curl_handle()[].easy_strerror(code))

    # Behavior options

    fn verbose(self, verbose: Bool) -> Result:
        """Configures this handle to have verbose output to help debug protocol
        information.

        By default output goes to stderr, but the `stderr` function on this type
        can configure that. You can also use the `debug_function` method to get
        all protocol data sent and received.

        By default, this option is `false`.
        """
        return self.set_option(Option.VERBOSE, Int(verbose))

    fn show_header(self, show: Bool) -> Result:
        """Indicates whether header information is streamed to the output body of
        this request.

        This option is only relevant for protocols which have header metadata
        (like http or ftp). It's not generally possible to extract headers
        from the body if using this method, that use case should be intended for
        the `header_function` method.

        To set HTTP headers, use the `http_header` method.

        By default, this option is `false` and corresponds to
        `CURLOPT_HEADER`.
        """
        return self.set_option(Option.HEADER, Int(show))

    fn progress(self, progress: Bool) -> Result:
        """Indicates whether a progress meter will be shown for requests done with
        this handle.

        This will also prevent the `progress_function` from being called.

        By default this option is `false` and corresponds to
        `CURLOPT_NOPROGRESS`.
        """
        return self.set_option(Option.NO_PROGRESS, Int(not progress))

    fn signal(self, signal: Bool) -> Result:
        """Inform libcurl whether or not it should install signal handlers or
        attempt to use signals to perform library functions.

        If this option is disabled then timeouts during name resolution will not
        work unless libcurl is built against c-ares. Note that enabling this
        option, however, may not cause libcurl to work with multiple threads.

        By default this option is `false` and corresponds to `CURLOPT_NOSIGNAL`.
        Note that this default is **different than libcurl** as it is intended
        that this library is threadsafe by default. See the [libcurl docs] for
        some more information.

        [libcurl docs]: https://mojo_curl.haxx.se/libcurl/c/threadsafe.html
        """
        return self.set_option(Option.NO_SIGNAL, Int(not signal))

    fn wildcard_match(self, m: Bool) -> Result:
        """Indicates whether multiple files will be transferred based on the file
        name pattern.

        The last part of a filename uses fnmatch-like pattern matching.

        By default this option is `false` and corresponds to
        `CURLOPT_WILDCARDMATCH`.
        """
        return self.set_option(Option.WILDCARD_MATCH, Int(m))

    # =========================================================================
    # Error options

    # TODO: error buffer and stderr

    fn fail_on_error(self, fail: Bool) -> Result:
        """Indicates whether this library will fail on HTTP response codes >= 400.

        This method is not fail-safe especially when authentication is involved.

        By default this option is `false` and corresponds to
        `CURLOPT_FAILONERROR`.
        """
        return self.set_option(Option.FAIL_ON_ERROR, Int(fail))

    # =========================================================================
    # Network options

    fn url(self, mut url: String) -> Result:
        """Provides the URL which this handle will work with.

        The string provided must be URL-encoded with the format:

        ```text
        scheme://host:port/path
        ```

        The syntax is not validated as part of this function and that is
        deferred until later.

        By default this option is not set and `perform` will not work until it
        is set. This option corresponds to `CURLOPT_URL`.
        """
        return self.set_option(Option.URL, url)

    fn port(self, port: Int) -> Result:
        """Configures the port number to connect to, instead of the one specified
        in the URL or the default of the protocol.
        """
        return self.set_option(Option.PORT, port)

    # =========================================================================
    # Connection options

    fn connect_to(self, list: List) -> Result:
        """Connect to a specific host and port.

        Each single string should be written using the format
        `HOST:PORT:CONNECT-TO-HOST:CONNECT-TO-PORT` where `HOST` is the host of
        the request, `PORT` is the port of the request, `CONNECT-TO-HOST` is the
        host name to connect to, and `CONNECT-TO-PORT` is the port to connect
        to.

        The first string that matches the request's host and port is used.

        By default, this option is empty and corresponds to
        `CURLOPT_CONNECT_TO`.
        """
        # TODO: Implement list handling for CURLOPT_CONNECT_TO
        # This requires curl_slist support which needs to be added
        return Result(0)

    fn path_as_is(self, as_is: Bool) -> Result:
        """Indicates whether sequences of `/../` and `/./` will be squashed or not.

        By default this option is `false` and corresponds to
        `CURLOPT_PATH_AS_IS`.
        """
        return self.set_option(Option.PATH_AS_IS, Int(as_is))

    fn proxy(self, mut url: String) -> Result:
        """Provide the URL of a proxy to use.

        By default this option is not set and corresponds to `CURLOPT_PROXY`.
        """
        return self.set_option(Option.PROXY, url)

    fn proxy_port(self, port: Int) -> Result:
        """Provide port number the proxy is listening on.

        By default this option is not set (the default port for the proxy
        protocol is used) and corresponds to `CURLOPT_PROXYPORT`.
        """
        return self.set_option(Option.PROXY_PORT, port)

    fn no_proxy(self, mut skip: String) -> Result:
        """Provide a list of hosts that should not be proxied to.

        This string is a comma-separated list of hosts which should not use the
        proxy specified for connections. A single `*` character is also accepted
        as a wildcard for all hosts.

        By default this option is not set and corresponds to
        `CURLOPT_NOPROXY`.
        """
        return self.set_option(Option.NO_PROXY, skip)

    fn http_proxy_tunnel(self, tunnel: Bool) -> Result:
        """Inform curl whether it should tunnel all operations through the proxy.

        This essentially means that a `CONNECT` is sent to the proxy for all
        outbound requests.

        By default this option is `false` and corresponds to
        `CURLOPT_HTTPPROXYTUNNEL`.
        """
        return self.set_option(Option.HTTP_PROXY_TUNNEL, Int(tunnel))

    fn interface(self, mut interface: String) -> Result:
        """Tell curl which interface to bind to for an outgoing network interface.

        The interface name, IP address, or host name can be specified here.

        By default this option is not set and corresponds to
        `CURLOPT_INTERFACE`.
        """
        return self.set_option(Option.INTERFACE, interface)

    fn set_local_port(self, port: Int) -> Result:
        """Indicate which port should be bound to locally for this connection.

        By default this option is 0 (any port) and corresponds to
        `CURLOPT_LOCALPORT`.
        """
        return self.set_option(Option.LOCAL_PORT, port)

    fn local_port_range(self, range: Int) -> Result:
        """Indicates the number of attempts libcurl will perform to find a working
        port number.

        By default this option is 1 and corresponds to
        `CURLOPT_LOCALPORTRANGE`.
        """
        return self.set_option(Option.LOCAL_PORT_RANGE, range)

    fn dns_servers(self, mut servers: String) -> Result:
        """Sets the DNS servers that will be used.

        Provide a comma separated list, for example: `8.8.8.8,8.8.4.4`.

        By default this option is not set and the OS's DNS resolver is used.
        This option can only be used if libcurl is linked against
        c-ares, otherwise setting it will return an error.
        """
        return self.set_option(Option.DNS_SERVERS, servers)

    fn dns_cache_timeout(self, seconds: Int) -> Result:
        """Sets the timeout of how long name resolves will be kept in memory.

        This is distinct from DNS TTL options and is entirely speculative.

        By default this option is 60s and corresponds to
        `CURLOPT_DNS_CACHE_TIMEOUT`.
        """
        return self.set_option(Option.DNS_CACHE_TIMEOUT, seconds)

    fn doh_url(self, mut url: String) -> Result:
        """Provide the DNS-over-HTTPS URL.

        The parameter must be URL-encoded in the following format:
        `https://host:port/path`. It **must** specify a HTTPS URL.

        libcurl does not validate the syntax or use this variable until the
        transfer is issued. Even if you set a crazy value here, this method will
        still return [`Ok`].

        curl sends `POST` requests to the given DNS-over-HTTPS URL.

        To find the DoH server itself, which might be specified using a name,
        libcurl will use the default name lookup function. You can bootstrap
        that by providing the address for the DoH server with
        [`Easy2::resolve`].

        Disable DoH use again by setting this option to [`None`].

        By default this option is not set and corresponds to `CURLOPT_DOH_URL`.
        """
        return self.set_option(Option.DOH_URL, url)

    fn doh_ssl_verify_peer(self, verify: Bool) -> Result:
        """This option tells curl to verify the authenticity of the DoH
        (DNS-over-HTTPS) server's certificate. A value of `true` means curl
        verifies; `false` means it does not.

        This option is the DoH equivalent of [`Easy2::ssl_verify_peer`] and only
        affects requests to the DoH server.

        When negotiating a TLS or SSL connection, the server sends a certificate
        indicating its identity. Curl verifies whether the certificate is
        authentic, i.e. that you can trust that the server is who the
        certificate says it is. This trust is based on a chain of digital
        signatures, rooted in certification authority (CA) certificates you
        supply. curl uses a default bundle of CA certificates (the path for that
        is determined at build time) and you can specify alternate certificates
        with the [`Easy2::cainfo`] option or the [`Easy2::capath`] option.

        When `doh_ssl_verify_peer` is enabled, and the verification fails to
        prove that the certificate is authentic, the connection fails. When the
        option is zero, the peer certificate verification succeeds regardless.

        Authenticating the certificate is not enough to be sure about the
        server. You typically also want to ensure that the server is the server
        you mean to be talking to. Use [`Easy2::doh_ssl_verify_host`] for that.
        The check that the host name in the certificate is valid for the host
        name you are connecting to is done independently of the
        `doh_ssl_verify_peer` option.

        **WARNING:** disabling verification of the certificate allows bad guys
        to man-in-the-middle the communication without you knowing it. Disabling
        verification makes the communication insecure. Just having encryption on
        a transfer is not enough as you cannot be sure that you are
        communicating with the correct end-point.

        By default this option is set to `true` and corresponds to
        `CURLOPT_DOH_SSL_VERIFYPEER`.
        """
        return self.set_option(Option.DOH_SSL_VERIFY_PEER, Int(verify))

    fn doh_ssl_verify_host(self, verify: Bool) -> Result:
        """Tells curl to verify the DoH (DNS-over-HTTPS) server's certificate name
        fields against the host name.

        This option is the DoH equivalent of [`Easy2::ssl_verify_host`] and only
        affects requests to the DoH server.

        When `doh_ssl_verify_host` is `true`, the SSL certificate provided by
        the DoH server must indicate that the server name is the same as the
        server name to which you meant to connect to, or the connection fails.

        Curl considers the DoH server the intended one when the Common Name
        field or a Subject Alternate Name field in the certificate matches the
        host name in the DoH URL to which you told Curl to connect.

        When the verify value is set to `false`, the connection succeeds
        regardless of the names used in the certificate. Use that ability with
        caution!

        See also [`Easy2::doh_ssl_verify_peer`] to verify the digital signature
        of the DoH server certificate. If libcurl is built against NSS and
        [`Easy2::doh_ssl_verify_peer`] is `false`, `doh_ssl_verify_host` is also
        set to `false` and cannot be overridden.

        By default this option is set to `true` and corresponds to
        `CURLOPT_DOH_SSL_VERIFYHOST`.
        """
        return self.set_option(Option.DOH_SSL_VERIFY_HOST, Int(2 if verify else 0))

    fn proxy_cainfo(self, mut cainfo: String) -> Result:
        """Set CA certificate to verify peer against for proxy.

        By default this value is not set and corresponds to
        `CURLOPT_PROXY_CAINFO`.
        """
        return self.set_option(Option.PROXY_CAINFO, cainfo)

    fn proxy_capath(self, mut path: String) -> Result:
        """Specify a directory holding CA certificates for proxy.

        The specified directory should hold multiple CA certificates to verify
        the HTTPS proxy with. If libcurl is built against OpenSSL, the
        certificate directory must be prepared using the OpenSSL `c_rehash`
        utility.

        By default this value is not set and corresponds to
        `CURLOPT_PROXY_CAPATH`.
        """
        return self.set_option(Option.PROXY_CAPATH, path)

    fn proxy_sslcert(self, mut sslcert: String) -> Result:
        """Set client certificate for proxy.

        By default this value is not set and corresponds to
        `CURLOPT_PROXY_SSLCERT`.
        """
        return self.set_option(Option.PROXY_SSL_CERT, sslcert)

    fn proxy_sslcert_type(self, mut kind: String) -> Result:
        """Set the type of client certificate for proxy.

        By default this value is not set and corresponds to
        `CURLOPT_PROXY_SSLCERTTYPE`.
        """
        return self.set_option(Option.PROXY_SSL_CERT_TYPE, kind)

    fn proxy_sslkey(self, mut sslkey: String) -> Result:
        """Set private key for HTTPS proxy.

        By default this value is not set and corresponds to
        `CURLOPT_PROXY_SSLKEY`.
        """
        return self.set_option(Option.PROXY_SSL_KEY, sslkey)

    fn proxy_sslkey_type(self, mut kind: String) -> Result:
        """Set type of the private key file for HTTPS proxy.

        The string should be the format of your private key. Supported formats
        are "PEM", "DER" and "ENG".

        The format "ENG" enables you to load the private key from a crypto
        engine. In this case `ssl_key` is used as an identifier passed to
        the engine. You have to set the crypto engine with `ssl_engine`.
        "DER" format key file currently does not work because of a bug in
        OpenSSL.

        By default this option is "PEM" and corresponds to
        `CURLOPT_PROXY_SSLKEYTYPE`.
        """
        return self.set_option(Option.PROXY_SSL_KEY_TYPE, kind)

    fn proxy_key_password(self, mut password: String) -> Result:
        """Set passphrase to private key for HTTPS proxy.

        This will be used as the password required to use the `ssl_key`.
        You never needed a pass phrase to load a certificate but you need one to
        load your private key.

        By default this option is not set and corresponds to
        `CURLOPT_PROXY_KEYPASSWD`.
        """
        return self.set_option(Option.PROXY_KEYPASSWD, password)

    fn proxy_type(self, kind: Int) -> Result:
        """Indicates the type of proxy being used.

        By default this option is `ProxyType::Http` and corresponds to
        `CURLOPT_PROXYTYPE`.
        """
        return self.set_option(Option.PROXY_TYPE, kind)

    fn doh_ssl_verify_status(self, verify: Bool) -> Result:
        """Pass a long as parameter set to 1 to enable or 0 to disable.

        This option determines whether libcurl verifies the status of the DoH
        (DNS-over-HTTPS) server cert using the "Certificate Status Request" TLS
        extension (aka. OCSP stapling).

        This option is the DoH equivalent of CURLOPT_SSL_VERIFYSTATUS and only
        affects requests to the DoH server.

        Note that if this option is enabled but the server does not support the
        TLS extension, the verification will fail.

        By default this option is set to `false` and corresponds to
        `CURLOPT_DOH_SSL_VERIFYSTATUS`.
        """
        return self.set_option(Option.DOH_SSL_VERIFY_STATUS, Int(verify))

    fn buffer_size(self, size: Int) -> Result:
        """Specify the preferred receive buffer size, in bytes.

        This is treated as a request, not an order, and the main point of this
        is that the write callback may get called more often with smaller
        chunks.

        By default this option is the maximum write size and corresponds to
        `CURLOPT_BUFFERSIZE`.
        """
        return self.set_option(Option.BUFFER_SIZE, size)

    fn upload_buffer_size(self, size: Int) -> Result:
        """Specify the preferred send buffer size, in bytes.

        This is treated as a request, not an order, and the main point of this
        is that the read callback may get called more often with smaller
        chunks.

        The upload buffer size is by default 64 kilobytes.
        """
        return self.set_option(Option.UPLOAD_BUFFER_SIZE, size)

    # # Enable or disable TCP Fast Open
    # #
    # # By default this options defaults to `false` and corresponds to
    # # `CURLOPT_TCP_FASTOPEN`
    # fn fast_open(self, enable: Bool) -> Result:
    #

    fn tcp_nodelay(self, enable: Bool) -> Result:
        """Configures whether the TCP_NODELAY option is set, or Nagle's algorithm
        is disabled.

        The purpose of Nagle's algorithm is to minimize the number of small
        packet's on the network, and disabling this may be less efficient in
        some situations.

        By default this option is `false` and corresponds to
        `CURLOPT_TCP_NODELAY`.
        """
        return self.set_option(Option.TCP_NODELAY, Int(enable))

    fn tcp_keepalive(self, enable: Bool) -> Result:
        """Configures whether TCP keepalive probes will be sent.

        The delay and frequency of these probes is controlled by `tcp_keepidle`
        and `tcp_keepintvl`.

        By default this option is `false` and corresponds to
        `CURLOPT_TCP_KEEPALIVE`.
        """
        return self.set_option(Option.TCP_KEEPALIVE, Int(enable))

    fn tcp_keepidle(self, seconds: Int) -> Result:
        """Configures the TCP keepalive idle time wait.

        This is the delay, after which the connection is idle, keepalive probes
        will be sent. Not all operating systems support this.

        By default this corresponds to `CURLOPT_TCP_KEEPIDLE`.
        """
        return self.set_option(Option.TCP_KEEPIDLE, seconds)

    fn tcp_keepintvl(self, seconds: Int) -> Result:
        """Configures the delay between keepalive probes.

        By default this corresponds to `CURLOPT_TCP_KEEPINTVL`.
        """
        return self.set_option(Option.TCP_KEEPINTVL, seconds)

    fn address_scope(self, scope: Int) -> Result:
        """Configures the scope for local IPv6 addresses.

        Sets the scope_id value to use when connecting to IPv6 or link-local
        addresses.

        By default this value is 0 and corresponds to `CURLOPT_ADDRESS_SCOPE`
        """
        return self.set_option(Option.ADDRESS_SCOPE, scope)

    # =========================================================================
    # Names and passwords

    fn username(self, mut user: String) -> Result:
        """Configures the username to pass as authentication for this connection.

        By default this value is not set and corresponds to `CURLOPT_USERNAME`.
        """
        return self.set_option(Option.USERNAME, user)

    fn password(self, mut pass_: String) -> Result:
        """Configures the password to pass as authentication for this connection.

        By default this value is not set and corresponds to `CURLOPT_PASSWORD`.
        """
        return self.set_option(Option.PASSWORD, pass_)

    fn http_auth(self, auth: Int) -> Result:
        """Set HTTP server authentication methods to try.

        If more than one method is set, libcurl will first query the site to see
        which authentication methods it supports and then pick the best one you
        allow it to use. For some methods, this will induce an extra network
        round-trip. Set the actual name and password with the `password` and
        `username` methods.

        For authentication with a proxy, see `proxy_auth`.

        By default this value is basic and corresponds to `CURLOPT_HTTPAUTH`.
        """
        return self.set_option(Option.HTTP_AUTH, auth)

    fn aws_sigv4(self, mut param: String) -> Result:
        """Provides AWS V4 signature authentication on HTTP(S) header.

        `param` is used to create outgoing authentication headers.
        Its format is `provider1[:provider2[:region[:service]]]`.
        `provider1, provider2` are used for generating auth parameters
        such as "Algorithm", "date", "request type" and "signed headers".
        `region` is the geographic area of a resources collection. It is
        extracted from the host name specified in the URL if omitted.
        `service` is a function provided by a cloud. It is extracted
        from the host name specified in the URL if omitted.

        Example with "Test:Try", when curl will do the algorithm, it will
        generate "TEST-HMAC-SHA256" for "Algorithm", "x-try-date" and
        "X-Try-Date" for "date", "test4_request" for "request type", and
        "SignedHeaders=content-type;host;x-try-date" for "signed headers".
        If you use just "test", instead of "test:try", test will be use
        for every strings generated.

        This is a special auth type that can't be combined with the others.
        It will override the other auth types you might have set.

        By default this is not set and corresponds to `CURLOPT_AWS_SIGV4`.
        """
        return self.set_option(Option.AWS_SIGV4, param)

    fn proxy_username(self, mut user: String) -> Result:
        """Configures the proxy username to pass as authentication for this
        connection.

        By default this value is not set and corresponds to
        `CURLOPT_PROXYUSERNAME`.
        """
        return self.set_option(Option.PROXY_USERNAME, user)

    fn proxy_password(self, mut pass_: String) -> Result:
        """Configures the proxy password to pass as authentication for this
        connection.

        By default this value is not set and corresponds to
        `CURLOPT_PROXYPASSWORD`.
        """
        return self.set_option(Option.PROXY_PASSWORD, pass_)

    fn proxy_auth(self, auth: Int) -> Result:
        """Set HTTP proxy authentication methods to try.

        If more than one method is set, libcurl will first query the site to see
        which authentication methods it supports and then pick the best one you
        allow it to use. For some methods, this will induce an extra network
        round-trip. Set the actual name and password with the `proxy_password`
        and `proxy_username` methods.

        By default this value is basic and corresponds to `CURLOPT_PROXYAUTH`.
        """
        return self.set_option(Option.PROXY_AUTH, auth)

    fn netrc(self, netrc: Int) -> Result:
        """Enable .netrc parsing.

        By default the .netrc file is ignored and corresponds to `CURL_NETRC_IGNORED`.
        """
        return self.set_option(Option.NETRC, netrc)

    # =========================================================================
    # HTTP Options

    fn autoreferer(self, enable: Bool) -> Result:
        """Indicates whether the referer header is automatically updated.

        By default this option is `false` and corresponds to
        `CURLOPT_AUTOREFERER`.
        """
        return self.set_option(Option.AUTO_REFERER, Int(enable))

    fn accept_encoding(self, mut encoding: String) -> Result:
        """Enables automatic decompression of HTTP downloads.

        Sets the contents of the Accept-Encoding header sent in an HTTP request.
        This enables decoding of a response with Content-Encoding.

        Currently supported encoding are `identity`, `zlib`, and `gzip`. A
        zero-length string passed in will send all accepted encodings.

        By default this option is not set and corresponds to
        `CURLOPT_ACCEPT_ENCODING`.
        """
        return self.set_option(Option.ACCEPT_ENCODING, encoding)

    fn transfer_encoding(self, enable: Bool) -> Result:
        """Request the HTTP Transfer Encoding.

        By default this option is `false` and corresponds to
        `CURLOPT_TRANSFER_ENCODING`.
        """
        return self.set_option(Option.TRANSFER_ENCODING, Int(enable))

    fn follow_location(self, enable: Bool) -> Result:
        """Follow HTTP 3xx redirects.

        Indicates whether any `Location` headers in the response should get
        followed.

        By default this option is `false` and corresponds to
        `CURLOPT_FOLLOWLOCATION`.
        """
        return self.set_option(Option.FOLLOW_LOCATION, Int(enable))

    fn unrestricted_auth(self, enable: Bool) -> Result:
        """Send credentials to hosts other than the first as well.

        Sends username/password credentials even when the host changes as part
        of a redirect.

        By default this option is `false` and corresponds to
        `CURLOPT_UNRESTRICTED_AUTH`.
        """
        return self.set_option(Option.UNRESTRICTED_AUTH, Int(enable))

    fn max_redirections(self, max: Int) -> Result:
        """Set the maximum number of redirects allowed.

        A value of 0 will refuse any redirect.

        By default this option is `-1` (unlimited) and corresponds to
        `CURLOPT_MAXREDIRS`.
        """
        return self.set_option(Option.MAXREDIRS, max)

    fn post_redirections(self, redirects: Int) -> Result:
        """Set the policy for handling redirects to POST requests.

        By default a POST is changed to a GET when following a redirect. Setting any
        of the `PostRedirections` flags will preserve the POST method for the
        selected response codes.
        """
        return self.set_option(Option.POST_REDIR, redirects)

    # fn put(self, enable: Bool) -> Result:
    #     """Make an HTTP PUT request.

    #     By default this option is `false` and corresponds to `CURLOPT_PUT`.
    #     """
    #     return self.set_option(Option.PUT, Int(enable))

    fn post(self, enable: Bool) -> Result:
        """Make an HTTP POST request.

        To send a zero-length (empty) POST, set `CURLOPT_POSTFIELDS` to an empty string,
        or set `CURLOPT_POST` to 1 and `CURLOPT_POSTFIELDSIZE` to 0.

        This will also make the library use the
        `Content-Type: application/x-www-form-urlencoded` header.

        POST data can be specified through `post_fields` or by specifying a read
        function.

        By default this option is `false` and corresponds to `CURLOPT_POST`.
        """
        return self.set_option(Option.POST, Int(enable))
    
    fn post_fields(self, data: Span[UInt8]) -> Result:
        """Configures the data that will be uploaded as part of a POST.

        If `CURLOPT_POSTFIELDS` is explicitly set to NULL then libcurl gets
        the POST data from the read callback.
    
        The data pointed to is NOT copied by the library: as a consequence,
        it must be preserved by the calling application until the associated transfer finishes.
        This behavior can be changed (so libcurl does copy the data)
        by instead using the `CURLOPT_COPYPOSTFIELDS` option (`post_fields_copy()`).
    
        By default this option is not set and corresponds to
        `CURLOPT_POSTFIELDS`.
        """
        return self.set_option(Option.POST_FIELDS, data)

    fn post_fields_copy(self, data: Span[UInt8]) -> Result:
        """Configures the data that will be uploaded as part of a POST.
    
        Note that the data is copied into this handle and if that's not desired
        then the read callbacks can be used instead.
    
        By default this option is not set and corresponds to
        `CURLOPT_COPYPOSTFIELDS`.
        """
        return self.set_option(Option.COPY_POST_FIELDS, data)

    fn post_field_size(self, size: Int) -> Result:
        """Configures the size of data that's going to be uploaded as part of a
        POST operation.

        This is called automatically as part of `post_fields` and should only
        be called if data is being provided in a read callback (and even then
        it's optional).

        By default this option is not set and corresponds to
        `CURLOPT_POSTFIELDSIZE_LARGE`.
        """
        return self.set_option(Option.POST_FIELD_SIZE_LARGE, size)

    # TODO: httppost - needs Form type implementation
    # fn httppost(self, form: Form) -> Result:
    #     """Tells libcurl you want a multipart/formdata HTTP POST to be made and you
    #     instruct what data to pass on to the server in the `form` argument.
    #
    #     By default this option is set to null and corresponds to
    #     `CURLOPT_HTTPPOST`.
    #     """
    #     # TODO: Implement this when Form type is available
    #     pass

    fn referer(self, mut referer: String) -> Result:
        """Sets the HTTP referer header.

        By default this option is not set and corresponds to `CURLOPT_REFERER`.
        """
        return self.set_option(Option.REFERER, referer)

    fn useragent(self, mut useragent: String) -> Result:
        """Sets the HTTP user-agent header.

        By default this option is not set and corresponds to
        `CURLOPT_USERAGENT`.
        """
        return self.set_option(Option.USERAGENT, useragent)

    # TODO: http_headers - needs List type implementation
    # fn http_headers(self, list: List) -> Result:
    #     """Add some headers to this HTTP request.
    #
    #     If you add a header that is otherwise used internally, the value here
    #     takes precedence. If a header is added with no content (like `Accept:`)
    #     the internally the header will get disabled. To add a header with no
    #     content, use the form `MyHeader;` (note the trailing semicolon).
    #
    #     Headers must not be CRLF terminated. Many replaced headers have common
    #     shortcuts which should be preferred.
    #
    #     By default this option is not set and corresponds to
    #     `CURLOPT_HTTPHEADER`
    #     """
    #     # TODO: Implement this when List type is available
    #     pass

    # # Add some headers to send to the HTTP proxy.
    # #
    # # This function is essentially the same as `http_headers`.
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_PROXYHEADER`
    # fn proxy_headers(self, list: List) -> Result:
    #     pass

    fn cookie(self, mut cookie: String) -> Result:
        """Set the contents of the HTTP Cookie header.

        Pass a string of the form `name=contents` for one cookie value or
        `name1=val1; name2=val2` for multiple values.

        Using this option multiple times will only make the latest string
        override the previous ones. This option will not enable the cookie
        engine, use `cookie_file` or `cookie_jar` to do that.

        By default this option is not set and corresponds to `CURLOPT_COOKIE`.
        """
        return self.set_option(Option.COOKIE, cookie)

    # TODO: cookie_file - needs path handling
    # fn cookie_file(self, file: String) -> Result:
    #     """Set the file name to read cookies from.
    #
    #     The cookie data can be in either the old Netscape / Mozilla cookie data
    #     format or just regular HTTP headers (Set-Cookie style) dumped to a file.
    #
    #     This also enables the cookie engine, making libcurl parse and send
    #     cookies on subsequent requests with this handle.
    #
    #     Given an empty or non-existing file or by passing the empty string ("")
    #     to this option, you can enable the cookie engine without reading any
    #     initial cookies.
    #
    #     If you use this option multiple times, you just add more files to read.
    #     Subsequent files will add more cookies.
    #
    #     By default this option is not set and corresponds to
    #     `CURLOPT_COOKIEFILE`.
    #     """
    #     return self.set_option(Option.COOKIE_FILE, file)

    # TODO: cookie_jar - needs path handling
    # fn cookie_jar(self, file: String) -> Result:
    #     """Set the file name to store cookies to.
    #
    #     This will make libcurl write all internally known cookies to the file
    #     when this handle is dropped. If no cookies are known, no file will be
    #     created. Specify "-" as filename to instead have the cookies written to
    #     stdout. Using this option also enables cookies for this session, so if
    #     you for example follow a location it will make matching cookies get sent
    #     accordingly.
    #
    #     Note that libcurl does not read any cookies from the cookie jar. If you
    #     want to read cookies from a file, use `cookie_file`.
    #
    #     By default this option is not set and corresponds to
    #     `CURLOPT_COOKIEJAR`.
    #     """
    #     return self.set_option(Option.COOKIEJAR, file)

    fn cookie_session(self, session: Bool) -> Result:
        """Start a new cookie session.

        Marks this as a new cookie "session". It will force libcurl to ignore
        all cookies it is about to load that are "session cookies" from the
        previous session. By default, libcurl always stores and loads all
        cookies, independent if they are session cookies or not. Session cookies
        are cookies without expiry date and they are meant to be alive and
        existing for this "session" only.

        By default this option is `false` and corresponds to
        `CURLOPT_COOKIESESSION`.
        """
        return self.set_option(Option.COOKIE_SESSION, Int(session))

    fn cookie_list(self, mut cookie: String) -> Result:
        """Add to or manipulate cookies held in memory.

        Such a cookie can be either a single line in Netscape / Mozilla format
        or just regular HTTP-style header (Set-Cookie: ...) format. This will
        also enable the cookie engine. This adds that single cookie to the
        internal cookie store.

        Exercise caution if you are using this option and multiple transfers may
        occur. If you use the Set-Cookie format and do not specify a domain then
        the cookie is sent for any domain (even after redirects are followed)
        and cannot be modified by a server-set cookie. If a server sets a cookie
        of the same name (or maybe you have imported one) then both will be sent
        on a future transfer to that server, likely not what you intended.
        address these issues set a domain in Set-Cookie or use the Netscape
        format.

        Additionally, there are commands available that perform actions if you
        pass in these exact strings:

        * "ALL" - erases all cookies held in memory
        * "SESS" - erases all session cookies held in memory
        * "FLUSH" - write all known cookies to the specified cookie jar
        * "RELOAD" - reread all cookies from the cookie file

        By default this options corresponds to `CURLOPT_COOKIELIST`
        """
        return self.set_option(Option.COOKIE_LIST, cookie)

    fn get(self, enable: Bool) -> Result:
        """Ask for a HTTP GET request.

        By default this option is `false` and corresponds to `CURLOPT_HTTPGET`.
        """
        return self.set_option(Option.HTTPGET, Int(enable))

    # # Ask for a HTTP GET request.
    # #
    # # By default this option is `false` and corresponds to `CURLOPT_HTTPGET`.
    # fn http_version(self, vers: String) -> Result:
    #     pass

    fn ignore_content_length(self, ignore: Bool) -> Result:
        """Ignore the content-length header.

        By default this option is `false` and corresponds to
        `CURLOPT_IGNORE_CONTENT_LENGTH`.
        """
        return self.set_option(Option.IGNORE_CONTENT_LENGTH, Int(ignore))

    fn http_content_decoding(self, enable: Bool) -> Result:
        """Enable or disable HTTP content decoding.

        By default this option is `true` and corresponds to
        `CURLOPT_HTTP_CONTENT_DECODING`.
        """
        return self.set_option(Option.HTTP_CONTENT_DECODING, Int(enable))

    fn http_transfer_decoding(self, enable: Bool) -> Result:
        """Enable or disable HTTP transfer decoding.

        By default this option is `true` and corresponds to
        `CURLOPT_HTTP_TRANSFER_DECODING`.
        """
        return self.set_option(Option.HTTP_TRANSFER_DECODING, Int(enable))

    # # Timeout for the Expect: 100-continue response
    # #
    # # By default this option is 1s and corresponds to
    # # `CURLOPT_EXPECT_100_TIMEOUT_MS`.
    # fn expect_100_timeout(self, enable: Bool) -> Result:
    #     pass

    # # Wait for pipelining/multiplexing.
    # #
    # # Tells libcurl to prefer to wait for a connection to confirm or deny that
    # # it can do pipelining or multiplexing before continuing.
    # #
    # # When about to perform a new transfer that allows pipelining or
    # # multiplexing, libcurl will check for existing connections to re-use and
    # # pipeline on. If no such connection exists it will immediately continue
    # # and create a fresh new connection to use.
    # #
    # # By setting this option to `true` - having `pipeline` enabled for the
    # # multi handle this transfer is associated with - libcurl will instead
    # # wait for the connection to reveal if it is possible to
    # # pipeline/multiplex on before it continues. This enables libcurl to much
    # # better keep the number of connections to a minimum when using pipelining
    # # or multiplexing protocols.
    # #
    # # The effect thus becomes that with this option set, libcurl prefers to
    # # wait and re-use an existing connection for pipelining rather than the
    # # opposite: prefer to open a new connection rather than waiting.
    # #
    # # The waiting time is as long as it takes for the connection to get up and
    # # for libcurl to get the necessary response back that informs it about its
    # # protocol and support level.
    # fn http_pipewait(self, enable: Bool) -> Result:
    #     pass

    # =========================================================================
    # Protocol Options

    fn range(self, mut range: String) -> Result:
        """Indicates the range that this request should retrieve.

        The string provided should be of the form `N-M` where either `N` or `M`
        can be left out. For HTTP transfers multiple ranges separated by commas
        are also accepted.

        By default this option is not set and corresponds to `CURLOPT_RANGE`.
        """
        return self.set_option(Option.RANGE, range)

    fn resume_from(self, from_byte: Int) -> Result:
        """Set a point to resume transfer from.

        Specify the offset in bytes you want the transfer to start from.

        By default this option is 0 and corresponds to
        `CURLOPT_RESUME_FROM_LARGE`.
        """
        return self.set_option(Option.RESUME_FROM_LARGE, from_byte)

    fn custom_request(self, mut request: String) -> Result:
        """Set a custom request string.

        Specifies that a custom request will be made (e.g. a custom HTTP
        method). This does not change how libcurl performs internally, just
        changes the string sent to the server.

        By default this option is not set and corresponds to
        `CURLOPT_CUSTOMREQUEST`.
        """
        return self.set_option(Option.CUSTOM_REQUEST, request)

    fn fetch_filetime(self, fetch: Bool) -> Result:
        """Get the modification time of the remote resource.

        If true, libcurl will attempt to get the modification time of the
        remote document in this operation. This requires that the remote server
        sends the time or replies to a time querying command. The `filetime`
        function can be used after a transfer to extract the received time (if
        any).

        By default this option is `false` and corresponds to `CURLOPT_FILETIME`
        """
        return self.set_option(Option.FILE_TIME, Int(fetch))

    fn nobody(self, enable: Bool) -> Result:
        """Indicate whether to download the request without getting the body.

        This is useful, for example, for doing a HEAD request.

        By default this option is `false` and corresponds to `CURLOPT_NOBODY`.
        """
        return self.set_option(Option.NO_BODY, Int(enable))

    fn in_filesize(self, size: Int) -> Result:
        """Set the size of the input file to send off.

        By default this option is not set and corresponds to
        `CURLOPT_INFILESIZE_LARGE`.
        """
        return self.set_option(Option.IN_FILE_SIZE_LARGE, size)

    fn upload(self, enable: Bool) -> Result:
        """Enable or disable data upload.

        This means that a PUT request will be made for HTTP and probably wants
        to be combined with the read callback as well as the `in_filesize`
        method.

        By default this option is `false` and corresponds to `CURLOPT_UPLOAD`.
        """
        return self.set_option(Option.UPLOAD, Int(enable))

    fn max_filesize(self, size: Int) -> Result:
        """Configure the maximum file size to download.

        By default this option is not set and corresponds to
        `CURLOPT_MAXFILESIZE_LARGE`.
        """
        return self.set_option(Option.MAX_FILE_SIZE_LARGE, size)

    fn time_condition(self, cond: Int) -> Result:
        """Selects a condition for a time request.

        This value indicates how the `time_value` option is interpreted.

        By default this option is not set and corresponds to
        `CURLOPT_TIMECONDITION`.
        """
        return self.set_option(Option.TIME_CONDITION, cond)

    fn time_value(self, val: Int) -> Result:
        """Sets the time value for a conditional request.

        The value here should be the number of seconds elapsed since January 1,
        1970. To pass how to interpret this value, use `time_condition`.

        By default this option is not set and corresponds to
        `CURLOPT_TIMEVALUE`.
        """
        return self.set_option(Option.TIME_VALUE, val)

    # =========================================================================
    # Connection Options

    fn timeout(self, timeout_ms: Int) -> Result:
        """Set maximum time the request is allowed to take.

        Normally, name lookups can take a considerable time and limiting
        operations to less than a few minutes risk aborting perfectly normal
        operations.

        If libcurl is built to use the standard system name resolver, that
        portion of the transfer will still use full-second resolution for
        timeouts with a minimum timeout allowed of one second.

        In unix-like systems, this might cause signals to be used unless
        `nosignal` is set.

        Since this puts a hard limit for how long a request is allowed to
        take, it has limited use in dynamic use cases with varying transfer
        times. You are then advised to explore `low_speed_limit`,
        `low_speed_time` or using `progress_function` to implement your own
        timeout logic.

        By default this option is not set and corresponds to
        `CURLOPT_TIMEOUT_MS`.
        """
        return self.set_option(Option.TIMEOUT_MS, timeout_ms)

    fn low_speed_limit(self, limit: Int) -> Result:
        """Set the low speed limit in bytes per second.

        This specifies the average transfer speed in bytes per second that the
        transfer should be below during `low_speed_time` for libcurl to consider
        it to be too slow and abort.

        By default this option is not set and corresponds to
        `CURLOPT_LOW_SPEED_LIMIT`.
        """
        return self.set_option(Option.LOW_SPEED_LIMIT, limit)

    fn low_speed_time(self, seconds: Int) -> Result:
        """Set the low speed time period.

        Specifies the window of time for which if the transfer rate is below
        `low_speed_limit` the request will be aborted.

        By default this option is not set and corresponds to
        `CURLOPT_LOW_SPEED_TIME`.
        """
        return self.set_option(Option.LOW_SPEED_TIME, seconds)

    fn max_send_speed(self, speed: Int) -> Result:
        """Rate limit data upload speed.

        If an upload exceeds this speed (counted in bytes per second) on
        cumulative average during the transfer, the transfer will pause to keep
        the average rate less than or equal to the parameter value.

        By default this option is not set (unlimited speed) and corresponds to
        `CURLOPT_MAX_SEND_SPEED_LARGE`.
        """
        return self.set_option(Option.MAX_SEND_SPEED_LARGE, speed)

    fn max_recv_speed(self, speed: Int) -> Result:
        """Rate limit data download speed.

        If a download exceeds this speed (counted in bytes per second) on
        cumulative average during the transfer, the transfer will pause to keep
        the average rate less than or equal to the parameter value.

        By default this option is not set (unlimited speed) and corresponds to
        `CURLOPT_MAX_RECV_SPEED_LARGE`.
        """
        return self.set_option(Option.MAX_RECV_SPEED_LARGE, speed)

    fn max_connects(self, max: Int) -> Result:
        """Set the maximum connection cache size.

        The set amount will be the maximum number of simultaneously open
        persistent connections that libcurl may cache in the pool associated
        with this handle. The default is 5, and there is not much point in
        changing this value unless you are perfectly aware of how this works and
        changes libcurl's behaviour. This concerns connections using any of the
        protocols that support persistent connections.

        When reaching the maximum limit, curl closes the oldest one in the cache
        to prevent increasing the number of open connections.

        By default this option is set to 5 and corresponds to
        `CURLOPT_MAXCONNECTS`
        """
        return self.set_option(Option.MAX_CONNECTS, max)

    fn maxage_conn(self, max_age_seconds: Int) -> Result:
        """Set the maximum idle time allowed for a connection.

        This configuration sets the maximum time that a connection inside of the connection cache
        can be reused. Any connection older than this value will be considered stale and will
        be closed.

        By default, a value of 118 seconds is used.
        """
        return self.set_option(Option.MAX_AGE_CONN, max_age_seconds)

    fn fresh_connect(self, enable: Bool) -> Result:
        """Force a new connection to be used.

        Makes the next transfer use a new (fresh) connection by force instead of
        trying to re-use an existing one. This option should be used with
        caution and only if you understand what it does as it may seriously
        impact performance.

        By default this option is `false` and corresponds to
        `CURLOPT_FRESH_CONNECT`.
        """
        return self.set_option(Option.FRESH_CONNECT, Int(enable))

    fn forbid_reuse(self, enable: Bool) -> Result:
        """Make connection get closed at once after use.

        Makes libcurl explicitly close the connection when done with the
        transfer. Normally, libcurl keeps all connections alive when done with
        one transfer in case a succeeding one follows that can re-use them.
        This option should be used with caution and only if you understand what
        it does as it can seriously impact performance.

        By default this option is `false` and corresponds to
        `CURLOPT_FORBID_REUSE`.
        """
        return self.set_option(Option.FORBID_REUSE, Int(enable))

    fn connect_timeout(self, timeout_ms: Int) -> Result:
        """Timeout for the connect phase.

        This is the maximum time that you allow the connection phase to the
        server to take. This only limits the connection phase, it has no impact
        once it has connected.

        By default this value is 300 seconds and corresponds to
        `CURLOPT_CONNECTTIMEOUT_MS`.
        """
        return self.set_option(Option.CONNECT_TIMEOUT_MS, timeout_ms)

    fn ip_resolve(self, resolve: Int) -> Result:
        """Specify which IP protocol version to use.

        Allows an application to select what kind of IP addresses to use when
        resolving host names. This is only interesting when using host names
        that resolve addresses using more than one version of IP.

        By default this value is "any" and corresponds to `CURLOPT_IPRESOLVE`.
        """
        return self.set_option(Option.IP_RESOLVE, resolve)

    # TODO: resolve - needs List type implementation
    # fn resolve(self, list: List) -> Result:
    #     """Specify custom host name to IP address resolves.
    #
    #     Allows specifying hostname to IP mappings to use before trying the
    #     system resolver.
    #     """
    #     # TODO: Implement this when List type is available
    #     pass

    fn connect_only(self, enable: Bool) -> Result:
        """Configure whether to stop when connected to target server.

        When enabled it tells the library to perform all the required proxy
        authentication and connection setup, but no data transfer, and then
        return.

        The option can be used to simply test a connection to a server.

        By default this value is `false` and corresponds to
        `CURLOPT_CONNECT_ONLY`.
        """
        return self.set_option(Option.CONNECT_ONLY, Int(enable))

    # # Set interface to speak DNS over.
    # #
    # # Set the name of the network interface that the DNS resolver should bind
    # # to. This must be an interface name (not an address).
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_DNS_INTERFACE`.
    # fn dns_interface(self, mut interface: String) -> Result:
    #     pass
    #
    # # IPv4 address to bind DNS resolves to
    # #
    # # Set the local IPv4 address that the resolver should bind to. The
    # # argument should be of type char * and contain a single numerical IPv4
    # # address as a string.
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_DNS_LOCAL_IP4`.
    # fn dns_local_ip4(self, mut ip: String) -> Result:
    #     pass
    #
    # # IPv6 address to bind DNS resolves to
    # #
    # # Set the local IPv6 address that the resolver should bind to. The
    # # argument should be of type char * and contain a single numerical IPv6
    # # address as a string.
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_DNS_LOCAL_IP6`.
    # fn dns_local_ip6(self, mut ip: String) -> Result:
    #     pass
    #
    # # Set preferred DNS servers.
    # #
    # # Provides a list of DNS servers to be used instead of the system default.
    # # The format of the dns servers option is:
    # #
    # # host[:port],[host[:port]]...
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_DNS_SERVERS`.
    # fn dns_servers(self, mut servers: String) -> Result:
    #     pass

    # =========================================================================
    # SSL/Security Options

    # TODO: ssl_cert - needs path handling
    # fn ssl_cert(self, cert: String) -> Result:
    #     """Sets the SSL client certificate.
    #
    #     The string should be the file name of your client certificate. The
    #     default format is "P12" on Secure Transport and "PEM" on other engines,
    #     and can be changed with `ssl_cert_type`.
    #
    #     With NSS or Secure Transport, this can also be the nickname of the
    #     certificate you wish to authenticate with as it is named in the security
    #     database. If you want to use a file from the current directory, please
    #     precede it with "./" prefix, in order to avoid confusion with a
    #     nickname.
    #
    #     When using a client certificate, you most likely also need to provide a
    #     private key with `ssl_key`.
    #
    #     By default this option is not set and corresponds to `CURLOPT_SSLCERT`.
    #     """
    #     # TODO: Implement path handling
    #     pass

    # TODO: ssl_cert_blob - needs byte array handling
    # fn ssl_cert_blob(self, blob: List[UInt8]) -> Result:
    #     """Set the SSL client certificate using an in-memory blob.
    #
    #     The specified byte buffer should contain the binary content of your
    #     client certificate, which will be copied into the handle. The format of
    #     the certificate can be specified with `ssl_cert_type`.
    #
    #     By default this option is not set and corresponds to
    #     `CURLOPT_SSLCERT_BLOB`.
    #     """
    #     # TODO: Implement blob handling
    #     pass

    fn ssl_cert_type(self, mut kind: String) -> Result:
        """Specify type of the client SSL certificate.

        The string should be the format of your certificate. Supported formats
        are "PEM" and "DER", except with Secure Transport. OpenSSL (versions
        0.9.3 and later) and Secure Transport (on iOS 5 or later, or OS X 10.7
        or later) also support "P12" for PKCS#12-encoded files.

        By default this option is "PEM" and corresponds to
        `CURLOPT_SSLCERTTYPE`.
        """
        return self.set_option(Option.SSL_CERT_TYPE, kind)

    # TODO: ssl_key - needs path handling
    # fn ssl_key(self, key: String) -> Result:
    #     """Specify private keyfile for TLS and SSL client cert.
    #
    #     The string should be the file name of your private key. The default
    #     format is "PEM" and can be changed with `ssl_key_type`.
    #
    #     (iOS and Mac OS X only) This option is ignored if curl was built against
    #     Secure Transport. Secure Transport expects the private key to be already
    #     present in the keychain or PKCS#12 file containing the certificate.
    #
    #     By default this option is not set and corresponds to `CURLOPT_SSLKEY`.
    #     """
    #     # TODO: Implement path handling
    #     pass

    # TODO: ssl_key_blob - needs byte array handling
    # fn ssl_key_blob(self, blob: List[UInt8]) -> Result:
    #     """Specify an SSL private key using an in-memory blob.
    #
    #     The specified byte buffer should contain the binary content of your
    #     private key, which will be copied into the handle. The format of
    #     the private key can be specified with `ssl_key_type`.
    #
    #     By default this option is not set and corresponds to
    #     `CURLOPT_SSLKEY_BLOB`.
    #     """
    #     # TODO: Implement blob handling
    #     pass

    fn ssl_key_type(self, mut kind: String) -> Result:
        """Set type of the private key file.

        The string should be the format of your private key. Supported formats
        are "PEM", "DER" and "ENG".

        The format "ENG" enables you to load the private key from a crypto
        engine. In this case `ssl_key` is used as an identifier passed to
        the engine. You have to set the crypto engine with `ssl_engine`.
        "DER" format key file currently does not work because of a bug in
        OpenSSL.

        By default this option is "PEM" and corresponds to
        `CURLOPT_SSLKEYTYPE`.
        """
        return self.set_option(Option.SSL_KEY_TYPE, kind)

    fn key_password(self, mut password: String) -> Result:
        """Set passphrase to private key.

        This will be used as the password required to use the `ssl_key`.
        You never needed a pass phrase to load a certificate but you need one to
        load your private key.

        By default this option is not set and corresponds to
        `CURLOPT_KEYPASSWD`.
        """
        return self.set_option(Option.KEY_PASSWD, password)

    # TODO: ssl_cainfo_blob - needs byte array handling
    # fn ssl_cainfo_blob(self, blob: List[UInt8]) -> Result:
    #     """Set the SSL Certificate Authorities using an in-memory blob.
    #
    #     The specified byte buffer should contain the binary content of one
    #     or more PEM-encoded CA certificates, which will be copied into
    #     the handle.
    #
    #     By default this option is not set and corresponds to
    #     `CURLOPT_CAINFO_BLOB`.
    #     """
    #     # TODO: Implement blob handling
    #     pass

    # TODO: proxy_ssl_cainfo_blob - needs byte array handling
    # fn proxy_ssl_cainfo_blob(self, blob: List[UInt8]) -> Result:
    #     """Set the SSL Certificate Authorities for HTTPS proxies using an in-memory
    #     blob.
    #
    #     The specified byte buffer should contain the binary content of one
    #     or more PEM-encoded CA certificates, which will be copied into
    #     the handle.
    #
    #     By default this option is not set and corresponds to
    #     `CURLOPT_PROXY_CAINFO_BLOB`.
    #     """
    #     # TODO: Implement blob handling
    #     pass

    fn ssl_engine(self, mut engine: String) -> Result:
        """Set the SSL engine identifier.

        This will be used as the identifier for the crypto engine you want to
        use for your private key.

        By default this option is not set and corresponds to
        `CURLOPT_SSLENGINE`.
        """
        return self.set_option(Option.SSL_ENGINE, engine)

    fn ssl_engine_default(self, enable: Bool) -> Result:
        """Make this handle's SSL engine the default.

        By default this option is not set and corresponds to
        `CURLOPT_SSLENGINE_DEFAULT`.
        """
        return self.set_option(Option.SSL_ENGINE_DEFAULT, Int(enable))

    # # Enable TLS false start.
    # #
    # # This option determines whether libcurl should use false start during the
    # # TLS handshake. False start is a mode where a TLS client will start
    # # sending application data before verifying the server's Finished message,
    # # thus saving a round trip when performing a full handshake.
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_SSL_FALSESTARTE`.
    # fn ssl_false_start(self, enable: Bool) -> Result:
    #     pass

    fn http_version(self, version: Int) -> Result:
        """Set preferred HTTP version.

        By default this option is not set and corresponds to
        `CURLOPT_HTTP_VERSION`.
        """
        return self.set_option(Option.HTTP_VERSION, version)

    fn ssl_version(self, version: Int) -> Result:
        """Set preferred TLS/SSL version.

        By default this option is not set and corresponds to
        `CURLOPT_SSLVERSION`.
        """
        return self.set_option(Option.SSL_VERSION, version)

    fn proxy_ssl_version(self, version: Int) -> Result:
        """Set preferred TLS/SSL version when connecting to an HTTPS proxy.

        By default this option is not set and corresponds to
        `CURLOPT_PROXY_SSLVERSION`.
        """
        return self.set_option(Option.PROXY_SSL_VERSION, version)

    fn ssl_min_max_version(self, min_version: Int, max_version: Int) -> Result:
        """Set preferred TLS/SSL version with minimum version and maximum version.

        By default this option is not set and corresponds to
        `CURLOPT_SSLVERSION`.
        """
        var version = min_version | (max_version << 16)
        return self.set_option(Option.SSL_VERSION, version)

    fn proxy_ssl_min_max_version(self, min_version: Int, max_version: Int) -> Result:
        """Set preferred TLS/SSL version with minimum version and maximum version
        when connecting to an HTTPS proxy.

        By default this option is not set and corresponds to
        `CURLOPT_PROXY_SSLVERSION`.
        """
        var version = min_version | (max_version << 16)
        return self.set_option(Option.PROXY_SSL_VERSION, version)

    fn ssl_verify_host(self, verify: Bool) -> Result:
        """Verify the certificate's name against host.

        This should be disabled with great caution! It basically disables the
        security features of SSL if it is disabled.

        By default this option is set to `true` and corresponds to
        `CURLOPT_SSL_VERIFYHOST`.
        """
        var val = 2 if verify else 0
        return self.set_option(Option.SSL_VERIFY_HOST, val)

    fn proxy_ssl_verify_host(self, verify: Bool) -> Result:
        """Verify the certificate's name against host for HTTPS proxy.

        This should be disabled with great caution! It basically disables the
        security features of SSL if it is disabled.

        By default this option is set to `true` and corresponds to
        `CURLOPT_PROXY_SSL_VERIFYHOST`.
        """
        var val = 2 if verify else 0
        return self.set_option(Option.PROXY_SSL_VERIFYHOST, val)

    fn ssl_verify_peer(self, verify: Bool) -> Result:
        """Verify the peer's SSL certificate.

        This should be disabled with great caution! It basically disables the
        security features of SSL if it is disabled.

        By default this option is set to `true` and corresponds to
        `CURLOPT_SSL_VERIFYPEER`.
        """
        return self.set_option(Option.SSL_VERIFYPEER, Int(verify))

    fn proxy_ssl_verify_peer(self, verify: Bool) -> Result:
        """Verify the peer's SSL certificate for HTTPS proxy.

        This should be disabled with great caution! It basically disables the
        security features of SSL if it is disabled.

        By default this option is set to `true` and corresponds to
        `CURLOPT_PROXY_SSL_VERIFYPEER`.
        """
        return self.set_option(Option.PROXY_SSL_VERIFYPEER, Int(verify))

    # # Verify the certificate's status.
    # #
    # # This option determines whether libcurl verifies the status of the server
    # # cert using the "Certificate Status Request" TLS extension (aka. OCSP
    # # stapling).
    # #
    # # By default this option is set to `false` and corresponds to
    # # `CURLOPT_SSL_VERIFYSTATUS`.
    # fn ssl_verify_status(self, verify: Bool) -> Result:
    #     pass

    # TODO: Specify the path to Certificate Authority (CA) bundle
    # Requires Path type support
    # fn cainfo(self, path: Path) -> Result:
    #     """The file referenced should hold one or more certificates to verify the
    #     peer with.
    #
    #     This option is by default set to the system path where libcurl's cacert
    #     bundle is assumed to be stored, as established at build time.
    #
    #     If curl is built against the NSS SSL library, the NSS PEM PKCS#11 module
    #     (libnsspem.so) needs to be available for this option to work properly.
    #
    #     By default this option is the system defaults, and corresponds to
    #     CURLOPT_CAINFO.
    #     """
    #     return self.set_option(Option.CAINFO, path)

    # TODO: Set the issuer SSL certificate filename
    # Requires Path type support
    # fn issuer_cert(self, path: Path) -> Result:
    #     """Specifies a file holding a CA certificate in PEM format. If the option
    #     is set, an additional check against the peer certificate is performed to
    #     verify the issuer is indeed the one associated with the certificate
    #     provided by the option. This additional check is useful in multi-level
    #     PKI where one needs to enforce that the peer certificate is from a
    #     specific branch of the tree.
    #
    #     This option makes sense only when used in combination with the
    #     ssl_verify_peer option. Otherwise, the result of the check is
    #     not considered as failure.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_ISSUERCERT.
    #     """
    #     return self.set_option(Option.ISSUERCERT, path)

    # TODO: Set the issuer SSL certificate filename for HTTPS proxies
    # Requires Path type support
    # fn proxy_issuer_cert(self, path: Path) -> Result:
    #     """Specifies a file holding a CA certificate in PEM format. If the option
    #     is set, an additional check against the peer certificate is performed to
    #     verify the issuer is indeed the one associated with the certificate
    #     provided by the option. This additional check is useful in multi-level
    #     PKI where one needs to enforce that the peer certificate is from a
    #     specific branch of the tree.
    #
    #     This option makes sense only when used in combination with the
    #     proxy_ssl_verify_peer option. Otherwise, the result of the check is
    #     not considered as failure.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_PROXY_ISSUERCERT.
    #     """
    #     return self.set_option(Option.PROXY_ISSUERCERT, path)

    # TODO: Set the issuer SSL certificate using an in-memory blob
    # Requires blob/byte array type support
    # fn issuer_cert_blob(self, blob: Bytes) -> Result:
    #     """The specified byte buffer should contain the binary content of a CA
    #     certificate in the PEM format. The certificate will be copied into the
    #     handle.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_ISSUERCERT_BLOB.
    #     """
    #     return self.set_option(Option.ISSUERCERT_BLOB, blob)

    # TODO: Set the issuer SSL certificate for HTTPS proxies using an in-memory blob
    # Requires blob/byte array type support
    # fn proxy_issuer_cert_blob(self, blob: Bytes) -> Result:
    #     """The specified byte buffer should contain the binary content of a CA
    #     certificate in the PEM format. The certificate will be copied into the
    #     handle.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_PROXY_ISSUERCERT_BLOB.
    #     """
    #     return self.set_option(Option.PROXY_ISSUERCERT_BLOB, blob)

    # TODO: Specify directory holding CA certificates
    # Requires Path type support
    # fn capath(self, path: Path) -> Result:
    #     """Names a directory holding multiple CA certificates to verify the peer
    #     with. If libcurl is built against OpenSSL, the certificate directory
    #     must be prepared using the openssl c_rehash utility. This makes sense
    #     only when used in combination with the ssl_verify_peer option.
    #
    #     By default this option is not set and corresponds to CURLOPT_CAPATH.
    #     """
    #     return self.set_option(Option.CAPATH, path)

    # TODO: Specify a Certificate Revocation List file
    # Requires Path type support
    # fn crlfile(self, path: Path) -> Result:
    #     """Names a file with the concatenation of CRL (in PEM format) to use in the
    #     certificate validation that occurs during the SSL exchange.
    #
    #     When curl is built to use NSS or GnuTLS, there is no way to influence
    #     the use of CRL passed to help in the verification process. When libcurl
    #     is built with OpenSSL support, X509_V_FLAG_CRL_CHECK and
    #     X509_V_FLAG_CRL_CHECK_ALL are both set, requiring CRL check against all
    #     the elements of the certificate chain if a CRL file is passed.
    #
    #     This option makes sense only when used in combination with the
    #     ssl_verify_peer option.
    #
    #     A specific error code (is_ssl_crl_badfile) is defined with the
    #     option. It is returned when the SSL exchange fails because the CRL file
    #     cannot be loaded. A failure in certificate verification due to a
    #     revocation information found in the CRL does not trigger this specific
    #     error.
    #
    #     By default this option is not set and corresponds to CURLOPT_CRLFILE.
    #     """
    #     return self.set_option(Option.CRLFILE, path)

    # TODO: Specify a Certificate Revocation List file for HTTPS proxy
    # Requires Path type support
    # fn proxy_crlfile(self, path: Path) -> Result:
    #     """Names a file with the concatenation of CRL (in PEM format) to use in the
    #     certificate validation that occurs during the SSL exchange.
    #
    #     When curl is built to use NSS or GnuTLS, there is no way to influence
    #     the use of CRL passed to help in the verification process. When libcurl
    #     is built with OpenSSL support, X509_V_FLAG_CRL_CHECK and
    #     X509_V_FLAG_CRL_CHECK_ALL are both set, requiring CRL check against all
    #     the elements of the certificate chain if a CRL file is passed.
    #
    #     This option makes sense only when used in combination with the
    #     proxy_ssl_verify_peer option.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_PROXY_CRLFILE.
    #     """
    #     return self.set_option(Option.PROXY_CRLFILE, path)

    fn certinfo(self, enable: Bool) -> Result:
        """Request SSL certificate information.

        Enable libcurl's certificate chain info gatherer. With this enabled,
        libcurl will extract lots of information and data about the certificates
        in the certificate chain used in the SSL connection.

        By default this option is False and corresponds to
        CURLOPT_CERTINFO.
        """
        return self.set_option(Option.CERT_INFO, Int(enable))

    fn pinned_public_key(self, mut pubkey: String) -> Result:
        """Set pinned public key.

        Pass a pointer to a zero terminated string as parameter. The string can
        be the file name of your pinned public key. The file format expected is
        "PEM" or "DER". The string can also be any number of base64 encoded
        sha256 hashes preceded by "sha256//" and separated by ";"

        When negotiating a TLS or SSL connection, the server sends a certificate
        indicating its identity. A public key is extracted from this certificate
        and if it does not exactly match the public key provided to this option,
        curl will abort the connection before sending or receiving any data.

        By default this option is not set and corresponds to
        CURLOPT_PINNEDPUBLICKEY.
        """
        return self.set_option(Option.PINNED_PUBLIC_KEY, pubkey)

    # TODO: Specify a source for random data
    # Requires Path type support
    # fn random_file(self, path: Path) -> Result:
    #     """The file will be used to read from to seed the random engine for SSL and
    #     more.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_RANDOM_FILE.
    #     """
    #     return self.set_option(Option.RANDOM_FILE, path)

    # TODO: Specify EGD socket path
    # Requires Path type support
    # fn egd_socket(self, path: Path) -> Result:
    #     """Indicates the path name to the Entropy Gathering Daemon socket. It will
    #     be used to seed the random engine for SSL.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_EGDSOCKET.
    #     """
    #     return self.set_option(Option.EGDSOCKET, path)

    fn ssl_cipher_list(self, mut ciphers: String) -> Result:
        """Specify ciphers to use for TLS.

        Holds the list of ciphers to use for the SSL connection. The list must
        be syntactically correct, it consists of one or more cipher strings
        separated by colons. Commas or spaces are also acceptable separators
        but colons are normally used, !, - and + can be used as operators.

        For OpenSSL and GnuTLS valid examples of cipher lists include 'RC4-SHA',
        'SHA1+DES', 'TLSv1' and 'DEFAULT'. The default list is normally set when
        you compile OpenSSL.

        You'll find more details about cipher lists on this URL:
        https://www.openssl.org/docs/apps/ciphers.html

        For NSS, valid examples of cipher lists include 'rsa_rc4_128_md5',
        'rsa_aes_128_sha', etc. With NSS you don't add/remove ciphers. If one
        uses this option then all known ciphers are disabled and only those
        passed in are enabled.

        By default this option is not set and corresponds to
        CURLOPT_SSL_CIPHER_LIST.
        """
        return self.set_option(Option.SSL_CIPHER_LIST, ciphers)

    fn proxy_ssl_cipher_list(self, mut ciphers: String) -> Result:
        """Specify ciphers to use for TLS for an HTTPS proxy.

        Holds the list of ciphers to use for the SSL connection. The list must
        be syntactically correct, it consists of one or more cipher strings
        separated by colons. Commas or spaces are also acceptable separators
        but colons are normally used, !, - and + can be used as operators.

        For OpenSSL and GnuTLS valid examples of cipher lists include 'RC4-SHA',
        'SHA1+DES', 'TLSv1' and 'DEFAULT'. The default list is normally set when
        you compile OpenSSL.

        You'll find more details about cipher lists on this URL:
        https://www.openssl.org/docs/apps/ciphers.html

        For NSS, valid examples of cipher lists include 'rsa_rc4_128_md5',
        'rsa_aes_128_sha', etc. With NSS you don't add/remove ciphers. If one
        uses this option then all known ciphers are disabled and only those
        passed in are enabled.

        By default this option is not set and corresponds to
        CURLOPT_PROXY_SSL_CIPHER_LIST.
        """
        return self.set_option(Option.PROXY_SSL_CIPHER_LIST, ciphers)

    fn ssl_sessionid_cache(self, enable: Bool) -> Result:
        """Enable or disable use of the SSL session-ID cache.

        By default all transfers are done using the cache enabled. While nothing
        ever should get hurt by attempting to reuse SSL session-IDs, there seem
        to be or have been broken SSL implementations in the wild that may
        require you to disable this in order for you to succeed.

        This corresponds to the CURLOPT_SSL_SESSIONID_CACHE option.
        """
        return self.set_option(Option.SSL_SESSIONID_CACHE, Int(enable))

    # TODO: Set SSL behavior options
    # Requires SslOpt type support
    # fn ssl_options(self, bits: SslOpt) -> Result:
    #     """Inform libcurl about SSL specific behaviors.
    #
    #     This corresponds to the CURLOPT_SSL_OPTIONS option.
    #     """
    #     return self.set_option(Option.SSL_OPTIONS, bits.bits)

    # TODO: Set SSL behavior options for proxies
    # Requires SslOpt type support
    # fn proxy_ssl_options(self, bits: SslOpt) -> Result:
    #     """Inform libcurl about SSL specific behaviors.
    #
    #     This corresponds to the CURLOPT_PROXY_SSL_OPTIONS option.
    #     """
    #     return self.set_option(Option.PROXY_SSL_OPTIONS, bits.bits)

    # =========================================================================
    # Getters

    # TODO: Set maximum time to wait for Expect 100 request before sending body
    # Requires Duration type support
    # fn expect_100_timeout(self, timeout_ms: Int) -> Result:
    #     """curl has internal heuristics that trigger the use of a Expect
    #     header for large enough request bodies where the client first sends the
    #     request header along with an Expect: 100-continue header. The server
    #     is supposed to validate the headers and respond with a 100 response
    #     status code after which curl will send the actual request body.
    #
    #     However, if the server does not respond to the initial request
    #     within CURLOPT_EXPECT_100_TIMEOUT_MS then curl will send the
    #     request body anyways.
    #
    #     The best-case scenario is where the request is invalid and the server
    #     replies with a 417 Expectation Failed without having to wait for or process
    #     the request body at all. However, this behaviour can also lead to higher
    #     total latency since in the best case, an additional server roundtrip is required
    #     and in the worst case, the request is delayed by CURLOPT_EXPECT_100_TIMEOUT_MS.
    #
    #     More info: https://mojo_curl.se/libcurl/c/CURLOPT_EXPECT_100_TIMEOUT_MS.html
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_EXPECT_100_TIMEOUT_MS.
    #     """
    #     return self.set_option(Option.EXPECT_100_TIMEOUT_MS, timeout_ms)

    fn effective_url(self) raises -> String:
        """Get the last used effective URL.

        By default this option is not set and corresponds to
        `CURLINFO_EFFECTIVE_URL`.
        """
        return self.get_info(Info.EFFECTIVE_URL)

    fn response_code(self) raises -> c_long:
        """Get the last response code.

        By default this option is not set and corresponds to
        `CURLINFO_RESPONSE_CODE`.
        """
        return self.get_info_long(Info.RESPONSE_CODE)

    fn http_connectcode(self) raises -> c_long:
        """Get the CONNECT response code.

        By default this option is not set and corresponds to
        `CURLINFO_HTTP_CONNECTCODE`.
        """
        return self.get_info_long(Info.HTTP_CONNECT_CODE)

    fn file_time(self) raises -> c_long:
        """Get the remote time of the retrieved document.

        By default this option is not set and corresponds to
        `CURLINFO_FILETIME`.
        """
        return self.get_info_long(Info.FILE_TIME)

    fn redirect_count(self) raises -> c_long:
        """Get the number of redirects.

        By default this option is not set and corresponds to
        `CURLINFO_REDIRECT_COUNT`.
        """
        return self.get_info_long(Info.REDIRECT_COUNT)

    fn redirect_url(self) raises -> String:
        """Get the URL a redirect would go to.

        By default this option is not set and corresponds to
        `CURLINFO_REDIRECT_URL`.
        """
        return self.get_info(Info.REDIRECT_URL)

    fn header_size(self) raises -> c_long:
        """Get the number of bytes of all headers received.

        By default this option is not set and corresponds to
        `CURLINFO_HEADER_SIZE`.
        """
        return self.get_info_long(Info.HEADER_SIZE)

    fn request_size(self) raises -> c_long:
        """Get the number of bytes sent in the request.

        By default this option is not set and corresponds to
        `CURLINFO_REQUEST_SIZE`.
        """
        return self.get_info_long(Info.REQUEST_SIZE)

    fn content_type(self) raises -> String:
        """Get the content-type of the downloaded object.

        By default this option is not set and corresponds to
        `CURLINFO_CONTENT_TYPE`.
        """
        return self.get_info(Info.CONTENT_TYPE)

    fn os_errno(self) raises -> c_long:
        """Get errno number from last connect failure.

        By default this option is not set and corresponds to
        `CURLINFO_OS_ERRNO`.
        """
        return self.get_info_long(Info.OS_ERRNO)

    fn primary_ip(self) raises -> String:
        """Get the IP address of the most recent connection.

        By default this option is not set and corresponds to
        `CURLINFO_PRIMARY_IP`.
        """
        return self.get_info(Info.PRIMARY_IP)

    fn primary_port(self) raises -> c_long:
        """Get the destination port of the most recent connection.

        By default this option is not set and corresponds to
        `CURLINFO_PRIMARY_PORT`.
        """
        return self.get_info_long(Info.PRIMARY_PORT)

    fn local_ip(self) raises -> String:
        """Get the local IP address of the most recent connection.

        By default this option is not set and corresponds to
        `CURLINFO_LOCAL_IP`.
        """
        return self.get_info(Info.LOCAL_IP)

    fn local_port(self) raises -> c_long:
        """Get the local port of the most recent connection.

        By default this option is not set and corresponds to
        `CURLINFO_LOCAL_PORT`.
        """
        return self.get_info_long(Info.LOCAL_PORT)

    fn time_condition_unmet(self) raises -> c_long:
        """Check if a time conditional was met.

        By default this option is not set and corresponds to
        `CURLINFO_CONDITION_UNMET`.
        """
        return self.get_info_long(Info.CONDITION_UNMET)

    fn download_size(self) raises -> Float64:
        """Get the content-length of the download.

        This is the value read from the Content-Length field.

        By default this option is not set and corresponds to
        `CURLINFO_CONTENT_LENGTH_DOWNLOAD_T`.
        """
        return self.get_info_float(Info.CONTENT_LENGTH_DOWNLOAD_T)

    fn upload_size(self) raises -> Float64:
        """Get the specified size of the upload.

        By default this option is not set and corresponds to
        `CURLINFO_CONTENT_LENGTH_UPLOAD_T`.
        """
        return self.get_info_float(Info.CONTENT_LENGTH_UPLOAD_T)

    fn total_time(self) raises -> Float64:
        """Get the total time of the previous transfer in seconds.

        By default this option is not set and corresponds to
        `CURLINFO_TOTAL_TIME_T`.
        """
        return self.get_info_float(Info.TOTAL_TIME)

    fn namelookup_time(self) raises -> Float64:
        """Get the name lookup time in seconds.

        By default this option is not set and corresponds to
        `CURLINFO_NAMELOOKUP_TIME_T`.
        """
        return self.get_info_float(Info.NAME_LOOKUP_TIME)

    fn connect_time(self) raises -> Float64:
        """Get the time until connect in seconds.

        By default this option is not set and corresponds to
        `CURLINFO_CONNECT_TIME_T`.
        """
        return self.get_info_float(Info.CONNECT_TIME)

    fn appconnect_time(self) raises -> Float64:
        """Get the time until the SSL/SSH handshake is completed in seconds.

        By default this option is not set and corresponds to
        `CURLINFO_APPCONNECT_TIME_T`.
        """
        return self.get_info_float(Info.APP_CONNECT_TIME)

    fn pretransfer_time(self) raises -> Float64:
        """Get the time until the file transfer start in seconds.

        By default this option is not set and corresponds to
        `CURLINFO_PRETRANSFER_TIME_T`.
        """
        return self.get_info_float(Info.PRE_TRANSFER_TIME)

    fn starttransfer_time(self) raises -> Float64:
        """Get the time until the first byte is received in seconds.

        By default this option is not set and corresponds to
        `CURLINFO_STARTTRANSFER_TIME_T`.
        """
        return self.get_info_float(Info.START_TRANSFER_TIME)

    fn redirect_time(self) raises -> Float64:
        """Get the time for all redirection steps in seconds.

        By default this option is not set and corresponds to
        `CURLINFO_REDIRECT_TIME_T`.
        """
        return self.get_info_float(Info.REDIRECT_TIME)

    fn speed_download(self) raises -> Float64:
        """Get the average download speed in bytes per second.

        By default this option is not set and corresponds to
        `CURLINFO_SPEED_DOWNLOAD_T`.
        """
        return self.get_info_float(Info.SPEED_DOWNLOAD_T)

    fn speed_upload(self) raises -> Float64:
        """Get the average upload speed in bytes per second.

        By default this option is not set and corresponds to
        `CURLINFO_SPEED_UPLOAD_T`.
        """
        return self.get_info_float(Info.SPEED_UPLOAD_T)

    fn pipewait(self, wait: Bool) -> Result:
        """Wait for pipelining/multiplexing.

        Set wait to True to tell libcurl to prefer to wait for a connection to
        confirm or deny that it can do pipelining or multiplexing before
        continuing.

        When about to perform a new transfer that allows pipelining or
        multiplexing, libcurl will check for existing connections to re-use and
        pipeline on. If no such connection exists it will immediately continue
        and create a fresh new connection to use.

        By setting this option to True - and having pipelining(True, True)
        enabled for the multi handle this transfer is associated with - libcurl
        will instead wait for the connection to reveal if it is possible to
        pipeline/multiplex on before it continues. This enables libcurl to much
        better keep the number of connections to a minimum when using pipelining
        or multiplexing protocols.

        The effect thus becomes that with this option set, libcurl prefers to
        wait and re-use an existing connection for pipelining rather than the
        opposite: prefer to open a new connection rather than waiting.

        The waiting time is as long as it takes for the connection to get up and
        for libcurl to get the necessary response back that informs it about its
        protocol and support level.

        This corresponds to the CURLOPT_PIPEWAIT option.
        """
        return self.set_option(Option.PIPE_WAIT, Int(wait))

    fn http_09_allowed(self, allow: Bool) -> Result:
        """Allow HTTP/0.9 compliant responses.

        Set allow to True to tell libcurl to allow HTTP/0.9 responses. A HTTP/0.9
        response is a server response entirely without headers and only a body.

        By default this option is not set and corresponds to
        CURLOPT_HTTP09_ALLOWED.
        """
        return self.set_option(Option.HTTP09_ALLOWED, Int(allow))
    
    fn get_scheme(self) raises -> String:
        """Get URL scheme used in transfer.

        Corresponds to `CURLINFO_SCHEME`.
        """
        return self.get_info(Info.SCHEME)

    fn headers(self, origin: HeaderOrigin) -> Dict[String, String]:
        """Move to next header set for multi-response requests.

        When performing a request that can return multiple responses - such as
        a HTTP/1.1 request with the "Expect: 100-continue" header or a HTTP/2
        request with server push - this option can be used to advance to the
        next header set in the response stream.

        By default this option is not set and corresponds to
        CURLOPT_NEXTHEADER.
        """
        var headers = Dict[String, String]()
        var prev = ExternalMutPointer[curl_header]()

        while True:
            var h = get_curl_handle()[].easy_nextheader(self.easy, origin.value, 0, prev)
            if not h:
                break
            prev = h
            headers[String(unsafe_from_utf8_ptr=h[].name)] = String(unsafe_from_utf8_ptr=h[].value)

        return headers^

    # =========================================================================
    # Callback options

    fn write_function(self, callback: curl_write_callback) -> Result:
        """Set callback for writing received data.

        This callback function gets called by libcurl as soon as there is data
        received that needs to be saved.

        The callback function will be passed as much data as possible in all
        invokes, but you must not make any assumptions. It may be one byte, it
        may be thousands. If `show_header` is enabled, which makes header data
        get passed to the write callback, you can get up to
        `CURL_MAX_HTTP_HEADER` bytes of header data passed into it. This
        usually means 100K.

        This function may be called with zero bytes data if the transferred file
        is empty.

        The callback should return the number of bytes actually taken care of.
        If that amount differs from the amount passed to your callback function,
        it'll signal an error condition to the library. This will cause the
        transfer to get aborted and the libcurl function used will return
        an error with `is_write_error`.

        By default data is sent into the void, and this corresponds to the
        `CURLOPT_WRITEFUNCTION` option.

        Note: In Mojo, the callback function must match the curl_write_callback
        signature defined in the bindings.
        """
        return self.set_option(Option.WRITE_FUNCTION, callback)
    
    fn write_data[origin: MutOrigin](self, data: MutOpaquePointer[origin]) -> Result:
        """Set custom pointer to pass to write callback.

        By default this option is not set and corresponds to
        `CURLOPT_WRITEDATA`.
        """
        return self.set_option(Option.WRITE_DATA, data)
    
    fn escape(self, mut string: String) raises -> String:
        """URL-encode the given string.

        This function returns a new string that is the URL-encoded version of
        the input string. It is the caller's responsibility to free the returned
        string when it is no longer needed.

        By default this option is not set and corresponds to
        `curl_easy_escape`.
        """
        var data = get_curl_handle()[].easy_escape(self.easy, string, 0)
        if not data:
            raise Error("Failed to escape string.")

        return String(unsafe_from_utf8_ptr=data)
