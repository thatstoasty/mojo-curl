from sys.ffi import c_char, c_int, c_long, c_size_t, c_uint

from memory import OpaquePointer, UnsafePointer


alias ExternalImmutPointer = UnsafeImmutPointer[origin = ImmutOrigin.external]
alias ExternalImmutOpaquePointer = ExternalImmutPointer[NoneType]
alias ExternalMutPointer = UnsafeMutPointer[origin = MutOrigin.external]
alias ExternalMutOpaquePointer = ExternalMutPointer[NoneType]

# Type aliases for curl
alias CURL = ExternalImmutOpaquePointer
# alias CURLcode = c_int
# alias CURLoption = c_int

# alias CURLMcode = c_int
# alias CURLM = OpaquePointer
# alias CURLMsg = OpaquePointer


struct curl_slist:
    """Singly linked list structure for curl string lists."""

    var data: ExternalMutPointer[c_char]
    var next: ExternalMutPointer[curl_slist]


alias curl_socket_t = c_int
alias CURL_SOCKET_BAD = -1

alias curl_off_t = c_long

# Callback function types
alias curl_write_callback = fn (
    ExternalImmutPointer[c_char], c_size_t, c_size_t, ExternalImmutOpaquePointer
) -> c_size_t
alias curl_read_callback = fn (ExternalImmutPointer[c_char], c_size_t, c_size_t, ExternalImmutOpaquePointer) -> c_size_t
alias curl_progress_callback = fn (ExternalImmutOpaquePointer, Float64, Float64, Float64, Float64) -> c_int
alias curl_debug_callback = fn (CURL, c_int, UnsafePointer[c_char], c_size_t, ExternalImmutOpaquePointer) -> c_int
alias curl_xferinfo_callback = fn (ExternalImmutOpaquePointer, curl_off_t, curl_off_t, curl_off_t, curl_off_t) -> c_int
"""This is the XFERINFOFUNCTION callback prototype. It was introduced 
in 7.32.0, avoids the use of floating point numbers and provides more
detailed information."""


struct curl_blob[origin: MutOrigin](Movable):
    """CURL blob struct for binary data transfer.

    This struct represents binary data that can be passed to curl,
    with control over whether curl should copy the data or use it directly.
    """

    var data: OpaqueMutPointer[origin]
    var len: c_size_t
    var flags: c_uint

    fn __init__(out self, data: OpaqueMutPointer[origin], len: c_size_t, flags: c_uint = CURL_BLOB_COPY):
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
alias CURL_BLOB_COPY = 1
alias CURL_BLOB_NOCOPY = 0


