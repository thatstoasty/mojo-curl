from std.pathlib import Path
from std.ffi import c_long, c_char

from mojo_curl.c import curl_ffi, curl, CURL, Info, Option, Result, WriteCallbackFn, ReadCallbackFn, HeaderOrigin, curl_header
from mojo_curl.c.types import MutExternalPointer, curl_slist


@explicit_destroy("The easy handle must be explicitly destroyed by calling `close()` to free resources.")
struct InnerEasy(Movable):
    """Represents a libcurl easy handle, which is used to perform individual transfers."""
    var easy: CURL
    """Internal external pointer to the libcurl easy handle."""

    def __init__(out self):
        self.easy = curl_ffi()[].easy_init()

    def close(deinit self):
        if self.easy:
            curl_ffi()[].easy_cleanup(self.easy)

    def set_option(self, option: Option, mut parameter: String) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option[origin: Origin, //](self, option: Option, parameter: Span[UInt8, origin]) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option(self, option: Option, parameter: c_long) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option[origin: Origin, //](self, option: Option, parameter: OpaquePointer[origin]) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def set_option(self, option: Option, parameter: WriteCallbackFn) -> Result:
        return curl_ffi()[].easy_setopt(self.easy, option.value, parameter)

    def get_info(self, info: Info) raises -> String:
        # Data is filled by data owned curl and must not be freed by the caller (this library) :)
        var data = MutExternalPointer[c_char]()
        var result = curl_ffi()[].easy_getinfo(self.easy, info, data)
        if result.value != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return String(StringSlice(unsafe_from_utf8_ptr=data))

    def get_info_long(self, info: Info) raises -> c_long:
        var response: c_long = 0
        var result = curl_ffi()[].easy_getinfo(self.easy, info, response)
        if result.value != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return response

    def get_info_float(self, info: Info) raises -> Float64:
        var response: Float64 = 0
        var result = curl_ffi()[].easy_getinfo(self.easy, info, response)
        if result.value != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return response

    def get_info_ptr[origin: MutOrigin, //](self, info: Info, mut ptr: MutOpaquePointer[origin]) raises:
        var result = curl_ffi()[].easy_getinfo(self.easy, info, ptr)
        if result.value != 0:
            raise Error(t"Failed to get info: {self.describe_error(result)}")

    def get_info_curl_slist(self, info: Info) raises -> CurlList:
        var list = CurlList()
        var result = curl_ffi()[].easy_getinfo(self.easy, info, list.data)
        if result.value != 0:
            list^.free()
            raise Error(t"Failed to get info: {self.describe_error(result)}")

        return list^

    def perform(self) -> Result:
        return curl_ffi()[].easy_perform(self.easy)

    def cleanup(self):
        curl_ffi()[].easy_cleanup(self.easy)

    def reset(self):
        curl_ffi()[].easy_reset(self.easy)

    def describe_error(self, code: Result) -> String:
        # TODO: StringSlice crashes, probably getting skill issued by
        # pointer lifetime. Theoretically StringSlice[ImmutAnyOrigin] should work.
        return String(unsafe_from_utf8_ptr=curl_ffi()[].easy_strerror(code))

    # Behavior options

    def verbose(self, *, verbose: Bool) -> Result:
        return self.set_option(Option.VERBOSE, c_long(Int(verbose)))

    def show_header(self, *, show: Bool) -> Result:
        return self.set_option(Option.HEADER, c_long(Int(show)))

    def progress(self, *, progress: Bool) -> Result:
        return self.set_option(Option.NO_PROGRESS, c_long(Int(not progress)))

    def signal(self, *, signal: Bool) -> Result:
        return self.set_option(Option.NO_SIGNAL, c_long(Int(not signal)))

    def wildcard_match(self, *, enable: Bool) -> Result:
        return self.set_option(Option.WILDCARD_MATCH, c_long(Int(enable)))

    # =========================================================================
    # Error options

    # TODO: error buffer and stderr

    def fail_on_error(self, *, fail: Bool) -> Result:
        return self.set_option(Option.FAIL_ON_ERROR, c_long(Int(fail)))

    # =========================================================================
    # Network options

    def url(self, mut url: String) -> Result:
        return self.set_option(Option.URL, url)

    def port(self, port: Int) -> Result:
        return self.set_option(Option.PORT, c_long(port))

    # =========================================================================
    # Connection options

    def connect_to(self, list: List) -> Result:
        # TODO: Implement list handling for CURLOPT_CONNECT_TO
        # This requires curl_slist support which needs to be added
        return Result(0)

    def path_as_is(self, *, as_is: Bool) -> Result:
        return self.set_option(Option.PATH_AS_IS, c_long(Int(as_is)))

    def proxy(self, mut url: String) -> Result:
        return self.set_option(Option.PROXY, url)

    def proxy_port(self, port: Int) -> Result:
        return self.set_option(Option.PROXY_PORT, c_long(port))

    def no_proxy(self, mut skip: String) -> Result:
        return self.set_option(Option.NO_PROXY, skip)

    def http_proxy_tunnel(self, *, tunnel: Bool) -> Result:
        return self.set_option(Option.HTTP_PROXY_TUNNEL, c_long(Int(tunnel)))

    def interface(self, mut interface: String) -> Result:
        return self.set_option(Option.INTERFACE, interface)

    def set_local_port(self, port: Int) -> Result:
        return self.set_option(Option.LOCAL_PORT, c_long(port))

    def local_port_range(self, range: Int) -> Result:
        return self.set_option(Option.LOCAL_PORT_RANGE, c_long(range))

    def dns_servers(self, mut servers: String) -> Result:
        return self.set_option(Option.DNS_SERVERS, servers)

    def dns_cache_timeout(self, seconds: Int) -> Result:
        return self.set_option(Option.DNS_CACHE_TIMEOUT, c_long(seconds))

    def doh_url(self, mut url: String) -> Result:
        return self.set_option(Option.DOH_URL, url)

    def doh_ssl_verify_peer(self, *, verify: Bool) -> Result:
        return self.set_option(Option.DOH_SSL_VERIFY_PEER, c_long(Int(verify)))

    def doh_ssl_verify_host(self, *, verify: Bool) -> Result:
        return self.set_option(Option.DOH_SSL_VERIFY_HOST, c_long(Int(2 if verify else 0)))

    def proxy_cainfo(self, mut cainfo: String) -> Result:
        return self.set_option(Option.PROXY_CAINFO, cainfo)

    def proxy_capath(self, mut path: String) -> Result:
        return self.set_option(Option.PROXY_CAPATH, path)

    def proxy_sslcert(self, mut sslcert: String) -> Result:
        return self.set_option(Option.PROXY_SSL_CERT, sslcert)

    def proxy_sslcert_type(self, mut kind: String) -> Result:
        return self.set_option(Option.PROXY_SSL_CERT_TYPE, kind)

    def proxy_sslkey(self, mut sslkey: String) -> Result:
        return self.set_option(Option.PROXY_SSL_KEY, sslkey)

    def proxy_sslkey_type(self, mut kind: String) -> Result:
        return self.set_option(Option.PROXY_SSL_KEY_TYPE, kind)

    def proxy_key_password(self, mut password: String) -> Result:
        return self.set_option(Option.PROXY_KEYPASSWD, password)

    def proxy_type(self, kind: Int) -> Result:
        return self.set_option(Option.PROXY_TYPE, c_long(kind))

    def doh_ssl_verify_status(self, *, verify: Bool) -> Result:
        return self.set_option(Option.DOH_SSL_VERIFY_STATUS, c_long(Int(verify)))

    def buffer_size(self, size: Int) -> Result:
        return self.set_option(Option.BUFFER_SIZE, c_long(size))

    def upload_buffer_size(self, size: Int) -> Result:
        return self.set_option(Option.UPLOAD_BUFFER_SIZE, c_long(size))

    # # Enable or disable TCP Fast Open
    # #
    # # By default this options defaults to `false` and corresponds to
    # # `CURLOPT_TCP_FASTOPEN`
    # def fast_open(self, enable: Bool) -> Result:
    #

    def tcp_nodelay(self, *, enable: Bool) -> Result:
        return self.set_option(Option.TCP_NODELAY, c_long(Int(enable)))

    def tcp_keepalive(self, *, enable: Bool) -> Result:
        return self.set_option(Option.TCP_KEEPALIVE, c_long(Int(enable)))

    def tcp_keepidle(self, seconds: Int) -> Result:
        return self.set_option(Option.TCP_KEEPIDLE, c_long(seconds))

    def tcp_keepintvl(self, seconds: Int) -> Result:
        return self.set_option(Option.TCP_KEEPINTVL, c_long(seconds))

    def address_scope(self, scope: Int) -> Result:
        return self.set_option(Option.ADDRESS_SCOPE, c_long(scope))

    # =========================================================================
    # Names and passwords

    def username(self, mut user: String) -> Result:
        return self.set_option(Option.USERNAME, user)

    def password(self, mut pass_: String) -> Result:
        return self.set_option(Option.PASSWORD, pass_)

    def http_auth(self, auth: Int) -> Result:
        return self.set_option(Option.HTTP_AUTH, c_long(auth))

    def aws_sigv4(self, mut param: String) -> Result:
        return self.set_option(Option.AWS_SIGV4, param)

    def proxy_username(self, mut user: String) -> Result:
        return self.set_option(Option.PROXY_USERNAME, user)

    def proxy_password(self, mut pass_: String) -> Result:
        return self.set_option(Option.PROXY_PASSWORD, pass_)

    def proxy_auth(self, auth: Int) -> Result:
        return self.set_option(Option.PROXY_AUTH, c_long(auth))

    def netrc(self, netrc: Int) -> Result:
        return self.set_option(Option.NETRC, c_long(netrc))

    # =========================================================================
    # HTTP Options

    def autoreferer(self, *, enable: Bool) -> Result:
        return self.set_option(Option.AUTO_REFERER, c_long(Int(enable)))

    def accept_encoding(self, mut encoding: String) -> Result:
        return self.set_option(Option.ACCEPT_ENCODING, encoding)

    def transfer_encoding(self, *, enable: Bool) -> Result:
        return self.set_option(Option.TRANSFER_ENCODING, c_long(Int(enable)))

    def follow_location(self, *, enable: Bool) -> Result:
        return self.set_option(Option.FOLLOW_LOCATION, c_long(Int(enable)))

    def unrestricted_auth(self, *, enable: Bool) -> Result:
        return self.set_option(Option.UNRESTRICTED_AUTH, c_long(Int(enable)))

    def max_redirections(self, max: Int) -> Result:
        return self.set_option(Option.MAXREDIRS, c_long(max))

    def post_redirections(self, redirects: Int) -> Result:
        return self.set_option(Option.POST_REDIR, c_long(redirects))

    # def put(self, *, enable: Bool) -> Result:
    #     """Make an HTTP PUT request.

    #     By default this option is `false` and corresponds to `CURLOPT_PUT`.
    #     """
    #     return self.set_option(Option.PUT, c_long(Int(enable)))

    def post(self, *, enable: Bool) -> Result:
        return self.set_option(Option.POST, c_long(Int(enable)))

    def post_fields[origin: ImmutOrigin, //](self, data: Span[UInt8, origin]) -> Result:
        return self.set_option(Option.POST_FIELDS, data)

    def post_fields_copy[origin: ImmutOrigin, //](self, data: Span[UInt8, origin]) -> Result:
        return self.set_option(Option.COPY_POST_FIELDS, data)

    def post_field_size(self, size: Int) -> Result:
        return self.set_option(Option.POST_FIELD_SIZE, c_long(size))

    def post_field_size_large(self, size: Int) -> Result:
        return self.set_option(Option.POST_FIELD_SIZE_LARGE, c_long(size))

    # TODO: httppost - needs Form type implementation
    # def httppost(self, form: Form) -> Result:
    #     """Tells libcurl you want a multipart/formdata HTTP POST to be made and you
    #     instruct what data to pass on to the server in the `form` argument.
    #
    #     By default this option is set to null and corresponds to
    #     `CURLOPT_HTTPPOST`.
    #     """
    #     # TODO: Implement this when Form type is available
    #     pass

    def referer(self, mut referer: String) -> Result:
        return self.set_option(Option.REFERER, referer)

    def useragent(self, mut useragent: String) -> Result:
        return self.set_option(Option.USERAGENT, useragent)

    # TODO: http_headers - needs List type implementation
    # def http_headers(self, list: List) -> Result:
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
    # def proxy_headers(self, list: List) -> Result:
    #     pass

    def cookie(self, mut cookie: String) -> Result:
        return self.set_option(Option.COOKIE, cookie)

    # TODO: cookie_file - needs path handling
    def cookie_file(self, path: Optional[Path]) -> Result:
        var file = String(path.value()) if path else ""
        return self.set_option(Option.COOKIE_FILE, file)

    # TODO: cookie_jar - needs path handling
    def cookie_jar(self, path: Optional[Path]) -> Result:
        var file = String(path.value()) if path else "-"  # default to stdout
        return self.set_option(Option.COOKIEJAR, file)

    def cookie_session(self, *, session: Bool) -> Result:
        return self.set_option(Option.COOKIE_SESSION, c_long(Int(session)))

    def cookie_list(self, mut cookie: String) -> Result:
        return self.set_option(Option.COOKIE_LIST, cookie)

    def cookies(self) raises -> CurlList:
        return self.get_info_curl_slist(Info.COOKIE_LIST)

    def get(self, *, enable: Bool) -> Result:
        return self.set_option(Option.HTTPGET, c_long(Int(enable)))

    # # Ask for a HTTP GET request.
    # #
    # # By default this option is `false` and corresponds to `CURLOPT_HTTPGET`.
    # def http_version(self, vers: String) -> Result:
    #     pass

    def ignore_content_length(self, *, ignore: Bool) -> Result:
        return self.set_option(Option.IGNORE_CONTENT_LENGTH, c_long(Int(ignore)))

    def http_content_decoding(self, *, enable: Bool) -> Result:
        return self.set_option(Option.HTTP_CONTENT_DECODING, c_long(Int(enable)))

    def http_transfer_decoding(self, *, enable: Bool) -> Result:
        return self.set_option(Option.HTTP_TRANSFER_DECODING, c_long(Int(enable)))

    # # Timeout for the Expect: 100-continue response
    # #
    # # By default this option is 1s and corresponds to
    # # `CURLOPT_EXPECT_100_TIMEOUT_MS`.
    # def expect_100_timeout(self, enable: Bool) -> Result:
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
    # def http_pipewait(self, enable: Bool) -> Result:
    #     pass

    # =========================================================================
    # Protocol Options

    def range(self, mut range: String) -> Result:
        return self.set_option(Option.RANGE, range)

    def resume_from(self, from_byte: Int) -> Result:
        return self.set_option(Option.RESUME_FROM_LARGE, c_long(from_byte))

    def custom_request(self, mut request: String) -> Result:
        return self.set_option(Option.CUSTOM_REQUEST, request)

    def fetch_filetime(self, *, fetch: Bool) -> Result:
        return self.set_option(Option.FILE_TIME, c_long(Int(fetch)))

    def nobody(self, *, enable: Bool) -> Result:
        return self.set_option(Option.NO_BODY, c_long(Int(enable)))

    def read_file_size(self, size: Int) -> Result:
        return self.set_option(Option.IN_FILE_SIZE_LARGE, c_long(size))

    def upload(self, *, enable: Bool) -> Result:
        return self.set_option(Option.UPLOAD, c_long(Int(enable)))

    def max_filesize(self, size: Int) -> Result:
        return self.set_option(Option.MAX_FILE_SIZE_LARGE, c_long(size))

    def time_condition(self, cond: Int) -> Result:
        return self.set_option(Option.TIME_CONDITION, c_long(cond))

    def time_value(self, val: Int) -> Result:
        return self.set_option(Option.TIME_VALUE, c_long(val))

    # =========================================================================
    # Connection Options

    def timeout(self, timeout_ms: Int) -> Result:
        return self.set_option(Option.TIMEOUT_MS, c_long(timeout_ms))

    def low_speed_limit(self, limit: Int) -> Result:
        return self.set_option(Option.LOW_SPEED_LIMIT, c_long(limit))

    def low_speed_time(self, seconds: Int) -> Result:
        return self.set_option(Option.LOW_SPEED_TIME, c_long(seconds))

    def max_send_speed(self, speed: Int) -> Result:
        return self.set_option(Option.MAX_SEND_SPEED_LARGE, c_long(speed))

    def max_recv_speed(self, speed: Int) -> Result:
        return self.set_option(Option.MAX_RECV_SPEED_LARGE, c_long(speed))

    def max_connects(self, max: Int) -> Result:
        return self.set_option(Option.MAX_CONNECTS, c_long(max))

    def maxage_conn(self, max_age_seconds: Int) -> Result:
        return self.set_option(Option.MAX_AGE_CONN, c_long(max_age_seconds))

    def fresh_connect(self, *, enable: Bool) -> Result:
        return self.set_option(Option.FRESH_CONNECT, c_long(Int(enable)))

    def forbid_reuse(self, *, enable: Bool) -> Result:
        return self.set_option(Option.FORBID_REUSE, c_long(Int(enable)))

    def connect_timeout(self, timeout_ms: Int) -> Result:
        return self.set_option(Option.CONNECT_TIMEOUT_MS, c_long(timeout_ms))

    def ip_resolve(self, resolve: Int) -> Result:
        return self.set_option(Option.IP_RESOLVE, c_long(resolve))

    # TODO: resolve - needs List type implementation
    # def resolve(self, list: List) -> Result:
    #     """Specify custom host name to IP address resolves.
    #
    #     Allows specifying hostname to IP mappings to use before trying the
    #     system resolver.
    #     """
    #     # TODO: Implement this when List type is available
    #     pass

    def connect_only(self, *, enable: Bool) -> Result:
        return self.set_option(Option.CONNECT_ONLY, c_long(Int(enable)))

    # # Set interface to speak DNS over.
    # #
    # # Set the name of the network interface that the DNS resolver should bind
    # # to. This must be an interface name (not an address).
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_DNS_INTERFACE`.
    # def dns_interface(self, mut interface: String) -> Result:
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
    # def dns_local_ip4(self, mut ip: String) -> Result:
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
    # def dns_local_ip6(self, mut ip: String) -> Result:
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
    # def dns_servers(self, mut servers: String) -> Result:
    #     pass

    # =========================================================================
    # SSL/Security Options

    # TODO: ssl_cert - needs path handling
    # def ssl_cert(self, cert: String) -> Result:
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
    # def ssl_cert_blob(self, blob: List[UInt8]) -> Result:
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

    def ssl_cert_type(self, mut kind: String) -> Result:
        return self.set_option(Option.SSL_CERT_TYPE, kind)

    # TODO: ssl_key - needs path handling
    # def ssl_key(self, key: String) -> Result:
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
    # def ssl_key_blob(self, blob: List[UInt8]) -> Result:
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

    def ssl_key_type(self, mut kind: String) -> Result:
        return self.set_option(Option.SSL_KEY_TYPE, kind)

    def key_password(self, mut password: String) -> Result:
        return self.set_option(Option.KEY_PASSWD, password)

    # TODO: ssl_cainfo_blob - needs byte array handling
    # def ssl_cainfo_blob(self, blob: List[UInt8]) -> Result:
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
    # def proxy_ssl_cainfo_blob(self, blob: List[UInt8]) -> Result:
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

    def ssl_engine(self, mut engine: String) -> Result:
        return self.set_option(Option.SSL_ENGINE, engine)

    def ssl_engine_default(self, *, enable: Bool) -> Result:
        return self.set_option(Option.SSL_ENGINE_DEFAULT, c_long(Int(enable)))

    # # Enable TLS false start.
    # #
    # # This option determines whether libcurl should use false start during the
    # # TLS handshake. False start is a mode where a TLS client will start
    # # sending application data before verifying the server's Finished message,
    # # thus saving a round trip when performing a full handshake.
    # #
    # # By default this option is not set and corresponds to
    # # `CURLOPT_SSL_FALSESTARTE`.
    # def ssl_false_start(self, enable: Bool) -> Result:
    #     pass

    def http_version(self, version: Int) -> Result:
        return self.set_option(Option.HTTP_VERSION, c_long(version))

    def ssl_version(self, version: Int) -> Result:
        return self.set_option(Option.SSL_VERSION, c_long(version))

    def proxy_ssl_version(self, version: Int) -> Result:
        return self.set_option(Option.PROXY_SSL_VERSION, c_long(version))

    def ssl_min_max_version(self, min_version: Int, max_version: Int) -> Result:
        var version = min_version | (max_version << 16)
        return self.set_option(Option.SSL_VERSION, c_long(version))

    def proxy_ssl_min_max_version(self, min_version: Int, max_version: Int) -> Result:
        var version = min_version | (max_version << 16)
        return self.set_option(Option.PROXY_SSL_VERSION, c_long(version))

    def ssl_verify_host(self, *, verify: Bool) -> Result:
        var val = 2 if verify else 0
        return self.set_option(Option.SSL_VERIFY_HOST, c_long(val))

    def proxy_ssl_verify_host(self, *, verify: Bool) -> Result:
        var val = 2 if verify else 0
        return self.set_option(Option.PROXY_SSL_VERIFYHOST, c_long(val))

    def ssl_verify_peer(self, *, verify: Bool) -> Result:
        return self.set_option(Option.SSL_VERIFYPEER, c_long(Int(verify)))

    def proxy_ssl_verify_peer(self, *, verify: Bool) -> Result:
        return self.set_option(Option.PROXY_SSL_VERIFYPEER, c_long(Int(verify)))

    # # Verify the certificate's status.
    # #
    # # This option determines whether libcurl verifies the status of the server
    # # cert using the "Certificate Status Request" TLS extension (aka. OCSP
    # # stapling).
    # #
    # # By default this option is set to `false` and corresponds to
    # # `CURLOPT_SSL_VERIFYSTATUS`.
    # def ssl_verify_status(self, verify: Bool) -> Result:
    #     pass

    # TODO: Specify the path to Certificate Authority (CA) bundle
    # Requires Path type support
    # def cainfo(self, path: Path) -> Result:
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
    # def issuer_cert(self, path: Path) -> Result:
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
    # def proxy_issuer_cert(self, path: Path) -> Result:
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
    # def issuer_cert_blob(self, blob: Bytes) -> Result:
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
    # def proxy_issuer_cert_blob(self, blob: Bytes) -> Result:
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
    # def capath(self, path: Path) -> Result:
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
    # def crlfile(self, path: Path) -> Result:
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
    # def proxy_crlfile(self, path: Path) -> Result:
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

    def certinfo(self, *, enable: Bool) -> Result:
        return self.set_option(Option.CERT_INFO, c_long(Int(enable)))

    def pinned_public_key(self, mut pubkey: String) -> Result:
        return self.set_option(Option.PINNED_PUBLIC_KEY, pubkey)

    # TODO: Specify a source for random data
    # Requires Path type support
    # def random_file(self, path: Path) -> Result:
    #     """The file will be used to read from to seed the random engine for SSL and
    #     more.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_RANDOM_FILE.
    #     """
    #     return self.set_option(Option.RANDOM_FILE, path)

    # TODO: Specify EGD socket path
    # Requires Path type support
    # def egd_socket(self, path: Path) -> Result:
    #     """Indicates the path name to the Entropy Gathering Daemon socket. It will
    #     be used to seed the random engine for SSL.
    #
    #     By default this option is not set and corresponds to
    #     CURLOPT_EGDSOCKET.
    #     """
    #     return self.set_option(Option.EGDSOCKET, path)

    def ssl_cipher_list(self, mut ciphers: String) -> Result:
        return self.set_option(Option.SSL_CIPHER_LIST, ciphers)

    def proxy_ssl_cipher_list(self, mut ciphers: String) -> Result:
        return self.set_option(Option.PROXY_SSL_CIPHER_LIST, ciphers)

    def ssl_sessionid_cache(self, *, enable: Bool) -> Result:
        return self.set_option(Option.SSL_SESSIONID_CACHE, c_long(Int(enable)))

    # TODO: Set SSL behavior options
    # Requires SslOpt type support
    # def ssl_options(self, bits: SslOpt) -> Result:
    #     """Inform libcurl about SSL specific behaviors.
    #
    #     This corresponds to the CURLOPT_SSL_OPTIONS option.
    #     """
    #     return self.set_option(Option.SSL_OPTIONS, bits.bits)

    # TODO: Set SSL behavior options for proxies
    # Requires SslOpt type support
    # def proxy_ssl_options(self, bits: SslOpt) -> Result:
    #     """Inform libcurl about SSL specific behaviors.
    #
    #     This corresponds to the CURLOPT_PROXY_SSL_OPTIONS option.
    #     """
    #     return self.set_option(Option.PROXY_SSL_OPTIONS, bits.bits)

    # =========================================================================
    # Getters

    # TODO: Set maximum time to wait for Expect 100 request before sending body
    # Requires Duration type support
    # def expect_100_timeout(self, timeout_ms: Int) -> Result:
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

    def effective_url(self) raises -> String:
        return self.get_info(Info.EFFECTIVE_URL)

    def response_code(self) raises -> c_long:
        return self.get_info_long(Info.RESPONSE_CODE)

    def http_connectcode(self) raises -> c_long:
        return self.get_info_long(Info.HTTP_CONNECT_CODE)

    def file_time(self) raises -> c_long:
        return self.get_info_long(Info.FILE_TIME)

    def redirect_count(self) raises -> c_long:
        return self.get_info_long(Info.REDIRECT_COUNT)

    def redirect_url(self) raises -> String:
        return self.get_info(Info.REDIRECT_URL)

    def header_size(self) raises -> c_long:
        return self.get_info_long(Info.HEADER_SIZE)

    def request_size(self) raises -> c_long:
        return self.get_info_long(Info.REQUEST_SIZE)

    def content_type(self) raises -> String:
        return self.get_info(Info.CONTENT_TYPE)

    def os_errno(self) raises -> c_long:
        return self.get_info_long(Info.OS_ERRNO)

    def primary_ip(self) raises -> String:
        return self.get_info(Info.PRIMARY_IP)

    def primary_port(self) raises -> c_long:
        return self.get_info_long(Info.PRIMARY_PORT)

    def local_ip(self) raises -> String:
        return self.get_info(Info.LOCAL_IP)

    def local_port(self) raises -> c_long:
        return self.get_info_long(Info.LOCAL_PORT)

    def time_condition_unmet(self) raises -> c_long:
        return self.get_info_long(Info.CONDITION_UNMET)

    def download_size(self) raises -> Float64:
        return self.get_info_float(Info.CONTENT_LENGTH_DOWNLOAD_T)

    def upload_size(self) raises -> Float64:
        return self.get_info_float(Info.CONTENT_LENGTH_UPLOAD_T)

    def total_time(self) raises -> Float64:
        return self.get_info_float(Info.TOTAL_TIME)

    def namelookup_time(self) raises -> Float64:
        return self.get_info_float(Info.NAME_LOOKUP_TIME)

    def connect_time(self) raises -> Float64:
        return self.get_info_float(Info.CONNECT_TIME)

    def appconnect_time(self) raises -> Float64:
        return self.get_info_float(Info.APP_CONNECT_TIME)

    def pretransfer_time(self) raises -> Float64:
        return self.get_info_float(Info.PRE_TRANSFER_TIME)

    def starttransfer_time(self) raises -> Float64:
        return self.get_info_float(Info.START_TRANSFER_TIME)

    def redirect_time(self) raises -> Float64:
        return self.get_info_float(Info.REDIRECT_TIME)

    def speed_download(self) raises -> Float64:
        return self.get_info_float(Info.SPEED_DOWNLOAD_T)

    def speed_upload(self) raises -> Float64:
        return self.get_info_float(Info.SPEED_UPLOAD_T)

    def pipewait(self, *, wait: Bool) -> Result:
        return self.set_option(Option.PIPE_WAIT, c_long(Int(wait)))

    def http_09_allowed(self, *, allow: Bool) -> Result:
        return self.set_option(Option.HTTP09_ALLOWED, c_long(Int(allow)))

    def get_scheme(self) raises -> String:
        return self.get_info(Info.SCHEME)

    def headers(self, origin: HeaderOrigin) -> Dict[String, String]:
        var headers = Dict[String, String]()
        var prev = MutExternalPointer[curl_header]()

        while True:
            var h = curl_ffi()[].easy_nextheader(self.easy, origin.value, 0, prev)
            if not h:
                break
            prev = h
            headers[String(unsafe_from_utf8_ptr=h[].name)] = String(unsafe_from_utf8_ptr=h[].value)

        return headers^

    # =========================================================================
    # Callback options

    def write_function(self, callback: WriteCallbackFn) -> Result:
        return self.set_option(Option.WRITE_FUNCTION, callback)

    def write_data[origin: MutOrigin, //](self, data: MutOpaquePointer[origin]) -> Result:
        return self.set_option(Option.WRITE_DATA, data)

    def read_function(self, callback: ReadCallbackFn) -> Result:
        return self.set_option(Option.READ_FUNCTION, callback)

    def read_data[origin: ImmutOrigin, //](self, data: ImmutOpaquePointer[origin]) -> Result:
        return self.set_option(Option.READ_DATA, data)

    def escape(self, mut string: String) raises -> String:
        var data = curl_ffi()[].easy_escape(self.easy, string, 0)
        if not data:
            raise Error("Failed to escape string.")

        return String(unsafe_from_utf8_ptr=data)
