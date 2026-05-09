from std.ffi import c_int
from mojo_curl.c.types import (
    CURLOPT_FILE,
    CURLOPT_URL,
    CURLOPT_PORT,
    CURLOPT_PROXY,
    CURLOPT_USERPWD,
    CURLOPT_PROXYUSERPWD,
    CURLOPT_RANGE,
    CURLOPT_INFILE,
    CURLOPT_ERRORBUFFER,
    CURLOPT_WRITEFUNCTION,
    CURLOPT_READFUNCTION,
    CURLOPT_TIMEOUT,
    CURLOPT_INFILESIZE,
    CURLOPT_POSTFIELDS,
    CURLOPT_REFERER,
    CURLOPT_FTPPORT,
    CURLOPT_USERAGENT,
    CURLOPT_LOW_SPEED_LIMIT,
    CURLOPT_LOW_SPEED_TIME,
    CURLOPT_RESUME_FROM,
    CURLOPT_COOKIE,
    CURLOPT_HTTPHEADER,
    CURLOPT_HTTPPOST,
    CURLOPT_SSLCERT,
    CURLOPT_KEYPASSWD,
    CURLOPT_CRLF,
    CURLOPT_QUOTE,
    CURLOPT_WRITEHEADER,
    CURLOPT_COOKIEFILE,
    CURLOPT_SSLVERSION,
    CURLOPT_TIMECONDITION,
    CURLOPT_TIMEVALUE,
    CURLOPT_CUSTOMREQUEST,
    CURLOPT_STDERR,
    CURLOPT_POSTQUOTE,
    CURLOPT_WRITEINFO,
    CURLOPT_VERBOSE,
    CURLOPT_HEADER,
    CURLOPT_NOPROGRESS,
    CURLOPT_NOBODY,
    CURLOPT_FAILONERROR,
    CURLOPT_UPLOAD,
    CURLOPT_POST,
    CURLOPT_DIRLISTONLY,
    CURLOPT_APPEND,
    CURLOPT_NETRC,
    CURLOPT_FOLLOWLOCATION,
    CURLOPT_TRANSFERTEXT,
    CURLOPT_PUT,
    CURLOPT_PROGRESSFUNCTION,
    CURLOPT_PROGRESSDATA,
    CURLOPT_AUTOREFERER,
    CURLOPT_PROXYPORT,
    CURLOPT_POSTFIELDSIZE,
    CURLOPT_HTTPPROXYTUNNEL,
    CURLOPT_INTERFACE,
    CURLOPT_KRBLEVEL,
    CURLOPT_SSL_VERIFYPEER,
    CURLOPT_CAINFO,
    CURLOPT_MAXREDIRS,
    CURLOPT_FILETIME,
    CURLOPT_TELNETOPTIONS,
    CURLOPT_MAXCONNECTS,
    CURLOPT_CLOSEPOLICY,
    CURLOPT_FRESH_CONNECT,
    CURLOPT_FORBID_REUSE,
    CURLOPT_RANDOM_FILE,
    CURLOPT_EGDSOCKET,
    CURLOPT_CONNECTTIMEOUT,
    CURLOPT_HEADERFUNCTION,
    CURLOPT_HTTPGET,
    CURLOPT_SSL_VERIFYHOST,
    CURLOPT_COOKIEJAR,
    CURLOPT_SSL_CIPHER_LIST,
    CURLOPT_HTTP_VERSION,
    CURLOPT_FTP_USE_EPSV,
    CURLOPT_SSLCERTTYPE,
    CURLOPT_SSLKEY,
    CURLOPT_SSLKEYTYPE,
    CURLOPT_SSLENGINE,
    CURLOPT_SSLENGINE_DEFAULT,
    CURLOPT_DNS_USE_GLOBAL_CACHE
)
struct Option(Copyable, TrivialRegisterPassable):
    """CURLoption values for setting options on CURL easy handles."""
    var value: c_int
    """Internal enum value."""

    comptime WRITE_DATA: Self = Self.OBJECT_POINT + 1
    comptime FILE: Self = CURLOPT_FILE
    comptime URL: Self = CURLOPT_URL
    comptime PORT: Self = CURLOPT_PORT
    comptime PROXY: Self = CURLOPT_PROXY
    comptime USER_PWD: Self = CURLOPT_USERPWD
    comptime PROXY_USER_PWD: Self = CURLOPT_PROXYUSERPWD
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
    comptime RANDOM_FILE: Self = Self.OBJECT_POINT + 76
    comptime EGD_SOCKET: Self = Self.OBJECT_POINT + 77
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
    comptime DNS_USE_GLOBAL_CACHE: Self = CURLOPT_DNS_USE_GLOBAL_CACHE
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
    def __init__(out self, value: Int):
        self.value = c_int(value)

    @implicit
    def __init__(out self, value: c_int):
        self.value = value