# Common CURLcode values
@register_passable("trivial")
struct Result(Copyable, EqualityComparable, Movable, Writable):
    var value: c_int
    alias OK: Self = 0
    alias UNSUPPORTED_PROTOCOL: Self = 1
    alias FAILED_INIT: Self = 2
    alias URL_MALFORMAT: Self = 3
    alias NOT_BUILT_IN: Self = 4
    alias COULDNT_RESOLVE_PROXY: Self = 5
    alias COULDNT_RESOLVE_HOST: Self = 6
    alias COULDNT_CONNECT: Self = 7
    alias WEIRD_SERVER_REPLY: Self = 8
    alias REMOTE_ACCESS_DENIED: Self = 9
    alias FTP_ACCEPT_FAILED: Self = 10
    alias FTP_WEIRD_PASS_REPLY: Self = 11
    alias FTP_ACCEPT_TIMEOUT: Self = 12
    alias FTP_WEIRD_PASV_REPLY: Self = 13
    alias FTP_WEIRD_227_FORMAT: Self = 14
    alias FTP_CANT_GET_HOST: Self = 15
    alias HTTP2: Self = 16
    alias FTP_COULDNT_SET_TYPE: Self = 17
    alias PARTIAL_FILE: Self = 18
    alias FTP_COULDNT_RETR_FILE: Self = 19
    alias QUOTE_ERROR: Self = 21
    alias HTTP_RETURNED_ERROR: Self = 22
    alias WRITE_ERROR: Self = 23
    alias UPLOAD_FAILED: Self = 25
    alias READ_ERROR: Self = 26
    alias OUT_OF_MEMORY: Self = 27
    alias OPERATION_TIMEDOUT: Self = 28
    alias FTP_PORT_FAILED: Self = 30
    alias FTP_COULDNT_USE_REST: Self = 31
    alias RANGE_ERROR: Self = 33
    alias HTTP_POST_ERROR: Self = 34
    alias SSL_CONNECT_ERROR: Self = 35
    alias BAD_DOWNLOAD_RESUME: Self = 36
    alias FILE_COULDNT_READ_FILE: Self = 37
    alias LDAP_CANNOT_BIND: Self = 38
    alias LDAP_SEARCH_FAILED: Self = 39
    alias FUNCTION_NOT_FOUND: Self = 41
    alias ABORTED_BY_CALLBACK: Self = 42
    alias BAD_FUNCTION_ARGUMENT: Self = 43
    alias INTERFACE_FAILED: Self = 45
    alias TOO_MANY_REDIRECTS: Self = 47
    alias UNKNOWN_OPTION: Self = 48
    alias GOT_NOTHING: Self = 52
    alias SSL_ENGINE_NOTFOUND: Self = 53
    alias SSL_ENGINE_SETFAILED: Self = 54
    alias SEND_ERROR: Self = 55
    alias RECV_ERROR: Self = 56
    alias SSL_CERT_PROBLEM: Self = 58
    alias SSL_CIPHER: Self = 59
    alias PEER_FAILED_VERIFICATION: Self = 60
    alias BAD_CONTENT_ENCODING: Self = 61
    alias FILESIZE_EXCEEDED: Self = 63
    alias USE_SSL_FAILED: Self = 64
    alias SEND_FAIL_REWIND: Self = 65
    alias SSL_ENGINE_INITFAILED: Self = 66
    alias LOGIN_DENIED: Self = 67
    alias TFTP_NOTFOUND: Self = 68
    alias TFTP_PERM: Self = 69
    alias REMOTE_DISK_FULL: Self = 70
    alias TFTP_ILLEGAL: Self = 71
    alias TFTP_UNKNOWN_ID: Self = 72
    alias REMOTE_FILE_EXISTS: Self = 73
    alias TFTP_NO_SUCH_USER: Self = 74
    alias SSL_CACERT_BAD_FILE: Self = 77
    alias REMOTE_FILE_NOT_FOUND: Self = 78
    alias SSH: Self = 79
    alias SSL_SHUTDOWN_FAILED: Self = 80
    alias AGAIN: Self = 81
    alias SSL_CRL_BADFILE: Self = 82
    alias SSL_ISSUER_ERROR: Self = 83
    alias FTP_PRET_FAILED: Self = 84
    alias RTSP_CSEQ_ERROR: Self = 85
    alias RTSP_SESSION_ERROR: Self = 86
    alias FTP_BAD_FILE_LIST: Self = 87
    alias CHUNK_FAILED: Self = 88
    alias NO_CONNECTION_AVAILABLE: Self = 89
    alias SSL_PINNED_PUBKEY_NOT_MATCH: Self = 90
    alias SSL_INVALID_CERT_STATUS: Self = 91
    alias HTTP2_STREAM: Self = 92
    alias RECURSIVE_API_CALL: Self = 93
    alias AUTH_ERROR: Self = 94
    alias HTTP3: Self = 95
    alias QUIC_CONNECT_ERROR: Self = 96
    alias PROXY: Self = 97
    alias SSL_CLIENTCERT: Self = 98
    alias UNRECOVERABLE_POLL: Self = 99
    alias SSL_PEER_CERTIFICATE: Self = 60  # Alias for PEER_FAILED_VERIFICATION

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
struct OptionType(Copyable, Movable):
    var value: c_int

    alias LONG: Self = 0
    alias OBJECT_POINT: Self = 10_000
    alias FUNCTION_POINT: Self = 20_000
    alias OFF_T: Self = 30_000
    alias BLOB: Self = 40_000
    alias VALUES: Self = Self.LONG.value

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    @implicit
    fn __init__(out self, value: c_int):
        self.value = value


