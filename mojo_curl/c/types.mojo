from sys.ffi import c_char, c_int, c_long, c_size_t, c_uint


comptime ImmutExternalPointer = ImmutUnsafePointer[origin = ImmutExternalOrigin]
comptime ImmutExternalOpaquePointer = ImmutExternalPointer[NoneType]
comptime MutExternalPointer = MutUnsafePointer[origin = MutExternalOrigin]
comptime MutExternalOpaquePointer = MutExternalPointer[NoneType]

# Type aliases for curl
comptime CURL = ImmutExternalOpaquePointer
# comptime CURLcode = c_int
# comptime CURLoption = c_int

# comptime CURLMcode = c_int
# comptime CURLM = OpaquePointer
# comptime CURLMsg = OpaquePointer


@register_passable("trivial")
struct curl_slist:
    """Singly linked list structure for curl string lists."""

    var data: MutExternalPointer[c_char]
    var next: MutExternalPointer[curl_slist]


comptime curl_socket_t = c_int
comptime CURL_SOCKET_BAD = -1

comptime curl_off_t = c_long

# Callback function types
comptime curl_rw_callback = fn (
    MutExternalPointer[c_char], c_size_t, c_size_t, MutExternalOpaquePointer
) -> c_size_t
comptime curl_read_callback = fn (ImmutExternalPointer[c_char], c_size_t, c_size_t, MutExternalOpaquePointer) -> c_size_t
comptime curl_progress_callback = fn (ImmutExternalOpaquePointer, Float64, Float64, Float64, Float64) -> c_int
comptime curl_debug_callback = fn (CURL, c_int, UnsafePointer[c_char], c_size_t, MutExternalOpaquePointer) -> c_int
comptime curl_xferinfo_callback = fn (ImmutExternalOpaquePointer, curl_off_t, curl_off_t, curl_off_t, curl_off_t) -> c_int
"""This is the XFERINFOFUNCTION callback prototype. It was introduced 
in 7.32.0, avoids the use of floating point numbers and provides more
detailed information."""


struct curl_blob[origin: MutOrigin](Movable):
    """CURL blob struct for binary data transfer.

    This struct represents binary data that can be passed to curl,
    with control over whether curl should copy the data or use it directly.
    """

    var data: MutOpaquePointer[Self.origin]
    var len: c_size_t
    var flags: c_uint

    fn __init__(out self, data: MutOpaquePointer[Self.origin], len: c_size_t, flags: c_uint = CURL_BLOB_COPY):
        """Initialize a curl_blob struct.

        Args:
            data: Pointer to the binary data.
            len: Length of the data in bytes.
            flags: Control flags (CURL_BLOB_COPY or CURL_BLOB_NOCOPY).
        """
        self.data = data
        self.len = len
        self.flags = flags


# Flag bits for curl_blob struct
comptime CURL_BLOB_COPY = 1
comptime CURL_BLOB_NOCOPY = 0


