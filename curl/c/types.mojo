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


@register_passable("trivial")
struct curl_slist:
    """Singly linked list structure for curl string lists."""

    var data: ExternalMutPointer[c_char]
    var next: ExternalMutPointer[curl_slist]


alias curl_socket_t = c_int
alias CURL_SOCKET_BAD = -1

alias curl_off_t = c_long

# Callback function types
alias curl_write_callback = fn (
    ExternalImmutPointer[c_char], c_size_t, c_size_t, ExternalMutOpaquePointer
) -> c_size_t
alias curl_read_callback = fn (ExternalImmutPointer[c_char], c_size_t, c_size_t, ExternalMutOpaquePointer) -> c_size_t
alias curl_progress_callback = fn (ExternalImmutOpaquePointer, Float64, Float64, Float64, Float64) -> c_int
alias curl_debug_callback = fn (CURL, c_int, UnsafePointer[c_char], c_size_t, ExternalMutOpaquePointer) -> c_int
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
struct Option(Copyable, Movable):
    var value: c_int

    alias LONG = 0
    alias OBJECT_POINT = 10_000
    alias FUNCTION_POINT = 20_000
    alias OFF_T = 30_000
    alias BLOB = 40_000
    alias VALUES = Self.LONG

    alias WRITE_DATA: Self = Self.OBJECT_POINT + 1
    alias FILE: Self = Self.WRITE_DATA
    alias URL: Self = Self.OBJECT_POINT + 2
    alias PORT: Self = Self.LONG + 3
    alias PROXY: Self = Self.OBJECT_POINT + 4
    alias USER_PWD: Self = Self.OBJECT_POINT + 5
    alias PROXY_USER_PWD: Self = Self.OBJECT_POINT + 6
    alias RANGE: Self = Self.OBJECT_POINT + 7
    alias IN_FILE: Self = Self.OBJECT_POINT + 9
    alias ERROR_BUFFER: Self = Self.OBJECT_POINT + 10
    alias WRITE_FUNCTION: Self = Self.FUNCTION_POINT + 11
    alias READ_FUNCTION: Self = Self.FUNCTION_POINT + 12
    alias TIMEOUT: Self = Self.LONG + 13
    alias IN_FILE_SIZE: Self = Self.LONG + 14
    alias POST_FIELDS: Self = Self.OBJECT_POINT + 15
    alias REFERER: Self = Self.OBJECT_POINT + 16
    alias FTP_PORT: Self = Self.OBJECT_POINT + 17
    alias USERAGENT: Self = Self.OBJECT_POINT + 18
    alias LOW_SPEED_LIMIT: Self = Self.LONG + 19
    alias LOW_SPEED_TIME: Self = Self.LONG + 20
    alias RESUME_FROM: Self = Self.LONG + 21
    alias COOKIE: Self = Self.OBJECT_POINT + 22
    alias HTTP_HEADER: Self = Self.OBJECT_POINT + 23
    alias SSL_CERT: Self = Self.OBJECT_POINT + 25
    alias KEY_PASSWD: Self = Self.OBJECT_POINT + 26
    alias CRLF: Self = Self.LONG + 27
    alias QUOTE: Self = Self.OBJECT_POINT + 28
    alias WRITE_HEADER: Self = Self.OBJECT_POINT + 29
    alias COOKIE_FILE: Self = Self.OBJECT_POINT + 31
    alias SSL_VERSION: Self = Self.LONG + 32
    alias TIME_CONDITION: Self = Self.LONG + 33
    alias TIME_VALUE: Self = Self.LONG + 34
    alias CUSTOM_REQUEST: Self = Self.OBJECT_POINT + 36
    alias STDERR: Self = Self.OBJECT_POINT + 37
    alias POST_QUOTE: Self = Self.OBJECT_POINT + 39
    alias VERBOSE: Self = Self.LONG + 41
    alias HEADER: Self = Self.LONG + 42
    alias NO_PROGRESS: Self = Self.LONG + 43
    alias NO_BODY: Self = Self.LONG + 44
    alias FAIL_ON_ERROR: Self = Self.LONG + 45
    alias UPLOAD: Self = Self.LONG + 46
    alias POST: Self = Self.LONG + 47
    alias DIR_LIST_ONLY: Self = Self.LONG + 48
    alias APPEND: Self = Self.LONG + 50
    alias NETRC: Self = Self.LONG + 51
    alias FOLLOW_LOCATION: Self = Self.LONG + 52
    alias TRANSFER_TEXT: Self = Self.LONG + 53
    alias PROGRESS_DATA: Self = Self.OBJECT_POINT + 57
    alias AUTO_REFERER: Self = Self.LONG + 58
    alias PROXY_PORT: Self = Self.LONG + 59
    alias POST_FIELD_SIZE: Self = Self.LONG + 60
    alias HTTP_PROXY_TUNNEL: Self = Self.LONG + 61
    alias INTERFACE: Self = Self.OBJECT_POINT + 62
    alias KRB_LEVEL: Self = Self.OBJECT_POINT + 63
    alias SSL_VERIFYPEER: Self = Self.LONG + 64
    alias CAINFO: Self = Self.OBJECT_POINT + 65
    alias MAXREDIRS: Self = Self.LONG + 68
    alias FILE_TIME: Self = Self.LONG + 69
    alias TELNET_OPTIONS: Self = Self.OBJECT_POINT + 70
    alias MAX_CONNECTS: Self = Self.LONG + 71
    alias FRESH_CONNECT: Self = Self.LONG + 74
    alias FORBID_REUSE: Self = Self.LONG + 75
    alias CONNECT_TIMEOUT: Self = Self.LONG + 78
    alias HEADER_FUNCTION: Self = Self.FUNCTION_POINT + 79
    alias HTTPGET: Self = Self.LONG + 80
    alias SSL_VERIFY_HOST: Self = Self.LONG + 81
    alias COOKIEJAR: Self = Self.OBJECT_POINT + 82
    alias SSL_CIPHER_LIST: Self = Self.OBJECT_POINT + 83
    alias HTTP_VERSION: Self = Self.LONG + 84
    alias FTP_USE_EPSV: Self = Self.LONG + 85
    alias SSL_CERT_TYPE: Self = Self.OBJECT_POINT + 86
    alias SSL_KEY: Self = Self.OBJECT_POINT + 87
    alias SSL_KEY_TYPE: Self = Self.OBJECT_POINT + 88
    alias SSL_ENGINE: Self = Self.OBJECT_POINT + 89
    alias SSL_ENGINE_DEFAULT: Self = Self.LONG + 90
    alias DNS_CACHE_TIMEOUT: Self = Self.LONG + 92
    alias PREQUOTE: Self = Self.OBJECT_POINT + 93
    alias DEBUG_FUNCTION: Self = Self.FUNCTION_POINT + 94
    alias DEBUG_DATA: Self = Self.OBJECT_POINT + 95
    alias COOKIE_SESSION: Self = Self.LONG + 96
    alias CAPATH: Self = Self.OBJECT_POINT + 97
    alias BUFFER_SIZE: Self = Self.LONG + 98
    alias NO_SIGNAL: Self = Self.LONG + 99
    alias SHARE: Self = Self.OBJECT_POINT + 100
    alias PROXY_TYPE: Self = Self.LONG + 101
    alias ACCEPT_ENCODING: Self = Self.OBJECT_POINT + 102
    alias PRIVATE: Self = Self.OBJECT_POINT + 103
    alias HTTP200_ALIASES: Self = Self.OBJECT_POINT + 104
    alias UNRESTRICTED_AUTH: Self = Self.LONG + 105
    alias FTP_USE_EPRT: Self = Self.LONG + 106
    alias HTTP_AUTH: Self = Self.LONG + 107
    alias SSL_CTX_FUNCTION: Self = Self.FUNCTION_POINT + 108
    alias SSL_CTX_DATA: Self = Self.OBJECT_POINT + 109
    alias FTP_CREATE_MISSING_DIRS: Self = Self.LONG + 110
    alias PROXY_AUTH: Self = Self.LONG + 111
    alias FTP_RESPONSE_TIMEOUT: Self = Self.LONG + 112
    alias IP_RESOLVE: Self = Self.LONG + 113
    alias MAX_FILE_SIZE: Self = Self.LONG + 114
    alias IN_FILE_SIZE_LARGE: Self = Self.OFF_T + 115
    alias RESUME_FROM_LARGE: Self = Self.OFF_T + 116
    alias MAX_FILE_SIZE_LARGE: Self = Self.OFF_T + 117
    alias NETRC_FILE: Self = Self.OBJECT_POINT + 118
    alias USE_SSL: Self = Self.LONG + 119
    alias POST_FIELD_SIZE_LARGE: Self = Self.OFF_T + 120
    alias TCP_NODELAY: Self = Self.LONG + 121
    alias FTP_SSL_AUTH: Self = Self.LONG + 129
    alias FTP_ACCOUNT: Self = Self.OBJECT_POINT + 134
    alias COOKIE_LIST: Self = Self.OBJECT_POINT + 135
    alias IGNORE_CONTENT_LENGTH: Self = Self.LONG + 136
    alias FTP_SKIP_PASV_IP: Self = Self.LONG + 137
    alias FTP_FILE_METHOD: Self = Self.LONG + 138
    alias LOCAL_PORT: Self = Self.LONG + 139
    alias LOCAL_PORT_RANGE: Self = Self.LONG + 140
    alias CONNECT_ONLY: Self = Self.LONG + 141
    alias MAX_SEND_SPEED_LARGE: Self = Self.OFF_T + 145
    alias MAX_RECV_SPEED_LARGE: Self = Self.OFF_T + 146
    alias FTP_ALTERNATIVE_TO_USER: Self = Self.OBJECT_POINT + 147
    alias SOCKOPT_FUNCTION: Self = Self.FUNCTION_POINT + 148
    alias SOCKOPT_DATA: Self = Self.OBJECT_POINT + 149
    alias SSL_SESSIONID_CACHE: Self = Self.LONG + 150
    alias SSH_AUTH_TYPES: Self = Self.LONG + 151
    alias SSH_PUBLIC_KEYFILE: Self = Self.OBJECT_POINT + 152
    alias SSH_PRIVATE_KEYFILE: Self = Self.OBJECT_POINT + 153
    alias FTP_SSL_CCC: Self = Self.LONG + 154
    alias TIMEOUT_MS: Self = Self.LONG + 155
    alias CONNECT_TIMEOUT_MS: Self = Self.LONG + 156
    alias HTTP_TRANSFER_DECODING: Self = Self.LONG + 157
    alias HTTP_CONTENT_DECODING: Self = Self.LONG + 158
    alias NEW_FILE_PERMS: Self = Self.LONG + 159
    alias NEW_DIRECTORY_PERMS: Self = Self.LONG + 160
    alias POST_REDIR: Self = Self.LONG + 161
    alias SSH_HOST_PUBLIC_KEY_MD5: Self = Self.OBJECT_POINT + 162
    alias OPEN_SOCKET_FUNCTION: Self = Self.FUNCTION_POINT + 163
    alias OPEN_SOCKET_DATA: Self = Self.OBJECT_POINT + 164
    alias COPY_POST_FIELDS: Self = Self.OBJECT_POINT + 165
    alias PROXY_TRANSFER_MODE: Self = Self.LONG + 166
    alias SEEK_FUNCTION: Self = Self.FUNCTION_POINT + 167
    alias SEEK_DATA: Self = Self.OBJECT_POINT + 168
    alias CRL_FILE: Self = Self.OBJECT_POINT + 169
    alias ISSUER_CERT: Self = Self.OBJECT_POINT + 170
    alias ADDRESS_SCOPE: Self = Self.LONG + 171
    alias CERT_INFO: Self = Self.LONG + 172
    alias USERNAME: Self = Self.OBJECT_POINT + 173
    alias PASSWORD: Self = Self.OBJECT_POINT + 174
    alias PROXY_USERNAME: Self = Self.OBJECT_POINT + 175
    alias PROXY_PASSWORD: Self = Self.OBJECT_POINT + 176
    alias NO_PROXY: Self = Self.OBJECT_POINT + 177
    alias TFTP_BLK_SIZE: Self = Self.LONG + 178
    alias SOCKS5_GSSAPI_NEC: Self = Self.LONG + 180
    alias SSH_KNOWNHOSTS: Self = Self.OBJECT_POINT + 183
    alias SSH_KEY_FUNCTION: Self = Self.FUNCTION_POINT + 184
    alias SSH_KEY_DATA: Self = Self.OBJECT_POINT + 185
    alias MAIL_FROM: Self = Self.OBJECT_POINT + 186
    alias MAIL_RCPT: Self = Self.OBJECT_POINT + 187
    alias FTP_USE_PRET: Self = Self.LONG + 188
    alias RTSP_REQUEST: Self = Self.LONG + 189
    alias RTSP_SESSION_ID: Self = Self.OBJECT_POINT + 190
    alias RTSP_STREAM_URI: Self = Self.OBJECT_POINT + 191
    alias RTSP_TRANSPORT: Self = Self.OBJECT_POINT + 192
    alias RTSP_CLIENT_CSEQ: Self = Self.LONG + 193
    alias RTSP_SERVER_CSEQ: Self = Self.LONG + 194
    alias INTERLEAVE_DATA: Self = Self.OBJECT_POINT + 195
    alias INTERLEAVE_FUNCTION: Self = Self.FUNCTION_POINT + 196
    alias WILDCARD_MATCH: Self = Self.LONG + 197
    alias CHUNK_BGN_FUNCTION: Self = Self.FUNCTION_POINT + 198
    alias CHUNK_END_FUNCTION: Self = Self.FUNCTION_POINT + 199
    alias FN_MATCH_FUNCTION: Self = Self.FUNCTION_POINT + 200
    alias CHUNK_DATA: Self = Self.OBJECT_POINT + 201
    alias FN_MATCH_DATA: Self = Self.OBJECT_POINT + 202
    alias RESOLVE: Self = Self.OBJECT_POINT + 203
    alias TLS_AUTH_USERNAME: Self = Self.OBJECT_POINT + 204
    alias TLS_AUTH_PASSWORD: Self = Self.OBJECT_POINT + 205
    alias TLS_AUTH_TYPE: Self = Self.OBJECT_POINT + 206
    alias TRANSFER_ENCODING: Self = Self.LONG + 207
    alias CLOSE_SOCKET_FUNCTION: Self = Self.FUNCTION_POINT + 208
    alias CLOSE_SOCKET_DATA: Self = Self.OBJECT_POINT + 209
    alias GSSAPI_DELEGATION: Self = Self.LONG + 210
    alias DNS_SERVERS: Self = Self.OBJECT_POINT + 211
    alias TCP_KEEPALIVE: Self = Self.LONG + 213
    alias TCP_KEEPIDLE: Self = Self.LONG + 214
    alias TCP_KEEPINTVL: Self = Self.LONG + 215
    alias SSL_OPTIONS: Self = Self.LONG + 216
    alias EXPECT_100_TIMEOUT_MS: Self = Self.LONG + 227
    alias PINNED_PUBLIC_KEY: Self = Self.OBJECT_POINT + 230
    alias UNIX_SOCKET_PATH: Self = Self.OBJECT_POINT + 231
    alias PATH_AS_IS: Self = Self.LONG + 234
    alias PIPE_WAIT: Self = Self.LONG + 237
    alias CONNECT_TO: Self = Self.OBJECT_POINT + 243
    alias PROXY_CAINFO: Self = Self.OBJECT_POINT + 246
    alias PROXY_CAPATH: Self = Self.OBJECT_POINT + 247
    alias PROXY_SSL_VERIFYPEER: Self = Self.LONG + 248
    alias PROXY_SSL_VERIFYHOST: Self = Self.LONG + 249
    alias PROXY_SSL_VERSION: Self = Self.VALUES + 250
    alias PROXY_SSL_CERT: Self = Self.OBJECT_POINT + 254
    alias PROXY_SSL_CERT_TYPE: Self = Self.OBJECT_POINT + 255
    alias PROXY_SSL_KEY: Self = Self.OBJECT_POINT + 256
    alias PROXY_SSL_KEY_TYPE: Self = Self.OBJECT_POINT + 257
    alias PROXY_KEYPASSWD: Self = Self.OBJECT_POINT + 258
    alias PROXY_SSL_CIPHER_LIST: Self = Self.OBJECT_POINT + 259
    alias PROXY_CRL_FILE: Self = Self.OBJECT_POINT + 260
    alias PROXY_SSL_OPTIONS: Self = Self.LONG + 261
    alias ABSTRACT_UNIX_SOCKET: Self = Self.OBJECT_POINT + 264
    alias DOH_URL: Self = Self.OBJECT_POINT + 279
    alias UPLOAD_BUFFER_SIZE: Self = Self.LONG + 280
    alias HTTP09_ALLOWED: Self = Self.LONG + 285
    alias MAX_AGE_CONN: Self = Self.LONG + 288
    alias SSL_CERT_BLOB: Self = Self.BLOB + 291
    alias SSL_KEY_BLOB: Self = Self.BLOB + 292
    alias PROXY_SSL_CERT_BLOB: Self = Self.BLOB + 293
    alias PROXY_SSL_KEY_BLOB: Self = Self.BLOB + 294
    alias ISSUER_CERT_BLOB: Self = Self.BLOB + 295
    alias PROXY_ISSUER_CERT: Self = Self.OBJECT_POINT + 296
    alias PROXY_ISSUER_CERT_BLOB: Self = Self.BLOB + 297
    alias AWS_SIGV4: Self = Self.OBJECT_POINT + 305
    alias DOH_SSL_VERIFY_PEER: Self = Self.LONG + 306
    alias DOH_SSL_VERIFY_HOST: Self = Self.LONG + 307
    alias DOH_SSL_VERIFY_STATUS: Self = Self.LONG + 308
    alias CAINFO_BLOB: Self = Self.BLOB + 309
    alias PROXY_CAINFO_BLOB: Self = Self.BLOB + 310
    alias SSH_HOST_PUBLIC_KEY_SHA256: Self = Self.OBJECT_POINT + 311
    alias PREREQ_FUNCTION: Self = Self.FUNCTION_POINT + 312
    alias PREREQ_DATA: Self = Self.OBJECT_POINT + 313
    alias MAX_LIFETIME_CONN: Self = Self.LONG + 314
    alias MIME_OPTIONS: Self = Self.LONG + 315
    alias SSH_HOST_KEY_FUNCTION: Self = Self.FUNCTION_POINT + 316
    alias SSH_HOST_KEY_DATA: Self = Self.OBJECT_POINT + 317
    alias PROTOCOLS_STR: Self = Self.OBJECT_POINT + 318
    alias REDIR_PROTOCOLS_STR: Self = Self.OBJECT_POINT + 319
    alias WS_OPTIONS: Self = Self.LONG + 320
    alias CA_CACHE_TIMEOUT: Self = Self.LONG + 321
    alias QUICK_EXIT: Self = Self.LONG + 322
    alias HAPROXY_CLIENT_IP: Self = Self.OBJECT_POINT + 323
    alias SERVER_RESPONSE_TIMEOUT_MS: Self = Self.LONG + 324
    alias ECH: Self = Self.OBJECT_POINT + 325
    alias TCP_KEEPCNT: Self = Self.LONG + 326
    alias UPLOAD_FLAGS: Self = Self.LONG + 327
    alias SSL_SIGNATURE_ALGORITHMS: Self = Self.OBJECT_POINT + 328


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

    alias STRING = 0x100000
    alias LONG = 0x200000
    alias DOUBLE = 0x300000
    alias SLIST = 0x400000
    alias PTR = 0x400000
    alias SOCKET = 0x500000
    alias OFF_T = 0x600000
    alias MASK = 0x0FFFFF
    alias TYPE_MASK = 0xF00000

    alias EFFECTIVE_URL: Self = Self.STRING + 1
    """[CURLINFO_EFFECTIVE_URL] Get the last used effective URL."""
    alias RESPONSE_CODE: Self = Self.LONG + 2
    """[CURLINFO_RESPONSE_CODE] Get the last received response code."""
    alias TOTAL_TIME: Self = Self.DOUBLE + 3
    """[CURLINFO_TOTAL_TIME] Get total time of previous transfer."""
    alias NAME_LOOKUP_TIME: Self = Self.DOUBLE + 4
    """[CURLINFO_NAME_LOOKUP_TIME] Get time from start until name resolving completed."""
    alias CONNECT_TIME: Self = Self.DOUBLE + 5
    """[CURLINFO_CONNECT_TIME] Get time from start until connect to remote host completed."""
    alias PRE_TRANSFER_TIME: Self = Self.DOUBLE + 6
    """[CURLINFO_PRETRANSFER_TIME] Get time from start until file transfer is just about to begin."""
    alias SIZE_UPLOAD_T: Self = Self.OFF_T + 7
    """[CURLINFO_SIZE_UPLOAD_T] Get number of bytes uploaded."""
    alias SIZE_DOWNLOAD_T: Self = Self.OFF_T + 8
    """[CURLINFO_SIZE_DOWNLOAD_T] Get number of bytes downloaded."""
    alias SPEED_DOWNLOAD_T: Self = Self.OFF_T + 9
    """[CURLINFO_SPEED_DOWNLOAD_T] Get average download speed in number of bytes per second."""
    alias SPEED_UPLOAD_T: Self = Self.OFF_T + 10
    """[CURLINFO_SPEED_UPLOAD_T] Get average upload speed in number of bytes per second."""
    alias HEADER_SIZE: Self = Self.LONG + 11
    """[CURLINFO_HEADER_SIZE] Get number of bytes of all headers received."""
    alias REQUEST_SIZE: Self = Self.LONG + 12
    """[CURLINFO_REQUEST_SIZE] Get number of bytes sent in the issued HTTP requests."""
    alias SSL_VERIFY_RESULT: Self = Self.LONG + 13
    """[CURLINFO_SSL_VERIFY_RESULT] Get certificate verification result."""
    alias FILE_TIME: Self = Self.LONG + 14
    """[CURLINFO_FILE_TIME] Get remote time of the retrieved document."""
    alias CONTENT_LENGTH_DOWNLOAD_T: Self = Self.OFF_T + 15
    """[CURLINFO_CONTENT_LENGTH_DOWNLOAD_T] Get content length from the Content-Length header."""
    alias CONTENT_LENGTH_UPLOAD_T: Self = Self.OFF_T + 16
    """[CURLINFO_CONTENT_LENGTH_UPLOAD_T] Get upload size."""
    alias START_TRANSFER_TIME: Self = Self.DOUBLE + 17
    """[CURLINFO_STARTTRANSFER_TIME] Get time from start until first byte is received by libcurl."""
    alias CONTENT_TYPE: Self = Self.STRING + 18
    """[CURLINFO_CONTENT_TYPE] Get content type from the Content-Type: header."""
    alias REDIRECT_TIME: Self = Self.DOUBLE + 19
    """[CURLINFO_REDIRECT_TIME] Get time for all redirection steps before final transaction started."""
    alias REDIRECT_COUNT: Self = Self.LONG + 20
    """[CURLINFO_REDIRECT_COUNT] Get total number of redirects that were followed."""
    alias PRIVATE: Self = Self.STRING + 21
    """[CURLINFO_PRIVATE] Get user's private data pointer."""
    alias HTTP_CONNECT_CODE: Self = Self.LONG + 22
    """[CURLINFO_HTTP_CONNECTCODE] Get last proxy CONNECT response code."""
    alias HTTP_AUTH_AVAIL: Self = Self.LONG + 23
    """[CURLINFO_HTTPAUTH_AVAIL] Get available HTTP authentication methods."""
    alias PROXY_AUTH_AVAIL: Self = Self.LONG + 24
    """[CURLINFO_PROXYAUTH_AVAIL] Get available HTTP proxy authentication methods."""
    alias OS_ERRNO: Self = Self.LONG + 25
    """[CURLINFO_OS_ERRNO] Get the errno from the last failure to connect."""
    alias NUM_CONNECTS: Self = Self.LONG + 26
    """[CURLINFO_NUM_CONNECTS] Get number of new successful connections used for previous transfer."""
    alias SSL_ENGINES: Self = Self.SLIST + 27
    """[CURLINFO_SSL_ENGINES] Get a list of OpenSSL crypto engines."""
    alias COOKIE_LIST: Self = Self.SLIST + 28
    """[CURLINFO_COOKIELIST] Get list of all known cookies."""
    alias FTP_ENTRY_PATH: Self = Self.STRING + 30
    """[CURLINFO_FTP_ENTRY_PATH] Get the entry path after logging in to an FTP server."""
    alias REDIRECT_URL: Self = Self.STRING + 31
    """[CURLINFO_REDIRECT_URL] Get URL a redirect would take you to, had you enabled redirects."""
    alias PRIMARY_IP: Self = Self.STRING + 32
    """[CURLINFO_PRIMARY_IP] Get destination IP address of the last connection."""
    alias APP_CONNECT_TIME: Self = Self.DOUBLE + 33
    """[CURLINFO_APPCONNECT_TIME] Get time from start until SSL connect/handshake completed."""
    alias CERTINFO: Self = Self.SLIST + 34
    """[CURLINFO_CERTINFO] Get certificate chain."""
    alias CONDITION_UNMET: Self = Self.LONG + 35
    """[CURLINFO_CONDITION_UNMET] Get whether or not a time conditional was met or 304 HTTP response."""
    alias RTSP_SESSION_ID: Self = Self.STRING + 36
    """[CURLINFO_RTSP_SESSION_ID] Get RTSP session ID."""
    alias RTSP_CLIENT_CSEQ: Self = Self.LONG + 37
    """[CURLINFO_RTSP_CLIENT_CSEQ] Get the RTSP client CSeq that is expected next."""
    alias RTSP_SERVER_CSEQ: Self = Self.LONG + 38
    """[CURLINFO_RTSP_SERVER_CSEQ] Get the RTSP server CSeq that is expected next."""
    alias RTSP_CSEQ_RECV: Self = Self.LONG + 39
    """[CURLINFO_RTSP_CSEQ_RECV] Get RTSP CSeq last received."""
    alias PRIMARY_PORT: Self = Self.LONG + 40
    """[CURLINFO_PRIMARY_PORT] Get destination port of the last connection."""
    alias LOCAL_IP: Self = Self.STRING + 41
    """[CURLINFO_LOCAL_IP] Get source IP address of the last connection."""
    alias LOCAL_PORT: Self = Self.LONG + 42
    """[CURLINFO_LOCAL_PORT] Get source port number of the last connection."""
    alias ACTIVE_SOCKET: Self = Self.SOCKET + 44
    """[CURLINFO_ACTIVESOCKET] Get the session's active socket."""
    alias TLS_SSL_PTR: Self = Self.PTR + 45
    """[CURLINFO_TLS_SSL_PTR] Get TLS session info that can be used for further processing."""
    alias HTTP_VERSION: Self = Self.LONG + 46
    """[CURLINFO_HTTP_VERSION] Get the http version used in the connection."""
    alias PROXY_SSL_VERIFYRESULT: Self = Self.LONG + 47
    """[CURLINFO_PROXY_SSL_VERIFYRESULT] Get proxy certificate verification result."""
    alias SCHEME: Self = Self.STRING + 49
    """[CURLINFO_SCHEME] Get the scheme used for the connection."""
    alias TOTAL_TIME_T: Self = Self.OFF_T + 50
    """[CURLINFO_TOTAL_TIME_T] Get total time of previous transfer in microseconds."""
    alias NAMELOOKUP_TIME_T: Self = Self.OFF_T + 51
    """[CURLINFO_NAMELOOKUP_TIME_T] Get time from start until name resolving completed in microseconds."""
    alias CONNECT_TIME_T: Self = Self.OFF_T + 52
    """[CURLINFO_CONNECT_TIME_T] Get time from start until connect to remote host completed in microseconds."""
    alias PRETRANSFER_TIME_T: Self = Self.OFF_T + 53
    """[CURLINFO_PRETRANSFER_TIME_T] Get time from start until file transfer is just about to begin in microseconds."""
    alias STARTTRANSFER_TIME_T: Self = Self.OFF_T + 54
    """[CURLINFO_STARTTRANSFER_TIME_T] Get time from start until first byte is received by libcurl in microseconds."""
    alias REDIRECT_TIME_T: Self = Self.OFF_T + 55
    """[CURLINFO_REDIRECT_TIME_T] Get time for all redirection steps before final transaction started in microseconds."""
    alias APPCONNECT_TIME_T: Self = Self.OFF_T + 56
    """[CURLINFO_APPCONNECT_TIME_T] Get time from start until SSL connect/handshake completed in microseconds."""
    alias RETRY_AFTER: Self = Self.OFF_T + 57
    """[CURLINFO_RETRY_AFTER] Get the value from the Retry-After header."""
    alias EFFECTIVE_METHOD: Self = Self.STRING + 58
    """[CURLINFO_EFFECTIVE_METHOD] Get last used HTTP method."""
    alias PROXY_ERROR: Self = Self.LONG + 59
    """[CURLINFO_PROXY_ERROR] Get detailed proxy error."""
    alias REFERER: Self = Self.STRING + 60
    """[CURLINFO_REFERER] Get referrer header."""
    alias CAINFO: Self = Self.STRING + 61
    """[CURLINFO_CAINFO] Get the default value for CURLOPT_CAINFO."""
    alias CAPATH: Self = Self.STRING + 62
    """[CURLINFO_CAPATH] Get the default value for CURLOPT_CAPATH."""
    alias XFER_ID: Self = Self.OFF_T + 63
    """[CURLINFO_XFER_ID] Get the ID of the transfer."""
    alias CONN_ID: Self = Self.OFF_T + 64
    """[CURLINFO_CONN_ID] Get the ID of the last connection used by the transfer."""
    alias QUEUE_TIME_T: Self = Self.OFF_T + 65
    """[CURLINFO_QUEUE_TIME_T] Get the time the transfer was held in a waiting queue before it could start in microseconds."""
    alias USED_PROXY: Self = Self.LONG + 66
    """[CURLINFO_USED_PROXY] Get whether the proxy was used."""
    alias POSTTRANSFER_TIME_T: Self = Self.OFF_T + 67
    """[CURLINFO_POSTTRANSFER_TIME_T] Get the time from start until the last byte is sent by libcurl in microseconds."""
    alias EARLYDATA_SENT_T: Self = Self.OFF_T + 68
    """[CURLINFO_EARLYDATA_SENT_T] Get amount of TLS early data sent in number of bytes."""
    alias HTTPAUTH_USED: Self = Self.LONG + 69
    """[CURLINFO_HTTPAUTH_USED] Get used HTTP authentication method."""
    alias PROXYAUTH_USED: Self = Self.LONG + 70
    """[CURLINFO_PROXYAUTH_USED] Get used HTTP proxy authentication methods."""
    alias LASTONE: Self = 70
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