# CURLOPT options (commonly used ones)
@register_passable("trivial")
struct Option(Copyable, Movable):
    var value: c_int

    alias FILE: Self = OptionType.OBJECT_POINT.value + 1
    alias URL: Self = OptionType.OBJECT_POINT.value + 2
    alias PORT: Self = OptionType.LONG.value + 3
    alias PROXY: Self = OptionType.OBJECT_POINT.value + 4
    alias USER_PWD: Self = OptionType.OBJECT_POINT.value + 5
    alias PROXY_USER_PWD: Self = OptionType.OBJECT_POINT.value + 6
    alias RANGE: Self = OptionType.OBJECT_POINT.value + 7
    alias IN_FILE: Self = OptionType.OBJECT_POINT.value + 9
    alias ERROR_BUFFER: Self = OptionType.OBJECT_POINT.value + 10
    alias WRITE_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 11
    alias READ_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 12
    alias TIMEOUT: Self = OptionType.LONG.value + 13
    alias IN_FILE_SIZE: Self = OptionType.LONG.value + 14
    alias POST_FIELDS: Self = OptionType.OBJECT_POINT.value + 15
    alias REFERER: Self = OptionType.OBJECT_POINT.value + 16
    alias FTP_PORT: Self = OptionType.OBJECT_POINT.value + 17
    alias USERAGENT: Self = OptionType.OBJECT_POINT.value + 18
    alias LOW_SPEED_LIMIT: Self = OptionType.LONG.value + 19
    alias LOW_SPEED_TIME: Self = OptionType.LONG.value + 20
    alias RESUME_FROM: Self = OptionType.LONG.value + 21
    alias COOKIE: Self = OptionType.OBJECT_POINT.value + 22
    alias HTTP_HEADER: Self = OptionType.OBJECT_POINT.value + 23
    alias HTTP_POST: Self = OptionType.OBJECT_POINT.value + 24
    alias SSL_CERT: Self = OptionType.OBJECT_POINT.value + 25
    alias KEY_PASSWD: Self = OptionType.OBJECT_POINT.value + 26
    alias CRLF: Self = OptionType.LONG.value + 27
    alias QUOTE: Self = OptionType.OBJECT_POINT.value + 28
    alias WRITE_HEADER: Self = OptionType.OBJECT_POINT.value + 29
    alias COOKIE_FILE: Self = OptionType.OBJECT_POINT.value + 31
    alias SSL_VERSION: Self = OptionType.LONG.value + 32
    alias TIME_CONDITION: Self = OptionType.LONG.value + 33
    alias TIME_VALUE: Self = OptionType.LONG.value + 34
    alias CUSTOM_REQUEST: Self = OptionType.OBJECT_POINT.value + 36
    alias STDERR: Self = OptionType.OBJECT_POINT.value + 37
    alias POST_QUOTE: Self = OptionType.OBJECT_POINT.value + 39
    alias VERBOSE: Self = OptionType.LONG.value + 41
    alias HEADER: Self = OptionType.LONG.value + 42
    alias NO_PROGRESS: Self = OptionType.LONG.value + 43
    alias NO_BODY: Self = OptionType.LONG.value + 44
    alias FAIL_ON_ERROR: Self = OptionType.LONG.value + 45
    alias UPLOAD: Self = OptionType.LONG.value + 46
    alias POST: Self = OptionType.LONG.value + 47
    alias DIR_LIST_ONLY: Self = OptionType.LONG.value + 48
    alias APPEND: Self = OptionType.LONG.value + 50
    alias NETRC: Self = OptionType.LONG.value + 51
    alias FOLLOW_LOCATION: Self = OptionType.LONG.value + 52
    alias TRANSFER_TEXT: Self = OptionType.LONG.value + 53
    alias PUT: Self = OptionType.LONG.value + 54
    alias PROGRESS_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 56
    alias PROGRESS_DATA: Self = OptionType.OBJECT_POINT.value + 57
    alias AUTO_REFERER: Self = OptionType.LONG.value + 58
    alias PROXY_PORT: Self = OptionType.LONG.value + 59
    alias POST_FIELD_SIZE: Self = OptionType.LONG.value + 60
    alias HTTP_PROXY_TUNNEL: Self = OptionType.LONG.value + 61
    alias INTERFACE: Self = OptionType.OBJECT_POINT.value + 62
    alias KRB_LEVEL: Self = OptionType.OBJECT_POINT.value + 63
    alias SSL_VERIFYPEER: Self = OptionType.LONG.value + 64
    alias CAINFO: Self = OptionType.OBJECT_POINT.value + 65
    alias MAXREDIRS: Self = OptionType.LONG.value + 68
    alias FILE_TIME: Self = OptionType.LONG.value + 69
    alias TELNET_OPTIONS: Self = OptionType.OBJECT_POINT.value + 70
    alias MAX_CONNECTS: Self = OptionType.LONG.value + 71
    alias FRESH_CONNECT: Self = OptionType.LONG.value + 74
    alias FORBID_REUSE: Self = OptionType.LONG.value + 75
    alias RANDOM_FILE: Self = OptionType.OBJECT_POINT.value + 76
    alias EGD_SOCKET: Self = OptionType.OBJECT_POINT.value + 77
    alias CONNECT_TIMEOUT: Self = OptionType.LONG.value + 78
    alias HEADER_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 79
    alias HTTPGET: Self = OptionType.LONG.value + 80
    alias SSL_VERIFY_HOST: Self = OptionType.LONG.value + 81
    alias COOKIEJAR: Self = OptionType.OBJECT_POINT.value + 82
    alias SSL_CIPHER_LIST: Self = OptionType.OBJECT_POINT.value + 83
    alias HTTP_VERSION: Self = OptionType.LONG.value + 84
    alias FTP_USE_EPSV: Self = OptionType.LONG.value + 85
    alias SSL_CERT_TYPE: Self = OptionType.OBJECT_POINT.value + 86
    alias SSL_KEY: Self = OptionType.OBJECT_POINT.value + 87
    alias SSL_KEY_TYPE: Self = OptionType.OBJECT_POINT.value + 88
    alias SSL_ENGINE: Self = OptionType.OBJECT_POINT.value + 89
    alias SSL_ENGINE_DEFAULT: Self = OptionType.LONG.value + 90
    alias DNS_USE_GLOBAL_CACHE: Self = OptionType.LONG.value + 91
    alias DNS_CACHE_TIMEOUT: Self = OptionType.LONG.value + 92
    alias PREQUOTE: Self = OptionType.OBJECT_POINT.value + 93
    alias DEBUG_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 94
    alias DEBUG_DATA: Self = OptionType.OBJECT_POINT.value + 95
    alias COOKIE_SESSION: Self = OptionType.LONG.value + 96
    alias CAPATH: Self = OptionType.OBJECT_POINT.value + 97
    alias BUFFER_SIZE: Self = OptionType.LONG.value + 98
    alias NO_SIGNAL: Self = OptionType.LONG.value + 99
    alias SHARE: Self = OptionType.OBJECT_POINT.value + 100
    alias PROXY_TYPE: Self = OptionType.LONG.value + 101
    alias ACCEPT_ENCODING: Self = OptionType.OBJECT_POINT.value + 102
    alias PRIVATE: Self = OptionType.OBJECT_POINT.value + 103
    alias HTTP200_ALIASES: Self = OptionType.OBJECT_POINT.value + 104
    alias UNRESTRICTED_AUTH: Self = OptionType.LONG.value + 105
    alias FTP_USE_EPRT: Self = OptionType.LONG.value + 106
    alias HTTP_AUTH: Self = OptionType.LONG.value + 107
    alias SSL_CTX_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 108
    alias SSL_CTX_DATA: Self = OptionType.OBJECT_POINT.value + 109
    alias FTP_CREATE_MISSING_DIRS: Self = OptionType.LONG.value + 110
    alias PROXY_AUTH: Self = OptionType.LONG.value + 111
    alias FTP_RESPONSE_TIMEOUT: Self = OptionType.LONG.value + 112
    alias IP_RESOLVE: Self = OptionType.LONG.value + 113
    alias MAX_FILE_SIZE: Self = OptionType.LONG.value + 114
    alias IN_FILE_SIZE_LARGE: Self = OptionType.OFF_T.value + 115
    alias RESUME_FROM_LARGE: Self = OptionType.OFF_T.value + 116
    alias MAX_FILE_SIZE_LARGE: Self = OptionType.OFF_T.value + 117
    alias NETRC_FILE: Self = OptionType.OBJECT_POINT.value + 118
    alias USE_SSL: Self = OptionType.LONG.value + 119
    alias POST_FIELD_SIZE_LARGE: Self = OptionType.OFF_T.value + 120
    alias TCP_NODELAY: Self = OptionType.LONG.value + 121
    alias FTP_SSL_AUTH: Self = OptionType.LONG.value + 129
    alias IOCTL_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 130
    alias IOCTL_DATA: Self = OptionType.OBJECT_POINT.value + 131
    alias FTP_ACCOUNT: Self = OptionType.OBJECT_POINT.value + 134
    alias COOKIE_LIST: Self = OptionType.OBJECT_POINT.value + 135
    alias IGNORE_CONTENT_LENGTH: Self = OptionType.LONG.value + 136
    alias FTP_SKIP_PASV_IP: Self = OptionType.LONG.value + 137
    alias FTP_FILE_METHOD: Self = OptionType.LONG.value + 138
    alias LOCAL_PORT: Self = OptionType.LONG.value + 139
    alias LOCAL_PORT_RANGE: Self = OptionType.LONG.value + 140
    alias CONNECT_ONLY: Self = OptionType.LONG.value + 141
    alias CONV_FROM_NETWORK_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 142
    alias CONV_TO_NETWORK_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 143
    alias CONV_FROM_UTF8_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 144
    alias MAX_SEND_SPEED_LARGE: Self = OptionType.OFF_T.value + 145
    alias MAX_RECV_SPEED_LARGE: Self = OptionType.OFF_T.value + 146
    alias FTP_ALTERNATIVE_TO_USER: Self = OptionType.OBJECT_POINT.value + 147
    alias SOCKOPT_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 148
    alias SOCKOPT_DATA: Self = OptionType.OBJECT_POINT.value + 149
    alias SSL_SESSIONID_CACHE: Self = OptionType.LONG.value + 150
    alias SSH_AUTH_TYPES: Self = OptionType.LONG.value + 151
    alias SSH_PUBLIC_KEYFILE: Self = OptionType.OBJECT_POINT.value + 152
    alias SSH_PRIVATE_KEYFILE: Self = OptionType.OBJECT_POINT.value + 153
    alias FTP_SSL_CCC: Self = OptionType.LONG.value + 154
    alias TIMEOUT_MS: Self = OptionType.LONG.value + 155
    alias CONNECT_TIMEOUT_MS: Self = OptionType.LONG.value + 156
    alias HTTP_TRANSFER_DECODING: Self = OptionType.LONG.value + 157
    alias HTTP_CONTENT_DECODING: Self = OptionType.LONG.value + 158
    alias NEW_FILE_PERMS: Self = OptionType.LONG.value + 159
    alias NEW_DIRECTORY_PERMS: Self = OptionType.LONG.value + 160
    alias POST_REDIR: Self = OptionType.LONG.value + 161
    alias SSH_HOST_PUBLIC_KEY_MD5: Self = OptionType.OBJECT_POINT.value + 162
    alias OPEN_SOCKET_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 163
    alias OPEN_SOCKET_DATA: Self = OptionType.OBJECT_POINT.value + 164
    alias COPY_POST_FIELDS: Self = OptionType.OBJECT_POINT.value + 165
    alias PROXY_TRANSFER_MODE: Self = OptionType.LONG.value + 166
    alias SEEK_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 167
    alias SEEK_DATA: Self = OptionType.OBJECT_POINT.value + 168
    alias CRL_FILE: Self = OptionType.OBJECT_POINT.value + 169
    alias ISSUER_CERT: Self = OptionType.OBJECT_POINT.value + 170
    alias ADDRESS_SCOPE: Self = OptionType.LONG.value + 171
    alias CERT_INFO: Self = OptionType.LONG.value + 172
    alias USERNAME: Self = OptionType.OBJECT_POINT.value + 173
    alias PASSWORD: Self = OptionType.OBJECT_POINT.value + 174
    alias PROXY_USERNAME: Self = OptionType.OBJECT_POINT.value + 175
    alias PROXY_PASSWORD: Self = OptionType.OBJECT_POINT.value + 176
    alias NO_PROXY: Self = OptionType.OBJECT_POINT.value + 177
    alias TFTP_BLK_SIZE: Self = OptionType.LONG.value + 178
    alias SOCKS5_GSSAPI_SERVICE: Self = OptionType.OBJECT_POINT.value + 179
    alias SOCKS5_GSSAPI_NEC: Self = OptionType.LONG.value + 180
    alias PROTOCOLS: Self = OptionType.LONG.value + 181
    alias REDIR_PROTOCOLS: Self = OptionType.LONG.value + 182
    alias SSH_KNOWNHOSTS: Self = OptionType.OBJECT_POINT.value + 183
    alias SSH_KEY_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 184
    alias SSH_KEY_DATA: Self = OptionType.OBJECT_POINT.value + 185
    alias MAIL_FROM: Self = OptionType.OBJECT_POINT.value + 186
    alias MAIL_RCPT: Self = OptionType.OBJECT_POINT.value + 187
    alias FTP_USE_PRET: Self = OptionType.LONG.value + 188
    alias RTSP_REQUEST: Self = OptionType.LONG.value + 189
    alias RTSP_SESSION_ID: Self = OptionType.OBJECT_POINT.value + 190
    alias RTSP_STREAM_URI: Self = OptionType.OBJECT_POINT.value + 191
    alias RTSP_TRANSPORT: Self = OptionType.OBJECT_POINT.value + 192
    alias RTSP_CLIENT_CSEQ: Self = OptionType.LONG.value + 193
    alias RTSP_SERVER_CSEQ: Self = OptionType.LONG.value + 194
    alias INTERLEAVE_DATA: Self = OptionType.OBJECT_POINT.value + 195
    alias INTERLEAVE_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 196
    alias WILDCARD_MATCH: Self = OptionType.LONG.value + 197
    alias CHUNK_BGN_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 198
    alias CHUNK_END_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 199
    alias FN_MATCH_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 200
    alias CHUNK_DATA: Self = OptionType.OBJECT_POINT.value + 201
    alias FN_MATCH_DATA: Self = OptionType.OBJECT_POINT.value + 202
    alias RESOLVE: Self = OptionType.OBJECT_POINT.value + 203
    alias TLS_AUTH_USERNAME: Self = OptionType.OBJECT_POINT.value + 204
    alias TLS_AUTH_PASSWORD: Self = OptionType.OBJECT_POINT.value + 205
    alias TLS_AUTH_TYPE: Self = OptionType.OBJECT_POINT.value + 206
    alias TRANSFER_ENCODING: Self = OptionType.LONG.value + 207
    alias CLOSE_SOCKET_FUNCTION: Self = OptionType.FUNCTION_POINT.value + 208
    alias CLOSE_SOCKET_DATA: Self = OptionType.OBJECT_POINT.value + 209
    alias GSSAPI_DELEGATION: Self = OptionType.LONG.value + 210
    alias DNS_SERVERS: Self = OptionType.OBJECT_POINT.value + 211
    alias TCP_KEEPALIVE: Self = OptionType.LONG.value + 213
    alias TCP_KEEPIDLE: Self = OptionType.LONG.value + 214
    alias TCP_KEEPINTVL: Self = OptionType.LONG.value + 215
    alias SSL_OPTIONS: Self = OptionType.LONG.value + 216
    alias EXPECT_100_TIMEOUT_MS: Self = OptionType.LONG.value + 227
    alias PINNED_PUBLIC_KEY: Self = OptionType.OBJECT_POINT.value + 230
    alias UNIX_SOCKET_PATH: Self = OptionType.OBJECT_POINT.value + 231
    alias PATH_AS_IS: Self = OptionType.LONG.value + 234
    alias PIPE_WAIT: Self = OptionType.LONG.value + 237
    alias CONNECT_TO: Self = OptionType.OBJECT_POINT.value + 243
    alias PROXY_CAINFO: Self = OptionType.OBJECT_POINT.value + 246
    alias PROXY_CAPATH: Self = OptionType.OBJECT_POINT.value + 247
    alias PROXY_SSL_VERIFYPEER: Self = OptionType.LONG.value + 248
    alias PROXY_SSL_VERIFYHOST: Self = OptionType.LONG.value + 249
    alias PROXY_SSL_VERSION: Self = OptionType.VALUES.value + 250
    alias PROXY_SSL_CERT: Self = OptionType.OBJECT_POINT.value + 254
    alias PROXY_SSL_CERT_TYPE: Self = OptionType.OBJECT_POINT.value + 255
    alias PROXY_SSL_KEY: Self = OptionType.OBJECT_POINT.value + 256
    alias PROXY_SSL_KEY_TYPE: Self = OptionType.OBJECT_POINT.value + 257
    alias PROXY_KEYPASSWD: Self = OptionType.OBJECT_POINT.value + 258
    alias PROXY_SSL_CIPHER_LIST: Self = OptionType.OBJECT_POINT.value + 259
    alias PROXY_CRL_FILE: Self = OptionType.OBJECT_POINT.value + 260
    alias PROXY_SSL_OPTIONS: Self = OptionType.LONG.value + 261
    alias ABSTRACT_UNIX_SOCKET: Self = OptionType.OBJECT_POINT.value + 264
    alias DOH_URL: Self = OptionType.OBJECT_POINT.value + 279
    alias UPLOAD_BUFFER_SIZE: Self = OptionType.LONG.value + 280
    alias HTTP09_ALLOWED: Self = OptionType.LONG.value + 285
    alias MAX_AGE_CONN: Self = OptionType.LONG.value + 288
    alias SSL_CERT_BLOB: Self = OptionType.BLOB.value + 291
    alias SSL_KEY_BLOB: Self = OptionType.BLOB.value + 292
    alias PROXY_SSL_CERT_BLOB: Self = OptionType.BLOB.value + 293
    alias PROXY_SSL_KEY_BLOB: Self = OptionType.BLOB.value + 294
    alias ISSUER_CERT_BLOB: Self = OptionType.BLOB.value + 295
    alias PROXY_ISSUER_CERT: Self = OptionType.OBJECT_POINT.value + 296
    alias PROXY_ISSUER_CERT_BLOB: Self = OptionType.BLOB.value + 297
    alias AWS_SIGV4: Self = OptionType.OBJECT_POINT.value + 305
    alias DOH_SSL_VERIFY_PEER: Self = OptionType.LONG.value + 306
    alias DOH_SSL_VERIFY_HOST: Self = OptionType.LONG.value + 307
    alias DOH_SSL_VERIFY_STATUS: Self = OptionType.LONG.value + 308
    alias CAINFO_BLOB: Self = OptionType.BLOB.value + 309
    alias PROXY_CAINFO_BLOB: Self = OptionType.BLOB.value + 310

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    @implicit
    fn __init__(out self, value: c_int):
        self.value = value