# Common CURLcode values
@register_passable("trivial")
struct Result(Copyable, Equatable, Writable):
    var value: c_int
    comptime OK: Self = 0
    comptime UNSUPPORTED_PROTOCOL: Self = 1
    comptime FAILED_INIT: Self = 2
    comptime URL_MALFORMAT: Self = 3
    comptime NOT_BUILT_IN: Self = 4
    comptime COULDNT_RESOLVE_PROXY: Self = 5
    comptime COULDNT_RESOLVE_HOST: Self = 6
    comptime COULDNT_CONNECT: Self = 7
    comptime WEIRD_SERVER_REPLY: Self = 8
    comptime REMOTE_ACCESS_DENIED: Self = 9
    comptime FTP_ACCEPT_FAILED: Self = 10
    comptime FTP_WEIRD_PASS_REPLY: Self = 11
    comptime FTP_ACCEPT_TIMEOUT: Self = 12
    comptime FTP_WEIRD_PASV_REPLY: Self = 13
    comptime FTP_WEIRD_227_FORMAT: Self = 14
    comptime FTP_CANT_GET_HOST: Self = 15
    comptime HTTP2: Self = 16
    comptime FTP_COULDNT_SET_TYPE: Self = 17
    comptime PARTIAL_FILE: Self = 18
    comptime FTP_COULDNT_RETR_FILE: Self = 19
    comptime QUOTE_ERROR: Self = 21
    comptime HTTP_RETURNED_ERROR: Self = 22
    comptime WRITE_ERROR: Self = 23
    comptime UPLOAD_FAILED: Self = 25
    comptime READ_ERROR: Self = 26
    comptime OUT_OF_MEMORY: Self = 27
    comptime OPERATION_TIMEDOUT: Self = 28
    comptime FTP_PORT_FAILED: Self = 30
    comptime FTP_COULDNT_USE_REST: Self = 31
    comptime RANGE_ERROR: Self = 33
    comptime HTTP_POST_ERROR: Self = 34
    comptime SSL_CONNECT_ERROR: Self = 35
    comptime BAD_DOWNLOAD_RESUME: Self = 36
    comptime FILE_COULDNT_READ_FILE: Self = 37
    comptime LDAP_CANNOT_BIND: Self = 38
    comptime LDAP_SEARCH_FAILED: Self = 39
    comptime FUNCTION_NOT_FOUND: Self = 41
    comptime ABORTED_BY_CALLBACK: Self = 42
    comptime BAD_FUNCTION_ARGUMENT: Self = 43
    comptime INTERFACE_FAILED: Self = 45
    comptime TOO_MANY_REDIRECTS: Self = 47
    comptime UNKNOWN_OPTION: Self = 48
    comptime GOT_NOTHING: Self = 52
    comptime SSL_ENGINE_NOTFOUND: Self = 53
    comptime SSL_ENGINE_SETFAILED: Self = 54
    comptime SEND_ERROR: Self = 55
    comptime RECV_ERROR: Self = 56
    comptime SSL_CERT_PROBLEM: Self = 58
    comptime SSL_CIPHER: Self = 59
    comptime PEER_FAILED_VERIFICATION: Self = 60
    comptime BAD_CONTENT_ENCODING: Self = 61
    comptime FILESIZE_EXCEEDED: Self = 63
    comptime USE_SSL_FAILED: Self = 64
    comptime SEND_FAIL_REWIND: Self = 65
    comptime SSL_ENGINE_INITFAILED: Self = 66
    comptime LOGIN_DENIED: Self = 67
    comptime TFTP_NOTFOUND: Self = 68
    comptime TFTP_PERM: Self = 69
    comptime REMOTE_DISK_FULL: Self = 70
    comptime TFTP_ILLEGAL: Self = 71
    comptime TFTP_UNKNOWN_ID: Self = 72
    comptime REMOTE_FILE_EXISTS: Self = 73
    comptime TFTP_NO_SUCH_USER: Self = 74
    comptime SSL_CACERT_BAD_FILE: Self = 77
    comptime REMOTE_FILE_NOT_FOUND: Self = 78
    comptime SSH: Self = 79
    comptime SSL_SHUTDOWN_FAILED: Self = 80
    comptime AGAIN: Self = 81
    comptime SSL_CRL_BADFILE: Self = 82
    comptime SSL_ISSUER_ERROR: Self = 83
    comptime FTP_PRET_FAILED: Self = 84
    comptime RTSP_CSEQ_ERROR: Self = 85
    comptime RTSP_SESSION_ERROR: Self = 86
    comptime FTP_BAD_FILE_LIST: Self = 87
    comptime CHUNK_FAILED: Self = 88
    comptime NO_CONNECTION_AVAILABLE: Self = 89
    comptime SSL_PINNED_PUBKEY_NOT_MATCH: Self = 90
    comptime SSL_INVALID_CERT_STATUS: Self = 91
    comptime HTTP2_STREAM: Self = 92
    comptime RECURSIVE_API_CALL: Self = 93
    comptime AUTH_ERROR: Self = 94
    comptime HTTP3: Self = 95
    comptime QUIC_CONNECT_ERROR: Self = 96
    comptime PROXY: Self = 97
    comptime SSL_CLIENTCERT: Self = 98
    comptime UNRECOVERABLE_POLL: Self = 99
    comptime SSL_PEER_CERTIFICATE: Self = 60  # Alias for PEER_FAILED_VERIFICATION

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    @implicit
    fn __init__(out self, value: Int32):
        self.value = value

    fn __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    fn write_to[W: Writer, //](self, mut writer: W):
        """Write the error message corresponding to the CURLcode to the given writer."""
        writer.write("Result(", self.value, ")")


# CURLOPT options (commonly used ones)
@register_passable("trivial")
struct Option(Copyable, Movable):
    var value: c_int

    comptime LONG = 0
    comptime OBJECT_POINT = 10_000
    comptime FUNCTION_POINT = 20_000
    comptime OFF_T = 30_000
    comptime BLOB = 40_000
    comptime VALUES = Self.LONG

    comptime WRITE_DATA: Self = Self.OBJECT_POINT + 1
    comptime FILE: Self = Self.WRITE_DATA
    comptime URL: Self = Self.OBJECT_POINT + 2
    comptime PORT: Self = Self.LONG + 3
    comptime PROXY: Self = Self.OBJECT_POINT + 4
    comptime USER_PWD: Self = Self.OBJECT_POINT + 5
    comptime PROXY_USER_PWD: Self = Self.OBJECT_POINT + 6
    comptime RANGE: Self = Self.OBJECT_POINT + 7
    comptime IN_FILE: Self = Self.OBJECT_POINT + 9
    comptime READ_DATA: Self = Self.OBJECT_POINT + 9
    comptime ERROR_BUFFER: Self = Self.OBJECT_POINT + 10
    comptime WRITE_FUNCTION: Self = Self.FUNCTION_POINT + 11
    comptime READ_FUNCTION: Self = Self.FUNCTION_POINT + 12
    comptime TIMEOUT: Self = Self.LONG + 13
    comptime IN_FILE_SIZE: Self = Self.LONG + 14
    comptime POST_FIELDS: Self = Self.OBJECT_POINT + 15
    comptime REFERER: Self = Self.OBJECT_POINT + 16
    comptime FTP_PORT: Self = Self.OBJECT_POINT + 17
    comptime USERAGENT: Self = Self.OBJECT_POINT + 18
    comptime LOW_SPEED_LIMIT: Self = Self.LONG + 19
    comptime LOW_SPEED_TIME: Self = Self.LONG + 20
    comptime RESUME_FROM: Self = Self.LONG + 21
    comptime COOKIE: Self = Self.OBJECT_POINT + 22
    comptime HTTP_HEADER: Self = Self.OBJECT_POINT + 23
    comptime SSL_CERT: Self = Self.OBJECT_POINT + 25
    comptime KEY_PASSWD: Self = Self.OBJECT_POINT + 26
    comptime CRLF: Self = Self.LONG + 27
    comptime QUOTE: Self = Self.OBJECT_POINT + 28
    comptime WRITE_HEADER: Self = Self.OBJECT_POINT + 29
    comptime COOKIE_FILE: Self = Self.OBJECT_POINT + 31
    comptime SSL_VERSION: Self = Self.LONG + 32
    comptime TIME_CONDITION: Self = Self.LONG + 33
    comptime TIME_VALUE: Self = Self.LONG + 34
    comptime CUSTOM_REQUEST: Self = Self.OBJECT_POINT + 36
    comptime STDERR: Self = Self.OBJECT_POINT + 37
    comptime POST_QUOTE: Self = Self.OBJECT_POINT + 39
    comptime VERBOSE: Self = Self.LONG + 41
    comptime HEADER: Self = Self.LONG + 42
    comptime NO_PROGRESS: Self = Self.LONG + 43
    comptime NO_BODY: Self = Self.LONG + 44
    comptime FAIL_ON_ERROR: Self = Self.LONG + 45
    comptime UPLOAD: Self = Self.LONG + 46
    comptime POST: Self = Self.LONG + 47
    comptime DIR_LIST_ONLY: Self = Self.LONG + 48
    comptime APPEND: Self = Self.LONG + 50
    comptime NETRC: Self = Self.LONG + 51
    comptime FOLLOW_LOCATION: Self = Self.LONG + 52
    comptime TRANSFER_TEXT: Self = Self.LONG + 53
    comptime PROGRESS_DATA: Self = Self.OBJECT_POINT + 57
    comptime AUTO_REFERER: Self = Self.LONG + 58
    comptime PROXY_PORT: Self = Self.LONG + 59
    comptime POST_FIELD_SIZE: Self = Self.LONG + 60
    comptime HTTP_PROXY_TUNNEL: Self = Self.LONG + 61
    comptime INTERFACE: Self = Self.OBJECT_POINT + 62
    comptime KRB_LEVEL: Self = Self.OBJECT_POINT + 63
    comptime SSL_VERIFYPEER: Self = Self.LONG + 64
    comptime CAINFO: Self = Self.OBJECT_POINT + 65
    comptime MAXREDIRS: Self = Self.LONG + 68
    comptime FILE_TIME: Self = Self.LONG + 69
    comptime TELNET_OPTIONS: Self = Self.OBJECT_POINT + 70
    comptime MAX_CONNECTS: Self = Self.LONG + 71
    comptime FRESH_CONNECT: Self = Self.LONG + 74
    comptime FORBID_REUSE: Self = Self.LONG + 75
    comptime CONNECT_TIMEOUT: Self = Self.LONG + 78
    comptime HEADER_FUNCTION: Self = Self.FUNCTION_POINT + 79
    comptime HTTPGET: Self = Self.LONG + 80
    comptime SSL_VERIFY_HOST: Self = Self.LONG + 81
    comptime COOKIEJAR: Self = Self.OBJECT_POINT + 82
    comptime SSL_CIPHER_LIST: Self = Self.OBJECT_POINT + 83
    comptime HTTP_VERSION: Self = Self.LONG + 84
    comptime FTP_USE_EPSV: Self = Self.LONG + 85
    comptime SSL_CERT_TYPE: Self = Self.OBJECT_POINT + 86
    comptime SSL_KEY: Self = Self.OBJECT_POINT + 87
    comptime SSL_KEY_TYPE: Self = Self.OBJECT_POINT + 88
    comptime SSL_ENGINE: Self = Self.OBJECT_POINT + 89
    comptime SSL_ENGINE_DEFAULT: Self = Self.LONG + 90
    comptime DNS_CACHE_TIMEOUT: Self = Self.LONG + 92
    comptime PREQUOTE: Self = Self.OBJECT_POINT + 93
    comptime DEBUG_FUNCTION: Self = Self.FUNCTION_POINT + 94
    comptime DEBUG_DATA: Self = Self.OBJECT_POINT + 95
    comptime COOKIE_SESSION: Self = Self.LONG + 96
    comptime CAPATH: Self = Self.OBJECT_POINT + 97
    comptime BUFFER_SIZE: Self = Self.LONG + 98
    comptime NO_SIGNAL: Self = Self.LONG + 99
    comptime SHARE: Self = Self.OBJECT_POINT + 100
    comptime PROXY_TYPE: Self = Self.LONG + 101
    comptime ACCEPT_ENCODING: Self = Self.OBJECT_POINT + 102
    comptime PRIVATE: Self = Self.OBJECT_POINT + 103
    comptime HTTP200_ALIASES: Self = Self.OBJECT_POINT + 104
    comptime UNRESTRICTED_AUTH: Self = Self.LONG + 105
    comptime FTP_USE_EPRT: Self = Self.LONG + 106
    comptime HTTP_AUTH: Self = Self.LONG + 107
    comptime SSL_CTX_FUNCTION: Self = Self.FUNCTION_POINT + 108
    comptime SSL_CTX_DATA: Self = Self.OBJECT_POINT + 109
    comptime FTP_CREATE_MISSING_DIRS: Self = Self.LONG + 110
    comptime PROXY_AUTH: Self = Self.LONG + 111
    comptime FTP_RESPONSE_TIMEOUT: Self = Self.LONG + 112
    comptime IP_RESOLVE: Self = Self.LONG + 113
    comptime MAX_FILE_SIZE: Self = Self.LONG + 114
    comptime IN_FILE_SIZE_LARGE: Self = Self.OFF_T + 115
    comptime RESUME_FROM_LARGE: Self = Self.OFF_T + 116
    comptime MAX_FILE_SIZE_LARGE: Self = Self.OFF_T + 117
    comptime NETRC_FILE: Self = Self.OBJECT_POINT + 118
    comptime USE_SSL: Self = Self.LONG + 119
    comptime POST_FIELD_SIZE_LARGE: Self = Self.OFF_T + 120
    comptime TCP_NODELAY: Self = Self.LONG + 121
    comptime FTP_SSL_AUTH: Self = Self.LONG + 129
    comptime FTP_ACCOUNT: Self = Self.OBJECT_POINT + 134
    comptime COOKIE_LIST: Self = Self.OBJECT_POINT + 135
    comptime IGNORE_CONTENT_LENGTH: Self = Self.LONG + 136
    comptime FTP_SKIP_PASV_IP: Self = Self.LONG + 137
    comptime FTP_FILE_METHOD: Self = Self.LONG + 138
    comptime LOCAL_PORT: Self = Self.LONG + 139
    comptime LOCAL_PORT_RANGE: Self = Self.LONG + 140
    comptime CONNECT_ONLY: Self = Self.LONG + 141
    comptime MAX_SEND_SPEED_LARGE: Self = Self.OFF_T + 145
    comptime MAX_RECV_SPEED_LARGE: Self = Self.OFF_T + 146
    comptime FTP_ALTERNATIVE_TO_USER: Self = Self.OBJECT_POINT + 147
    comptime SOCKOPT_FUNCTION: Self = Self.FUNCTION_POINT + 148
    comptime SOCKOPT_DATA: Self = Self.OBJECT_POINT + 149
    comptime SSL_SESSIONID_CACHE: Self = Self.LONG + 150
    comptime SSH_AUTH_TYPES: Self = Self.LONG + 151
    comptime SSH_PUBLIC_KEYFILE: Self = Self.OBJECT_POINT + 152
    comptime SSH_PRIVATE_KEYFILE: Self = Self.OBJECT_POINT + 153
    comptime FTP_SSL_CCC: Self = Self.LONG + 154
    comptime TIMEOUT_MS: Self = Self.LONG + 155
    comptime CONNECT_TIMEOUT_MS: Self = Self.LONG + 156
    comptime HTTP_TRANSFER_DECODING: Self = Self.LONG + 157
    comptime HTTP_CONTENT_DECODING: Self = Self.LONG + 158
    comptime NEW_FILE_PERMS: Self = Self.LONG + 159
    comptime NEW_DIRECTORY_PERMS: Self = Self.LONG + 160
    comptime POST_REDIR: Self = Self.LONG + 161
    comptime SSH_HOST_PUBLIC_KEY_MD5: Self = Self.OBJECT_POINT + 162
    comptime OPEN_SOCKET_FUNCTION: Self = Self.FUNCTION_POINT + 163
    comptime OPEN_SOCKET_DATA: Self = Self.OBJECT_POINT + 164
    comptime COPY_POST_FIELDS: Self = Self.OBJECT_POINT + 165
    comptime PROXY_TRANSFER_MODE: Self = Self.LONG + 166
    comptime SEEK_FUNCTION: Self = Self.FUNCTION_POINT + 167
    comptime SEEK_DATA: Self = Self.OBJECT_POINT + 168
    comptime CRL_FILE: Self = Self.OBJECT_POINT + 169
    comptime ISSUER_CERT: Self = Self.OBJECT_POINT + 170
    comptime ADDRESS_SCOPE: Self = Self.LONG + 171
    comptime CERT_INFO: Self = Self.LONG + 172
    comptime USERNAME: Self = Self.OBJECT_POINT + 173
    comptime PASSWORD: Self = Self.OBJECT_POINT + 174
    comptime PROXY_USERNAME: Self = Self.OBJECT_POINT + 175
    comptime PROXY_PASSWORD: Self = Self.OBJECT_POINT + 176
    comptime NO_PROXY: Self = Self.OBJECT_POINT + 177
    comptime TFTP_BLK_SIZE: Self = Self.LONG + 178
    comptime SOCKS5_GSSAPI_NEC: Self = Self.LONG + 180
    comptime SSH_KNOWNHOSTS: Self = Self.OBJECT_POINT + 183
    comptime SSH_KEY_FUNCTION: Self = Self.FUNCTION_POINT + 184
    comptime SSH_KEY_DATA: Self = Self.OBJECT_POINT + 185
    comptime MAIL_FROM: Self = Self.OBJECT_POINT + 186
    comptime MAIL_RCPT: Self = Self.OBJECT_POINT + 187
    comptime FTP_USE_PRET: Self = Self.LONG + 188
    comptime RTSP_REQUEST: Self = Self.LONG + 189
    comptime RTSP_SESSION_ID: Self = Self.OBJECT_POINT + 190
    comptime RTSP_STREAM_URI: Self = Self.OBJECT_POINT + 191
    comptime RTSP_TRANSPORT: Self = Self.OBJECT_POINT + 192
    comptime RTSP_CLIENT_CSEQ: Self = Self.LONG + 193
    comptime RTSP_SERVER_CSEQ: Self = Self.LONG + 194
    comptime INTERLEAVE_DATA: Self = Self.OBJECT_POINT + 195
    comptime INTERLEAVE_FUNCTION: Self = Self.FUNCTION_POINT + 196
    comptime WILDCARD_MATCH: Self = Self.LONG + 197
    comptime CHUNK_BGN_FUNCTION: Self = Self.FUNCTION_POINT + 198
    comptime CHUNK_END_FUNCTION: Self = Self.FUNCTION_POINT + 199
    comptime FN_MATCH_FUNCTION: Self = Self.FUNCTION_POINT + 200
    comptime CHUNK_DATA: Self = Self.OBJECT_POINT + 201
    comptime FN_MATCH_DATA: Self = Self.OBJECT_POINT + 202
    comptime RESOLVE: Self = Self.OBJECT_POINT + 203
    comptime TLS_AUTH_USERNAME: Self = Self.OBJECT_POINT + 204
    comptime TLS_AUTH_PASSWORD: Self = Self.OBJECT_POINT + 205
    comptime TLS_AUTH_TYPE: Self = Self.OBJECT_POINT + 206
    comptime TRANSFER_ENCODING: Self = Self.LONG + 207
    comptime CLOSE_SOCKET_FUNCTION: Self = Self.FUNCTION_POINT + 208
    comptime CLOSE_SOCKET_DATA: Self = Self.OBJECT_POINT + 209
    comptime GSSAPI_DELEGATION: Self = Self.LONG + 210
    comptime DNS_SERVERS: Self = Self.OBJECT_POINT + 211
    comptime TCP_KEEPALIVE: Self = Self.LONG + 213
    comptime TCP_KEEPIDLE: Self = Self.LONG + 214
    comptime TCP_KEEPINTVL: Self = Self.LONG + 215
    comptime SSL_OPTIONS: Self = Self.LONG + 216
    comptime EXPECT_100_TIMEOUT_MS: Self = Self.LONG + 227
    comptime PINNED_PUBLIC_KEY: Self = Self.OBJECT_POINT + 230
    comptime UNIX_SOCKET_PATH: Self = Self.OBJECT_POINT + 231
    comptime PATH_AS_IS: Self = Self.LONG + 234
    comptime PIPE_WAIT: Self = Self.LONG + 237
    comptime CONNECT_TO: Self = Self.OBJECT_POINT + 243
    comptime PROXY_CAINFO: Self = Self.OBJECT_POINT + 246
    comptime PROXY_CAPATH: Self = Self.OBJECT_POINT + 247
    comptime PROXY_SSL_VERIFYPEER: Self = Self.LONG + 248
    comptime PROXY_SSL_VERIFYHOST: Self = Self.LONG + 249
    comptime PROXY_SSL_VERSION: Self = Self.VALUES + 250
    comptime PROXY_SSL_CERT: Self = Self.OBJECT_POINT + 254
    comptime PROXY_SSL_CERT_TYPE: Self = Self.OBJECT_POINT + 255
    comptime PROXY_SSL_KEY: Self = Self.OBJECT_POINT + 256
    comptime PROXY_SSL_KEY_TYPE: Self = Self.OBJECT_POINT + 257
    comptime PROXY_KEYPASSWD: Self = Self.OBJECT_POINT + 258
    comptime PROXY_SSL_CIPHER_LIST: Self = Self.OBJECT_POINT + 259
    comptime PROXY_CRL_FILE: Self = Self.OBJECT_POINT + 260
    comptime PROXY_SSL_OPTIONS: Self = Self.LONG + 261
    comptime ABSTRACT_UNIX_SOCKET: Self = Self.OBJECT_POINT + 264
    comptime DOH_URL: Self = Self.OBJECT_POINT + 279
    comptime UPLOAD_BUFFER_SIZE: Self = Self.LONG + 280
    comptime HTTP09_ALLOWED: Self = Self.LONG + 285
    comptime MAX_AGE_CONN: Self = Self.LONG + 288
    comptime SSL_CERT_BLOB: Self = Self.BLOB + 291
    comptime SSL_KEY_BLOB: Self = Self.BLOB + 292
    comptime PROXY_SSL_CERT_BLOB: Self = Self.BLOB + 293
    comptime PROXY_SSL_KEY_BLOB: Self = Self.BLOB + 294
    comptime ISSUER_CERT_BLOB: Self = Self.BLOB + 295
    comptime PROXY_ISSUER_CERT: Self = Self.OBJECT_POINT + 296
    comptime PROXY_ISSUER_CERT_BLOB: Self = Self.BLOB + 297
    comptime AWS_SIGV4: Self = Self.OBJECT_POINT + 305
    comptime DOH_SSL_VERIFY_PEER: Self = Self.LONG + 306
    comptime DOH_SSL_VERIFY_HOST: Self = Self.LONG + 307
    comptime DOH_SSL_VERIFY_STATUS: Self = Self.LONG + 308
    comptime CAINFO_BLOB: Self = Self.BLOB + 309
    comptime PROXY_CAINFO_BLOB: Self = Self.BLOB + 310
    comptime SSH_HOST_PUBLIC_KEY_SHA256: Self = Self.OBJECT_POINT + 311
    comptime PREREQ_FUNCTION: Self = Self.FUNCTION_POINT + 312
    comptime PREREQ_DATA: Self = Self.OBJECT_POINT + 313
    comptime MAX_LIFETIME_CONN: Self = Self.LONG + 314
    comptime MIME_OPTIONS: Self = Self.LONG + 315
    comptime SSH_HOST_KEY_FUNCTION: Self = Self.FUNCTION_POINT + 316
    comptime SSH_HOST_KEY_DATA: Self = Self.OBJECT_POINT + 317
    comptime PROTOCOLS_STR: Self = Self.OBJECT_POINT + 318
    comptime REDIR_PROTOCOLS_STR: Self = Self.OBJECT_POINT + 319
    comptime WS_OPTIONS: Self = Self.LONG + 320
    comptime CA_CACHE_TIMEOUT: Self = Self.LONG + 321
    comptime QUICK_EXIT: Self = Self.LONG + 322
    comptime HAPROXY_CLIENT_IP: Self = Self.OBJECT_POINT + 323
    comptime SERVER_RESPONSE_TIMEOUT_MS: Self = Self.LONG + 324
    comptime ECH: Self = Self.OBJECT_POINT + 325
    comptime TCP_KEEPCNT: Self = Self.LONG + 326
    comptime UPLOAD_FLAGS: Self = Self.LONG + 327
    comptime SSL_SIGNATURE_ALGORITHMS: Self = Self.OBJECT_POINT + 328


    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    @implicit
    fn __init__(out self, value: c_int):
        self.value = value


# Info options (commonly used ones)
@register_passable("trivial")
struct Info(Copyable, Movable):
    """CURLINFO options for retrieving information from a CURL handle."""

    var value: c_int

    comptime STRING = 0x100000
    comptime LONG = 0x200000
    comptime DOUBLE = 0x300000
    comptime SLIST = 0x400000
    comptime PTR = 0x400000
    comptime SOCKET = 0x500000
    comptime OFF_T = 0x600000
    comptime MASK = 0x0FFFFF
    comptime TYPE_MASK = 0xF00000

    comptime EFFECTIVE_URL: Self = Self.STRING + 1
    """[CURLINFO_EFFECTIVE_URL] Get the last used effective URL."""
    comptime RESPONSE_CODE: Self = Self.LONG + 2
    """[CURLINFO_RESPONSE_CODE] Get the last received response code."""
    comptime TOTAL_TIME: Self = Self.DOUBLE + 3
    """[CURLINFO_TOTAL_TIME] Get total time of previous transfer."""
    comptime NAME_LOOKUP_TIME: Self = Self.DOUBLE + 4
    """[CURLINFO_NAME_LOOKUP_TIME] Get time from start until name resolving completed."""
    comptime CONNECT_TIME: Self = Self.DOUBLE + 5
    """[CURLINFO_CONNECT_TIME] Get time from start until connect to remote host completed."""
    comptime PRE_TRANSFER_TIME: Self = Self.DOUBLE + 6
    """[CURLINFO_PRETRANSFER_TIME] Get time from start until file transfer is just about to begin."""
    comptime SIZE_UPLOAD_T: Self = Self.OFF_T + 7
    """[CURLINFO_SIZE_UPLOAD_T] Get number of bytes uploaded."""
    comptime SIZE_DOWNLOAD_T: Self = Self.OFF_T + 8
    """[CURLINFO_SIZE_DOWNLOAD_T] Get number of bytes downloaded."""
    comptime SPEED_DOWNLOAD_T: Self = Self.OFF_T + 9
    """[CURLINFO_SPEED_DOWNLOAD_T] Get average download speed in number of bytes per second."""
    comptime SPEED_UPLOAD_T: Self = Self.OFF_T + 10
    """[CURLINFO_SPEED_UPLOAD_T] Get average upload speed in number of bytes per second."""
    comptime HEADER_SIZE: Self = Self.LONG + 11
    """[CURLINFO_HEADER_SIZE] Get number of bytes of all headers received."""
    comptime REQUEST_SIZE: Self = Self.LONG + 12
    """[CURLINFO_REQUEST_SIZE] Get number of bytes sent in the issued HTTP requests."""
    comptime SSL_VERIFY_RESULT: Self = Self.LONG + 13
    """[CURLINFO_SSL_VERIFY_RESULT] Get certificate verification result."""
    comptime FILE_TIME: Self = Self.LONG + 14
    """[CURLINFO_FILE_TIME] Get remote time of the retrieved document."""
    comptime CONTENT_LENGTH_DOWNLOAD_T: Self = Self.OFF_T + 15
    """[CURLINFO_CONTENT_LENGTH_DOWNLOAD_T] Get content length from the Content-Length header."""
    comptime CONTENT_LENGTH_UPLOAD_T: Self = Self.OFF_T + 16
    """[CURLINFO_CONTENT_LENGTH_UPLOAD_T] Get upload size."""
    comptime START_TRANSFER_TIME: Self = Self.DOUBLE + 17
    """[CURLINFO_STARTTRANSFER_TIME] Get time from start until first byte is received by libmojo_curl."""
    comptime CONTENT_TYPE: Self = Self.STRING + 18
    """[CURLINFO_CONTENT_TYPE] Get content type from the Content-Type: header."""
    comptime REDIRECT_TIME: Self = Self.DOUBLE + 19
    """[CURLINFO_REDIRECT_TIME] Get time for all redirection steps before final transaction started."""
    comptime REDIRECT_COUNT: Self = Self.LONG + 20
    """[CURLINFO_REDIRECT_COUNT] Get total number of redirects that were followed."""
    comptime PRIVATE: Self = Self.STRING + 21
    """[CURLINFO_PRIVATE] Get user's private data pointer."""
    comptime HTTP_CONNECT_CODE: Self = Self.LONG + 22
    """[CURLINFO_HTTP_CONNECTCODE] Get last proxy CONNECT response code."""
    comptime HTTP_AUTH_AVAIL: Self = Self.LONG + 23
    """[CURLINFO_HTTPAUTH_AVAIL] Get available HTTP authentication methods."""
    comptime PROXY_AUTH_AVAIL: Self = Self.LONG + 24
    """[CURLINFO_PROXYAUTH_AVAIL] Get available HTTP proxy authentication methods."""
    comptime OS_ERRNO: Self = Self.LONG + 25
    """[CURLINFO_OS_ERRNO] Get the errno from the last failure to connect."""
    comptime NUM_CONNECTS: Self = Self.LONG + 26
    """[CURLINFO_NUM_CONNECTS] Get number of new successful connections used for previous transfer."""
    comptime SSL_ENGINES: Self = Self.SLIST + 27
    """[CURLINFO_SSL_ENGINES] Get a list of OpenSSL crypto engines."""
    comptime COOKIE_LIST: Self = Self.SLIST + 28
    """[CURLINFO_COOKIELIST] Get list of all known cookies."""
    comptime FTP_ENTRY_PATH: Self = Self.STRING + 30
    """[CURLINFO_FTP_ENTRY_PATH] Get the entry path after logging in to an FTP server."""
    comptime REDIRECT_URL: Self = Self.STRING + 31
    """[CURLINFO_REDIRECT_URL] Get URL a redirect would take you to, had you enabled redirects."""
    comptime PRIMARY_IP: Self = Self.STRING + 32
    """[CURLINFO_PRIMARY_IP] Get destination IP address of the last connection."""
    comptime APP_CONNECT_TIME: Self = Self.DOUBLE + 33
    """[CURLINFO_APPCONNECT_TIME] Get time from start until SSL connect/handshake completed."""
    comptime CERTINFO: Self = Self.SLIST + 34
    """[CURLINFO_CERTINFO] Get certificate chain."""
    comptime CONDITION_UNMET: Self = Self.LONG + 35
    """[CURLINFO_CONDITION_UNMET] Get whether or not a time conditional was met or 304 HTTP response."""
    comptime RTSP_SESSION_ID: Self = Self.STRING + 36
    """[CURLINFO_RTSP_SESSION_ID] Get RTSP session ID."""
    comptime RTSP_CLIENT_CSEQ: Self = Self.LONG + 37
    """[CURLINFO_RTSP_CLIENT_CSEQ] Get the RTSP client CSeq that is expected next."""
    comptime RTSP_SERVER_CSEQ: Self = Self.LONG + 38
    """[CURLINFO_RTSP_SERVER_CSEQ] Get the RTSP server CSeq that is expected next."""
    comptime RTSP_CSEQ_RECV: Self = Self.LONG + 39
    """[CURLINFO_RTSP_CSEQ_RECV] Get RTSP CSeq last received."""
    comptime PRIMARY_PORT: Self = Self.LONG + 40
    """[CURLINFO_PRIMARY_PORT] Get destination port of the last connection."""
    comptime LOCAL_IP: Self = Self.STRING + 41
    """[CURLINFO_LOCAL_IP] Get source IP address of the last connection."""
    comptime LOCAL_PORT: Self = Self.LONG + 42
    """[CURLINFO_LOCAL_PORT] Get source port number of the last connection."""
    comptime ACTIVE_SOCKET: Self = Self.SOCKET + 44
    """[CURLINFO_ACTIVESOCKET] Get the session's active socket."""
    comptime TLS_SSL_PTR: Self = Self.PTR + 45
    """[CURLINFO_TLS_SSL_PTR] Get TLS session info that can be used for further processing."""
    comptime HTTP_VERSION: Self = Self.LONG + 46
    """[CURLINFO_HTTP_VERSION] Get the http version used in the connection."""
    comptime PROXY_SSL_VERIFYRESULT: Self = Self.LONG + 47
    """[CURLINFO_PROXY_SSL_VERIFYRESULT] Get proxy certificate verification result."""
    comptime SCHEME: Self = Self.STRING + 49
    """[CURLINFO_SCHEME] Get the scheme used for the connection."""
    comptime TOTAL_TIME_T: Self = Self.OFF_T + 50
    """[CURLINFO_TOTAL_TIME_T] Get total time of previous transfer in microseconds."""
    comptime NAMELOOKUP_TIME_T: Self = Self.OFF_T + 51
    """[CURLINFO_NAMELOOKUP_TIME_T] Get time from start until name resolving completed in microseconds."""
    comptime CONNECT_TIME_T: Self = Self.OFF_T + 52
    """[CURLINFO_CONNECT_TIME_T] Get time from start until connect to remote host completed in microseconds."""
    comptime PRETRANSFER_TIME_T: Self = Self.OFF_T + 53
    """[CURLINFO_PRETRANSFER_TIME_T] Get time from start until file transfer is just about to begin in microseconds."""
    comptime STARTTRANSFER_TIME_T: Self = Self.OFF_T + 54
    """[CURLINFO_STARTTRANSFER_TIME_T] Get time from start until first byte is received by libcurl in microseconds."""
    comptime REDIRECT_TIME_T: Self = Self.OFF_T + 55
    """[CURLINFO_REDIRECT_TIME_T] Get time for all redirection steps before final transaction started in microseconds."""
    comptime APPCONNECT_TIME_T: Self = Self.OFF_T + 56
    """[CURLINFO_APPCONNECT_TIME_T] Get time from start until SSL connect/handshake completed in microseconds."""
    comptime RETRY_AFTER: Self = Self.OFF_T + 57
    """[CURLINFO_RETRY_AFTER] Get the value from the Retry-After header."""
    comptime EFFECTIVE_METHOD: Self = Self.STRING + 58
    """[CURLINFO_EFFECTIVE_METHOD] Get last used HTTP method."""
    comptime PROXY_ERROR: Self = Self.LONG + 59
    """[CURLINFO_PROXY_ERROR] Get detailed proxy error."""
    comptime REFERER: Self = Self.STRING + 60
    """[CURLINFO_REFERER] Get referrer header."""
    comptime CAINFO: Self = Self.STRING + 61
    """[CURLINFO_CAINFO] Get the default value for CURLOPT_CAINFO."""
    comptime CAPATH: Self = Self.STRING + 62
    """[CURLINFO_CAPATH] Get the default value for CURLOPT_CAPATH."""
    comptime XFER_ID: Self = Self.OFF_T + 63
    """[CURLINFO_XFER_ID] Get the ID of the transfer."""
    comptime CONN_ID: Self = Self.OFF_T + 64
    """[CURLINFO_CONN_ID] Get the ID of the last connection used by the transfer."""
    comptime QUEUE_TIME_T: Self = Self.OFF_T + 65
    """[CURLINFO_QUEUE_TIME_T] Get the time the transfer was held in a waiting queue before it could start in microseconds."""
    comptime USED_PROXY: Self = Self.LONG + 66
    """[CURLINFO_USED_PROXY] Get whether the proxy was used."""
    comptime POSTTRANSFER_TIME_T: Self = Self.OFF_T + 67
    """[CURLINFO_POSTTRANSFER_TIME_T] Get the time from start until the last byte is sent by libcurl in microseconds."""
    comptime EARLYDATA_SENT_T: Self = Self.OFF_T + 68
    """[CURLINFO_EARLYDATA_SENT_T] Get amount of TLS early data sent in number of bytes."""
    comptime HTTPAUTH_USED: Self = Self.LONG + 69
    """[CURLINFO_HTTPAUTH_USED] Get used HTTP authentication method."""
    comptime PROXYAUTH_USED: Self = Self.LONG + 70
    """[CURLINFO_PROXYAUTH_USED] Get used HTTP proxy authentication methods."""
    comptime LASTONE: Self = 70
    """Marker for the last valid CURLINFO option."""

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    @implicit
    fn __init__(out self, value: Int32):
        self.value = value


# HTTP version options
@fieldwise_init
@register_passable("trivial")
struct HTTPVersion(Copyable, Movable):
    """CURL HTTP version options for setting HTTP versions."""

    var value: c_int
    comptime NONE: Self = 0
    comptime V1_0: Self = 1
    comptime V1_1: Self = 2
    comptime V2_0: Self = 3
    comptime V2_TLS: Self = 4
    comptime V2_PRIOR_KNOWLEDGE: Self = 5
    comptime V3: Self = 30

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


# SSL version options
@fieldwise_init
@register_passable("trivial")
struct SSLVersion(Copyable, Movable):
    """CURL SSL version options for setting SSL/TLS versions."""

    var value: c_int
    comptime DEFAULT: Self = 0
    comptime TLSv1: Self = 1
    comptime SSLv2: Self = 2
    comptime SSLv3: Self = 3
    comptime TLSv1_0: Self = 4
    comptime TLSv1_1: Self = 5
    comptime TLSv1_2: Self = 6
    comptime TLSv1_3: Self = 7

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


@fieldwise_init
struct curl_version_info_data:
    """Version information structure returned by curl_version_info."""

    var age: c_int
    var version: ImmutExternalPointer[c_char]
    var version_num: c_uint
    var host: ImmutExternalPointer[c_char]
    var features: c_int
    var ssl_version: ImmutExternalPointer[c_char]
    var ssl_version_num: c_long
    var libz_version: ImmutExternalPointer[c_char]
    var protocols: ImmutExternalPointer[ImmutExternalPointer[c_char]]


struct curl_ssl_backend:
    """CURL SSL backend information structure.

    This struct represents information about a specific SSL backend used by mojo_curl.
    """

    var value: Int

    comptime NONE: Self = 0
    comptime OPEN_SSL: Self = 1
    comptime AWS_LC: Self = 1
    comptime BORING_SSL: Self = 1
    comptime LIBRE_SSL: Self = 1
    comptime GNU_TLS: Self = 2
    comptime NSS: Self = 3
    comptime GS_KIT: Self = 5
    comptime POLAR_SSL: Self = 6
    comptime WOLF_SSL: Self = 7
    comptime CYA_SSL: Self = 7
    comptime S_CHANNEL: Self = 8
    comptime SECURE_TRANSPORT: Self = 9
    comptime DARWIN_SSL: Self = 9
    comptime AX_TLS: Self = 10
    comptime MBED_TLS: Self = 11
    comptime MESALINK: Self = 12
    comptime BEAR_SSL: Self = 13
    comptime RUSTLS: Self = 14

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


comptime CURLFOLLOW_ALL: c_long = 1
"""Bits for the FOLLOWLOCATION option."""

comptime CURLFOLLOW_OBEYCODE: c_long = 2
"""Do not use the custom method in the follow-up request if the HTTP code instructs so (301, 302, 303)."""

comptime CURLFOLLOW_FIRSTONLY: c_long = 3
"""Only use the custom method in the first request, always reset in the next."""


struct curl_httppost:
    var next: MutExternalPointer[curl_httppost]
    """Next entry in the list."""
    var name: MutExternalPointer[c_char]
    """Pointer to allocated name."""
    var namelength: c_long
    """Length of name length."""
    var contents: MutExternalPointer[c_char]
    """Pointer to allocated data contents."""
    var contents_length: c_long
    """Length of contents field, see also CURL_HTTPPOST_LARGE."""
    var buffer: MutExternalPointer[c_char]
    """Pointer to allocated buffer contents."""
    var bufferlength: c_long
    """Length of buffer field."""
    var content_type: MutExternalPointer[c_char]
    """Content-Type."""
    var content_header: MutExternalPointer[curl_slist]
    """List of extra headers for this form."""
    var more: MutExternalPointer[curl_httppost]
    """If one field name has more than one file, this link should link to following files."""
    var flags: c_long
    """As defined below."""
    var show_file_name: MutExternalPointer[c_char]
    """The filename to show. If not set, the actual filename will be used (if this is a file part)."""
    var user_ptr: MutExternalOpaquePointer
    """Custom user pointer used for HTTPPOST_CALLBACK posts."""
    var contentlen: curl_off_t
    """Alternative length of contents field. Used if CURL_HTTPPOST_LARGE is set. Added in 7.46.0."""


comptime CURL_HTTPPOST_FILENAME = (1 << 0)
"""Specified content is a filename."""
comptime CURL_HTTPPOST_READFILE = (1 << 1)
"""Specified content is a filename."""
comptime CURL_HTTPPOST_PTRNAME = (1 << 2)
"""Name is only stored pointer do not free in formfree."""
comptime CURL_HTTPPOST_PTRCONTENTS = (1 << 3)
"""Contents is only stored pointer do not free in formfree."""
comptime CURL_HTTPPOST_BUFFER = (1 << 4)
"""Upload file from buffer."""
comptime CURL_HTTPPOST_PTRBUFFER = (1 << 5)
"""Upload file from pointer contents."""
comptime CURL_HTTPPOST_CALLBACK = (1 << 6)
"""Upload file contents by using the regular read callback to get the data and
   pass the given pointer as custom pointer."""
comptime CURL_HTTPPOST_LARGE = (1 << 7)
"""Use size in 'contentlen', added in 7.46.0."""


comptime CURL_MAX_READ_SIZE = (10 * 1024 * 1024)
"""The maximum receive buffer size configurable via BUFFERSIZE."""

comptime CURL_MAX_WRITE_SIZE = (16 * 1024)
"""Tests have proven that 20K is a bad buffer size for uploads on Windows,
while 16K for some odd reason performed a lot better. We do the ifndef
check to allow this value to easier be changed at build time for those
who feel adventurous. The practical minimum is about 400 bytes since
libcurl uses a buffer of this size as a scratch area (unrelated to
network send operations)."""


comptime CURL_MAX_HTTP_HEADER = (100 * 1024)
"""The only reason to have a max limit for this is to avoid the risk of a bad
server feeding libcurl with a never-ending header that will cause reallocs
infinitely."""


comptime CURL_WRITEFUNC_PAUSE = 0x10000001
"""This is a magic return code for the write callback that, when returned,
   will signal libcurl to pause receiving on the current transfer."""


comptime CURL_WRITEFUNC_ERROR = 0xFFFFFFFF
"""This is a magic return code for the write callback that, when returned,
   will signal an error from the callback."""


comptime curl_resolver_start_callback = fn (OpaquePointer, OpaquePointer, OpaquePointer) -> c_int
"""This callback will be called when a new resolver request is made."""

comptime CURL_GLOBAL_SSL = (1 << 0)
comptime CURL_GLOBAL_WIN32 = (1 << 1)
comptime CURL_GLOBAL_ALL = (CURL_GLOBAL_SSL | CURL_GLOBAL_WIN32)
comptime CURL_GLOBAL_NOTHING = 0
comptime CURL_GLOBAL_DEFAULT = CURL_GLOBAL_ALL
comptime CURL_GLOBAL_ACK_EINTR = (1 << 2)