@fieldwise_init
@register_passable("trivial")
struct InfoType(Copyable, Movable):
    var value: c_int
    alias STRING: Self = 0x100000
    alias LONG: Self = 0x200000
    alias DOUBLE: Self = 0x300000
    alias SLIST: Self = 0x400000
    alias PTR: Self = 0x400000
    alias SOCKET: Self = 0x500000
    alias OFF_T: Self = 0x600000
    alias MASK: Self = 0x0FFFFF
    alias TYPE_MASK: Self = 0xF00000

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


# Info options (commonly used ones)
@register_passable("trivial")
struct Info(Copyable, Movable):
    """CURLINFO options for retrieving information from a CURL handle."""

    var value: c_int

    alias EFFECTIVE_URL: Self = InfoType.STRING.value + 1
    alias RESPONSE_CODE: Self = InfoType.LONG.value + 2
    alias TOTAL_TIME: Self = InfoType.DOUBLE.value + 3
    alias NAME_LOOKUP_TIME: Self = InfoType.DOUBLE.value + 4
    alias CONNECT_TIME: Self = InfoType.DOUBLE.value + 5
    alias PRE_TRANSFER_TIME: Self = InfoType.DOUBLE.value + 6
    alias SIZE_UPLOAD: Self = InfoType.DOUBLE.value + 7
    alias SIZE_DOWNLOAD: Self = InfoType.DOUBLE.value + 8
    alias SPEED_DOWNLOAD: Self = InfoType.DOUBLE.value + 9
    alias SPEED_UPLOAD: Self = InfoType.DOUBLE.value + 10
    alias HEADER_SIZE: Self = InfoType.LONG.value + 11
    alias REQUEST_SIZE: Self = InfoType.LONG.value + 12
    alias SSL_VERIFY_RESULT: Self = InfoType.LONG.value + 13
    alias FILE_TIME: Self = InfoType.LONG.value + 14
    alias CONTENT_LENGTH_DOWNLOAD: Self = InfoType.DOUBLE.value + 15
    alias CONTENT_LENGTH_UPLOAD: Self = InfoType.DOUBLE.value + 16
    alias START_TRANSFER_TIME: Self = InfoType.DOUBLE.value + 17
    alias CONTENT_TYPE: Self = InfoType.STRING.value + 18
    alias REDIRECT_TIME: Self = InfoType.DOUBLE.value + 19
    alias REDIRECT_COUNT: Self = InfoType.LONG.value + 20
    alias PRIVATE: Self = InfoType.STRING.value + 21
    alias HTTP_CONNECT_CODE: Self = InfoType.LONG.value + 22
    alias HTTP_AUTH_AVAIL: Self = InfoType.LONG.value + 23
    alias PROXY_AUTH_AVAIL: Self = InfoType.LONG.value + 24
    alias OS_ERRNO: Self = InfoType.LONG.value + 25
    alias NUM_CONNECTS: Self = InfoType.LONG.value + 26
    alias SSL_ENGINES: Self = InfoType.SLIST.value + 27
    alias COOKIE_LIST: Self = InfoType.SLIST.value + 28
    alias LAST_SOCKET: Self = InfoType.LONG.value + 29
    alias FTP_ENTRY_PATH: Self = InfoType.STRING.value + 30
    alias REDIRECT_URL: Self = InfoType.STRING.value + 31
    alias PRIMARY_IP: Self = InfoType.STRING.value + 32
    alias APP_CONNECT_TIME: Self = InfoType.DOUBLE.value + 33
    alias CERTINFO: Self = InfoType.SLIST.value + 34
    alias CONDITION_UNMET: Self = InfoType.LONG.value + 35
    alias RTSP_SESSION_ID: Self = InfoType.STRING.value + 36
    alias RTSP_CLIENT_CSEQ: Self = InfoType.LONG.value + 37
    alias RTSP_SERVER_CSEQ: Self = InfoType.LONG.value + 38
    alias RTSP_CSEQ_RECV: Self = InfoType.LONG.value + 39
    alias PRIMARY_PORT: Self = InfoType.LONG.value + 40
    alias LOCAL_IP: Self = InfoType.STRING.value + 41
    alias LOCAL_PORT: Self = InfoType.LONG.value + 42

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
    alias NONE: Self = 0
    alias V1_0: Self = 1
    alias V1_1: Self = 2
    alias V2_0: Self = 3
    alias V2_TLS: Self = 4
    alias V2_PRIOR_KNOWLEDGE: Self = 5
    alias V3: Self = 30

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


# SSL version options
@fieldwise_init
@register_passable("trivial")
struct SSLVersion(Copyable, Movable):
    """CURL SSL version options for setting SSL/TLS versions."""

    var value: c_int
    alias DEFAULT: Self = 0
    alias TLSv1: Self = 1
    alias SSLv2: Self = 2
    alias SSLv3: Self = 3
    alias TLSv1_0: Self = 4
    alias TLSv1_1: Self = 5
    alias TLSv1_2: Self = 6
    alias TLSv1_3: Self = 7

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


@fieldwise_init
struct curl_version_info_data:
    """Version information structure returned by curl_version_info."""

    var age: c_int
    var version: ExternalImmutPointer[c_char]
    var version_num: c_uint
    var host: ExternalImmutPointer[c_char]
    var features: c_int
    var ssl_version: ExternalImmutPointer[c_char]
    var ssl_version_num: c_long
    var libz_version: ExternalImmutPointer[c_char]
    var protocols: ExternalImmutPointer[ExternalImmutPointer[c_char]]


struct curl_ssl_backend:
    """CURL SSL backend information structure.

    This struct represents information about a specific SSL backend used by curl.
    """

    var value: Int

    alias NONE: Self = 0
    alias OPEN_SSL: Self = 1
    alias AWS_LC: Self = 1
    alias BORING_SSL: Self = 1
    alias LIBRE_SSL: Self = 1
    alias GNU_TLS: Self = 2
    alias NSS: Self = 3
    alias GS_KIT: Self = 5
    alias POLAR_SSL: Self = 6
    alias WOLF_SSL: Self = 7
    alias CYA_SSL: Self = 7
    alias S_CHANNEL: Self = 8
    alias SECURE_TRANSPORT: Self = 9
    alias DARWIN_SSL: Self = 9
    alias AX_TLS: Self = 10
    alias MBED_TLS: Self = 11
    alias MESALINK: Self = 12
    alias BEAR_SSL: Self = 13
    alias RUSTLS: Self = 14

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


alias CURLFOLLOW_ALL: c_long = 1
"""bits for the FOLLOWLOCATION option"""

alias CURLFOLLOW_OBEYCODE: c_long = 2
"""Do not use the custom method in the follow-up request if the HTTP code instructs so (301, 302, 303)."""

alias CURLFOLLOW_FIRSTONLY: c_long = 3
"""Only use the custom method in the first request, always reset in the next"""


struct curl_httppost:
    var next: ExternalMutPointer[curl_httppost]
    """Next entry in the list."""
    var name: ExternalMutPointer[c_char]
    """Pointer to allocated name."""
    var namelength: c_long
    """Length of name length."""
    var contents: ExternalMutPointer[c_char]
    """Pointer to allocated data contents."""
    var contents_length: c_long
    """Length of contents field, see also CURL_HTTPPOST_LARGE."""
    var buffer: ExternalMutPointer[c_char]
    """Pointer to allocated buffer contents."""
    var bufferlength: c_long
    """Length of buffer field."""
    var content_type: ExternalMutPointer[c_char]
    """Content-Type."""
    var content_header: ExternalMutPointer[curl_slist]
    """List of extra headers for this form."""
    var more: ExternalMutPointer[curl_httppost]
    """If one field name has more than one file, this link should link to following files."""
    var flags: c_long
    """As defined below."""
    var show_file_name: ExternalMutPointer[c_char]
    """The filename to show. If not set, the actual filename will be used (if this is a file part)."""
    var user_ptr: ExternalMutOpaquePointer
    """Custom user pointer used for HTTPPOST_CALLBACK posts."""
    var contentlen: curl_off_t
    """Alternative length of contents field. Used if CURL_HTTPPOST_LARGE is set. Added in 7.46.0."""


alias CURL_HTTPPOST_FILENAME = (1 << 0)
"""specified content is a filename."""
alias CURL_HTTPPOST_READFILE = (1 << 1)
"""specified content is a filename."""
alias CURL_HTTPPOST_PTRNAME = (1 << 2)
"""name is only stored pointer do not free in formfree."""
alias CURL_HTTPPOST_PTRCONTENTS = (1 << 3)
"""contents is only stored pointer do not free in formfree."""
alias CURL_HTTPPOST_BUFFER = (1 << 4)
"""upload file from buffer."""
alias CURL_HTTPPOST_PTRBUFFER = (1 << 5)
"""upload file from pointer contents."""
alias CURL_HTTPPOST_CALLBACK = (1 << 6)
"""upload file contents by using the regular read callback to get the data and
   pass the given pointer as custom pointer."""
alias CURL_HTTPPOST_LARGE = (1 << 7)
"""use size in 'contentlen', added in 7.46.0."""


alias CURL_MAX_READ_SIZE = (10 * 1024 * 1024)
"""The maximum receive buffer size configurable via BUFFERSIZE."""

alias CURL_MAX_WRITE_SIZE = (16 * 1024)
"""Tests have proven that 20K is a bad buffer size for uploads on Windows,
while 16K for some odd reason performed a lot better. We do the ifndef
check to allow this value to easier be changed at build time for those
who feel adventurous. The practical minimum is about 400 bytes since
libcurl uses a buffer of this size as a scratch area (unrelated to
network send operations)."""


alias CURL_MAX_HTTP_HEADER = (100 * 1024)
"""The only reason to have a max limit for this is to avoid the risk of a bad
server feeding libcurl with a never-ending header that will cause reallocs
infinitely."""


alias CURL_WRITEFUNC_PAUSE = 0x10000001
"""This is a magic return code for the write callback that, when returned,
   will signal libcurl to pause receiving on the current transfer."""


alias CURL_WRITEFUNC_ERROR = 0xFFFFFFFF
"""This is a magic return code for the write callback that, when returned,
   will signal an error from the callback."""


alias curl_resolver_start_callback = fn (OpaquePointer, OpaquePointer, OpaquePointer) -> c_int
"""This callback will be called when a new resolver request is made."""

alias CURL_GLOBAL_SSL = (1 << 0)
alias CURL_GLOBAL_WIN32 = (1 << 1)
alias CURL_GLOBAL_ALL = (CURL_GLOBAL_SSL | CURL_GLOBAL_WIN32)
alias CURL_GLOBAL_NOTHING = 0
alias CURL_GLOBAL_DEFAULT = CURL_GLOBAL_ALL
alias CURL_GLOBAL_ACK_EINTR = (1 << 2)
