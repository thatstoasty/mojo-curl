# import os
# import pathlib
# from sys import ffi, env_get_string, CompilationTarget
# from sys.ffi import DLHandle, c_char, c_int, c_uint, c_size_t, c_long

# from memory import OpaquePointer, UnsafePointer

# # Type aliases for curl
# alias CURL = OpaquePointer
# alias CURLcode = c_int
# alias CURLoption = c_int
# alias CURLINFO = c_int
# alias CURLMcode = c_int
# alias CURLM = OpaquePointer
# alias CURLMsg = OpaquePointer
# alias curl_slist = OpaquePointer

# # Callback function types
# alias curl_write_callback = fn (UnsafePointer[c_char], c_size_t, c_size_t, OpaquePointer) -> c_size_t
# alias curl_read_callback = fn (UnsafePointer[c_char], c_size_t, c_size_t, OpaquePointer) -> c_size_t
# alias curl_progress_callback = fn (OpaquePointer, c_long, c_long, c_long, c_long) -> c_int
# alias curl_debug_callback = fn (CURL, c_int, UnsafePointer[c_char], c_size_t, OpaquePointer) -> c_int

# # Flag bits for curl_blob struct
# alias CURL_BLOB_COPY = 1
# alias CURL_BLOB_NOCOPY = 0

# # Common CURLcode values
# alias CURLE_OK = 0
# alias CURLE_UNSUPPORTED_PROTOCOL = 1
# alias CURLE_FAILED_INIT = 2
# alias CURLE_URL_MALFORMAT = 3
# alias CURLE_NOT_BUILT_IN = 4
# alias CURLE_COULDNT_RESOLVE_PROXY = 5
# alias CURLE_COULDNT_RESOLVE_HOST = 6
# alias CURLE_COULDNT_CONNECT = 7
# alias CURLE_WEIRD_SERVER_REPLY = 8
# alias CURLE_REMOTE_ACCESS_DENIED = 9
# alias CURLE_FTP_ACCEPT_FAILED = 10
# alias CURLE_FTP_WEIRD_PASS_REPLY = 11
# alias CURLE_FTP_ACCEPT_TIMEOUT = 12
# alias CURLE_FTP_WEIRD_PASV_REPLY = 13
# alias CURLE_FTP_WEIRD_227_FORMAT = 14
# alias CURLE_FTP_CANT_GET_HOST = 15
# alias CURLE_HTTP2 = 16
# alias CURLE_FTP_COULDNT_SET_TYPE = 17
# alias CURLE_PARTIAL_FILE = 18
# alias CURLE_FTP_COULDNT_RETR_FILE = 19
# alias CURLE_OBSOLETE20 = 20
# alias CURLE_QUOTE_ERROR = 21
# alias CURLE_HTTP_RETURNED_ERROR = 22
# alias CURLE_WRITE_ERROR = 23
# alias CURLE_OBSOLETE24 = 24
# alias CURLE_UPLOAD_FAILED = 25
# alias CURLE_READ_ERROR = 26
# alias CURLE_OUT_OF_MEMORY = 27
# alias CURLE_OPERATION_TIMEDOUT = 28
# alias CURLE_OBSOLETE29 = 29
# alias CURLE_FTP_PORT_FAILED = 30
# alias CURLE_FTP_COULDNT_USE_REST = 31
# alias CURLE_OBSOLETE32 = 32
# alias CURLE_RANGE_ERROR = 33
# alias CURLE_HTTP_POST_ERROR = 34
# alias CURLE_SSL_CONNECT_ERROR = 35
# alias CURLE_BAD_DOWNLOAD_RESUME = 36
# alias CURLE_FILE_COULDNT_READ_FILE = 37
# alias CURLE_LDAP_CANNOT_BIND = 38
# alias CURLE_LDAP_SEARCH_FAILED = 39
# alias CURLE_OBSOLETE40 = 40
# alias CURLE_FUNCTION_NOT_FOUND = 41
# alias CURLE_ABORTED_BY_CALLBACK = 42
# alias CURLE_BAD_FUNCTION_ARGUMENT = 43
# alias CURLE_OBSOLETE44 = 44
# alias CURLE_INTERFACE_FAILED = 45
# alias CURLE_OBSOLETE46 = 46
# alias CURLE_TOO_MANY_REDIRECTS = 47
# alias CURLE_UNKNOWN_OPTION = 48
# alias CURLE_SETOPT_OPTION_SYNTAX = 49
# alias CURLE_OBSOLETE50 = 50
# alias CURLE_OBSOLETE51 = 51
# alias CURLE_GOT_NOTHING = 52
# alias CURLE_SSL_ENGINE_NOTFOUND = 53
# alias CURLE_SSL_ENGINE_SETFAILED = 54
# alias CURLE_SEND_ERROR = 55
# alias CURLE_RECV_ERROR = 56
# alias CURLE_OBSOLETE57 = 57
# alias CURLE_SSL_CERTPROBLEM = 58
# alias CURLE_SSL_CIPHER = 59
# alias CURLE_PEER_FAILED_VERIFICATION = 60
# alias CURLE_BAD_CONTENT_ENCODING = 61
# alias CURLE_OBSOLETE62 = 62
# alias CURLE_FILESIZE_EXCEEDED = 63
# alias CURLE_USE_SSL_FAILED = 64
# alias CURLE_SEND_FAIL_REWIND = 65
# alias CURLE_SSL_ENGINE_INITFAILED = 66
# alias CURLE_LOGIN_DENIED = 67
# alias CURLE_TFTP_NOTFOUND = 68
# alias CURLE_TFTP_PERM = 69
# alias CURLE_REMOTE_DISK_FULL = 70
# alias CURLE_TFTP_ILLEGAL = 71
# alias CURLE_TFTP_UNKNOWNID = 72
# alias CURLE_REMOTE_FILE_EXISTS = 73
# alias CURLE_TFTP_NOSUCHUSER = 74
# alias CURLE_OBSOLETE75 = 75
# alias CURLE_OBSOLETE76 = 76
# alias CURLE_SSL_CACERT_BADFILE = 77
# alias CURLE_REMOTE_FILE_NOT_FOUND = 78
# alias CURLE_SSH = 79
# alias CURLE_SSL_SHUTDOWN_FAILED = 80
# alias CURLE_AGAIN = 81
# alias CURLE_SSL_CRL_BADFILE = 82
# alias CURLE_SSL_ISSUER_ERROR = 83
# alias CURLE_FTP_PRET_FAILED = 84
# alias CURLE_RTSP_CSEQ_ERROR = 85
# alias CURLE_RTSP_SESSION_ERROR = 86
# alias CURLE_FTP_BAD_FILE_LIST = 87
# alias CURLE_CHUNK_FAILED = 88
# alias CURLE_NO_CONNECTION_AVAILABLE = 89
# alias CURLE_SSL_PINNEDPUBKEYNOTMATCH = 90
# alias CURLE_SSL_INVALIDCERTSTATUS = 91
# alias CURLE_HTTP2_STREAM = 92
# alias CURLE_RECURSIVE_API_CALL = 93
# alias CURLE_AUTH_ERROR = 94
# alias CURLE_HTTP3 = 95
# alias CURLE_QUIC_CONNECT_ERROR = 96
# alias CURLE_PROXY = 97
# alias CURLE_SSL_CLIENTCERT = 98
# alias CURLE_UNRECOVERABLE_POLL = 99

# # CURLOPT options (commonly used ones)
# alias CURLOPT_WRITEDATA = 10001
# alias CURLOPT_URL = 10002
# alias CURLOPT_PORT = 3
# alias CURLOPT_PROXY = 10004
# alias CURLOPT_USERPWD = 10005
# alias CURLOPT_PROXYUSERPWD = 10006
# alias CURLOPT_RANGE = 10007
# alias CURLOPT_READDATA = 10009
# alias CURLOPT_ERRORBUFFER = 10010
# alias CURLOPT_WRITEFUNCTION = 20011
# alias CURLOPT_READFUNCTION = 20012
# alias CURLOPT_TIMEOUT = 13
# alias CURLOPT_INFILESIZE = 14
# alias CURLOPT_POSTFIELDS = 10015
# alias CURLOPT_REFERER = 10016
# alias CURLOPT_FTPPORT = 10017
# alias CURLOPT_USERAGENT = 10018
# alias CURLOPT_LOW_SPEED_LIMIT = 19
# alias CURLOPT_LOW_SPEED_TIME = 20
# alias CURLOPT_RESUME_FROM = 21
# alias CURLOPT_COOKIE = 10022
# alias CURLOPT_HTTPHEADER = 10023
# alias CURLOPT_HTTPPOST = 10024
# alias CURLOPT_SSLCERT = 10025
# alias CURLOPT_KEYPASSWD = 10026
# alias CURLOPT_CRLF = 27
# alias CURLOPT_QUOTE = 10028
# alias CURLOPT_HEADERDATA = 10029
# alias CURLOPT_COOKIEFILE = 10031
# alias CURLOPT_SSLVERSION = 32
# alias CURLOPT_TIMECONDITION = 33
# alias CURLOPT_TIMEVALUE = 34
# alias CURLOPT_VERBOSE = 41
# alias CURLOPT_HEADER = 42
# alias CURLOPT_NOPROGRESS = 43
# alias CURLOPT_NOBODY = 44
# alias CURLOPT_FAILONERROR = 45
# alias CURLOPT_UPLOAD = 46
# alias CURLOPT_POST = 47
# alias CURLOPT_DIRLISTONLY = 48
# alias CURLOPT_APPEND = 50
# alias CURLOPT_NETRC = 51
# alias CURLOPT_FOLLOWLOCATION = 52
# alias CURLOPT_TRANSFERTEXT = 53
# alias CURLOPT_PUT = 54
# alias CURLOPT_PROGRESSFUNCTION = 20056
# alias CURLOPT_PROGRESSDATA = 10057
# alias CURLOPT_AUTOREFERER = 58
# alias CURLOPT_PROXYPORT = 59
# alias CURLOPT_POSTFIELDSIZE = 60
# alias CURLOPT_HTTPPROXYTUNNEL = 61
# alias CURLOPT_INTERFACE = 10062
# alias CURLOPT_KRBLEVEL = 10063
# alias CURLOPT_SSL_VERIFYPEER = 64
# alias CURLOPT_CAINFO = 10065
# alias CURLOPT_MAXREDIRS = 68
# alias CURLOPT_FILETIME = 69
# alias CURLOPT_TELNETOPTIONS = 10070
# alias CURLOPT_MAXCONNECTS = 71
# alias CURLOPT_OBSOLETE72 = 72
# alias CURLOPT_FRESH_CONNECT = 74
# alias CURLOPT_FORBID_REUSE = 75
# alias CURLOPT_RANDOM_FILE = 10076
# alias CURLOPT_EGDSOCKET = 10077
# alias CURLOPT_CONNECTTIMEOUT = 78
# alias CURLOPT_HEADERFUNCTION = 20079
# alias CURLOPT_HTTPGET = 80
# alias CURLOPT_SSL_VERIFYHOST = 81
# alias CURLOPT_COOKIEJAR = 10082
# alias CURLOPT_SSL_CIPHER_LIST = 10083
# alias CURLOPT_HTTP_VERSION = 84
# alias CURLOPT_FTP_USE_EPSV = 85
# alias CURLOPT_SSLCERTTYPE = 10086
# alias CURLOPT_SSLKEY = 10087
# alias CURLOPT_SSLKEYTYPE = 10088
# alias CURLOPT_SSLENGINE = 10089
# alias CURLOPT_SSLENGINE_DEFAULT = 90
# alias CURLOPT_DNS_USE_GLOBAL_CACHE = 91
# alias CURLOPT_DNS_CACHE_TIMEOUT = 92
# alias CURLOPT_PREQUOTE = 10093
# alias CURLOPT_DEBUGFUNCTION = 20094
# alias CURLOPT_DEBUGDATA = 10095
# alias CURLOPT_COOKIESESSION = 96
# alias CURLOPT_CAPATH = 10097
# alias CURLOPT_BUFFERSIZE = 98
# alias CURLOPT_NOSIGNAL = 99
# alias CURLOPT_SHARE = 10100

# # CURLINFO options (commonly used ones)
# alias CURLINFO_EFFECTIVE_URL = 1048577
# alias CURLINFO_RESPONSE_CODE = 2097154
# alias CURLINFO_TOTAL_TIME = 3145731
# alias CURLINFO_NAMELOOKUP_TIME = 3145732
# alias CURLINFO_CONNECT_TIME = 3145733
# alias CURLINFO_PRETRANSFER_TIME = 3145734
# alias CURLINFO_SIZE_UPLOAD = 3145735
# alias CURLINFO_SIZE_DOWNLOAD = 3145736
# alias CURLINFO_SPEED_DOWNLOAD = 3145737
# alias CURLINFO_SPEED_UPLOAD = 3145738
# alias CURLINFO_HEADER_SIZE = 2097163
# alias CURLINFO_REQUEST_SIZE = 2097164
# alias CURLINFO_SSL_VERIFYRESULT = 2097165
# alias CURLINFO_FILETIME = 2097166
# alias CURLINFO_CONTENT_LENGTH_DOWNLOAD = 3145743
# alias CURLINFO_CONTENT_LENGTH_UPLOAD = 3145744
# alias CURLINFO_STARTTRANSFER_TIME = 3145745
# alias CURLINFO_CONTENT_TYPE = 1048594
# alias CURLINFO_REDIRECT_TIME = 3145747
# alias CURLINFO_REDIRECT_COUNT = 2097172
# alias CURLINFO_PRIVATE = 1048597
# alias CURLINFO_HTTP_CONNECTCODE = 2097174
# alias CURLINFO_HTTPAUTH_AVAIL = 2097175
# alias CURLINFO_PROXYAUTH_AVAIL = 2097176
# alias CURLINFO_OS_ERRNO = 2097177
# alias CURLINFO_NUM_CONNECTS = 2097178
# alias CURLINFO_SSL_ENGINES = 4194331
# alias CURLINFO_COOKIELIST = 4194332
# alias CURLINFO_LASTSOCKET = 2097181
# alias CURLINFO_FTP_ENTRY_PATH = 1048606
# alias CURLINFO_REDIRECT_URL = 1048607
# alias CURLINFO_PRIMARY_IP = 1048608
# alias CURLINFO_APPCONNECT_TIME = 3145761
# alias CURLINFO_CERTINFO = 4194338

# # HTTP version options
# alias CURL_HTTP_VERSION_NONE: c_long = 0
# alias CURL_HTTP_VERSION_1_0: c_long = 1
# alias CURL_HTTP_VERSION_1_1: c_long = 2
# alias CURL_HTTP_VERSION_2_0: c_long = 3
# alias CURL_HTTP_VERSION_2TLS: c_long = 4
# alias CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE: c_long = 5
# alias CURL_HTTP_VERSION_3: c_long = 30

# # SSL version options
# alias CURL_SSLVERSION_DEFAULT: c_long = 0
# alias CURL_SSLVERSION_TLSv1: c_long = 1
# alias CURL_SSLVERSION_SSLv2: c_long = 2
# alias CURL_SSLVERSION_SSLv3: c_long = 3
# alias CURL_SSLVERSION_TLSv1_0: c_long = 4
# alias CURL_SSLVERSION_TLSv1_1: c_long = 5
# alias CURL_SSLVERSION_TLSv1_2: c_long = 6
# alias CURL_SSLVERSION_TLSv1_3: c_long = 7

# # Global initialization flags
# alias CURL_GLOBAL_SSL = 1
# alias CURL_GLOBAL_WIN32 = 2
# alias CURL_GLOBAL_ALL = 3
# alias CURL_GLOBAL_NOTHING = 0
# alias CURL_GLOBAL_DEFAULT = 3

# # Version info type
# alias CURLVERSION_NOW = 4

# struct curl_blob:
#     """CURL blob struct for binary data transfer."""
#     var data: OpaquePointer
#     var len: c_size_t
#     var flags: c_uint

#     fn __init__(out self, data: OpaquePointer, len: c_size_t, flags: c_uint = CURL_BLOB_NOCOPY):
#         self.data = data
#         self.len = len
#         self.flags = flags

# struct curl_version_info_data:
#     """Version information structure returned by curl_version_info."""
#     var age: c_int
#     var version: UnsafePointer[c_char]
#     var version_num: c_uint
#     var host: UnsafePointer[c_char]
#     var features: c_int
#     var ssl_version: UnsafePointer[c_char]
#     var ssl_version_num: c_long
#     var libz_version: UnsafePointer[c_char]
#     var protocols: UnsafePointer[UnsafePointer[c_char]]

# @fieldwise_init
# struct va_list:
#     var ptr: UnsafePointer[c_char]

# @fieldwise_init
# struct curl(Copyable, Movable):
#     """CURL Easy interface C API binding struct."""

#     var lib: DLHandle

#     fn __init__(out self):
#         """Initialize the SQLite3 binding by loading the dynamic library.

#         This constructor attempts to load the SQLite3 shared library from
#         the expected location. If loading fails, the program will abort.

#         Aborts if the libcurl library cannot be loaded.
#         """
#         var path = String(env_get_string["LIBCURL_LIB_PATH", ""]())

#         # If the program was not compiled with a specific path, then check if it was set via environment variable.
#         if path == "":
#             path = os.getenv("LIBCURL_LIB_PATH")

#         try:
#             # If its not explicitly set, then assume the program is running from the root of the project.
#             if path == "":
#                 @parameter
#                 if CompilationTarget.is_macos():
#                     path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.dylib")
#                 else:
#                     path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.so")

#             if not pathlib.Path(path).exists():
#                 os.abort(
#                     "The path to the curl library is not set. Set the path as either a compilation variable with `-D"
#                     " LIBCURL_LIB_PATH=/path/to/libcurl.dylib` or LIBCURL_LIB_PATH=/path/to/libcurl.so`."
#                     " Or set the `LIBCURL_LIB_PATH` environment variable to the path to the curl library like"
#                     " `LIBCURL_LIB_PATH=/path/to/libcurl.dylib` or `LIBCURL_LIB_PATH=/path/to/libcurl.so`."
#                     " The default path is `.pixi/envs/default/lib/libcurl.dylib (or .so)`, but this"
#                     " error indicates that the library did not exist at that location."
#                 )
#             self.lib = ffi.DLHandle(path, ffi.RTLD.LAZY)
#         except e:
#             self.lib = os.abort[ffi.DLHandle](String("Failed to load the curl library: ", e))

#     # Global libcurl functions
#     fn curl_global_init(self, flags: c_long) -> CURLcode:
#         """Global libcurl initialization."""
#         return self.lib.get_function[fn (c_long) -> CURLcode]("curl_global_init")(flags)

#     fn curl_global_cleanup(self) -> NoneType:
#         """Global libcurl cleanup."""
#         return self.lib.get_function[fn () -> NoneType]("curl_global_cleanup")()

#     fn curl_version(self) -> UnsafePointer[c_char]:
#         """Return the version string of libcurl."""
#         return self.lib.get_function[fn () -> UnsafePointer[c_char]]("curl_version")()

#     fn curl_version_info(self, type: c_int) -> UnsafePointer[curl_version_info_data]:
#         """Return detailed version information about libcurl."""
#         return self.lib.get_function[fn (c_int) -> UnsafePointer[curl_version_info_data]]("curl_version_info")(type)

#     # Easy interface functions
#     fn curl_easy_init(self) -> CURL:
#         """Start a libcurl easy session."""
#         return self.lib.get_function[fn () -> CURL]("curl_easy_init")()

#     fn curl_easy_setopt(self, curl: CURL, option: CURLoption, parameter: OpaquePointer) -> CURLcode:
#         """Set options for a curl easy handle."""
#         return self.lib.get_function[fn (CURL, CURLoption, OpaquePointer) -> CURLcode]("curl_easy_setopt")(
#             curl, option, parameter
#         )

#     fn _curl_easy_setopt[type: AnyType](self, curl: CURL, option: CURLoption, args: type) -> CURLcode:
#         """Set options for a curl easy handle."""
#         # var loaded_pack = args.get_loaded_kgen_pack()
#         return self.lib.get_function[
#             fn (curl: CURL, option: CURLoption, args: va_list) -> CURLcode
#         ]("curl_easy_setopt")(
#             curl, option, va_list(UnsafePointer(to=args).bitcast[c_char]())
#         )

#     fn curl_easy_setopt_string(self, curl: CURL, option: CURLoption, mut parameter: String) -> CURLcode:
#         """Set a string option for a curl easy handle."""
#         # return __mlir_op.`pop.external_call`[
#         #     func = "curl_easy_setopt".value,
#         #     variadicType = __mlir_attr[
#         #         `(`,
#         #         `!kgen.pointer<none>,`,
#         #         `!pop.scalar<si32>,`,
#         #         `!kgen.pointer<scalar<si8>>`,
#         #         `) -> !pop.scalar<si32>`,
#         #     ],
#         #     _type=Int32,
#         # ](
#         #     curl, option, parameter.unsafe_cstr_ptr()
#         # )

#         return self._curl_easy_setopt(curl, option, parameter.unsafe_cstr_ptr())

#         # var args = UnsafePointer(to=parameter.unsafe_cstr_ptr())
#         # return self.lib.get_function[
#         #     fn (CURL, CURLoption, UnsafePointer[c_char, mut=False]) -> CURLcode
#         # ]("curl_easy_setopt")(
#         #     curl, option, parameter.unsafe_cstr_ptr()
#         # )
#         # return self.lib.get_function[
#         #     fn (CURL, CURLoption, UnsafePointer[c_char, mut=False]) -> CURLcode
#         # ]("curl_easy_setopt")(
#         #     curl, option, parameter.unsafe_cstr_ptr()
#         # )

#     fn curl_easy_setopt_long(self, curl: CURL, option: CURLoption, parameter: c_long) -> CURLcode:
#         """Set a long/integer option for a curl easy handle."""
#         return self._curl_easy_setopt(curl, option, parameter)
#         # return self.lib.get_function[fn (CURL, CURLoption, c_long) -> CURLcode]("curl_easy_setopt")(
#         #     curl, option, parameter
#         # )

#     fn curl_easy_setopt_write_function(self, curl: CURL, option: CURLoption, parameter: curl_write_callback) -> CURLcode:
#         """Set options for a curl easy handle."""
#         return self._curl_easy_setopt(curl, option, parameter)
#         # return self.lib.get_function[fn (CURL, CURLoption, curl_write_callback) -> CURLcode]("curl_easy_setopt")(
#         #     curl, option, parameter
#         # )

#     fn curl_easy_perform(self, curl: CURL) -> CURLcode:
#         """Perform a blocking file transfer."""
#         return self.lib.get_function[fn (CURL) -> CURLcode]("curl_easy_perform")(curl)

#     fn curl_easy_cleanup(self, curl: CURL) -> NoneType:
#         """End a libcurl easy handle."""
#         return self.lib.get_function[fn (CURL) -> NoneType]("curl_easy_cleanup")(curl)

#     fn curl_easy_getinfo(self, curl: CURL, info: CURLINFO, parameter: OpaquePointer) -> CURLcode:
#         """Extract information from a curl handle."""
#         return self.lib.get_function[fn (CURL, CURLINFO, OpaquePointer) -> CURLcode]("curl_easy_getinfo")(
#             curl, info, parameter
#         )

#     fn curl_easy_getinfo_long(self, curl: CURL, info: CURLINFO, parameter: UnsafePointer[c_long]) -> CURLcode:
#         """Extract information from a curl handle."""
#         return self.lib.get_function[fn (CURL, CURLINFO, UnsafePointer[c_long]) -> CURLcode]("curl_easy_getinfo")(
#             curl, info, parameter
#         )

#     fn curl_easy_duphandle(self, curl: CURL) -> CURL:
#         """Clone a libcurl session handle."""
#         return self.lib.get_function[fn (CURL) -> CURL]("curl_easy_duphandle")(curl)

#     fn curl_easy_reset(self, curl: CURL) -> NoneType:
#         """Reset all options of a libcurl session handle."""
#         return self.lib.get_function[fn (CURL) -> NoneType]("curl_easy_reset")(curl)

#     fn curl_easy_recv(self, curl: CURL, buffer: OpaquePointer, buflen: c_size_t, n: UnsafePointer[c_size_t]) -> CURLcode:
#         """Receives raw data on an "easy" connection."""
#         return self.lib.get_function[fn (CURL, OpaquePointer, c_size_t, UnsafePointer[c_size_t]) -> CURLcode]("curl_easy_recv")(
#             curl, buffer, buflen, n
#         )

#     fn curl_easy_send(self, curl: CURL, buffer: OpaquePointer, buflen: c_size_t, n: UnsafePointer[c_size_t]) -> CURLcode:
#         """Sends raw data over an "easy" connection."""
#         return self.lib.get_function[fn (CURL, OpaquePointer, c_size_t, UnsafePointer[c_size_t]) -> CURLcode]("curl_easy_send")(
#             curl, buffer, buflen, n
#         )

#     fn curl_easy_upkeep(self, curl: CURL) -> CURLcode:
#         """Perform any connection upkeep checks."""
#         return self.lib.get_function[fn (CURL) -> CURLcode]("curl_easy_upkeep")(curl)

#     fn curl_easy_strerror(self, code: CURLcode) -> UnsafePointer[c_char]:
#         """Return string describing error code."""
#         return self.lib.get_function[fn (CURLcode) -> UnsafePointer[c_char]]("curl_easy_strerror")(code)

#     fn curl_easy_getdate(self, datestr: UnsafePointer[c_char, mut=False], unused: UnsafePointer[c_long]) -> c_long:
#         """Parse a date string and return it as seconds since epoch."""
#         return self.lib.get_function[fn (UnsafePointer[c_char, mut=False], UnsafePointer[c_long]) -> c_long]("curl_getdate")(
#             datestr, unused
#         )

#     fn curl_easy_escape(self, curl: CURL, string: UnsafePointer[c_char, mut=False], length: c_int) -> UnsafePointer[c_char]:
#         """URL encode a string."""
#         return self.lib.get_function[fn (CURL, UnsafePointer[c_char, mut=False], c_int) -> UnsafePointer[c_char]]("curl_easy_escape")(
#             curl, string, length
#         )

#     fn curl_easy_unescape(self, curl: CURL, string: UnsafePointer[c_char, mut=False], length: c_int, outlength: UnsafePointer[c_int]) -> UnsafePointer[c_char]:
#         """URL decode a string."""
#         return self.lib.get_function[fn (CURL, UnsafePointer[c_char, mut=False], c_int, UnsafePointer[c_int]) -> UnsafePointer[c_char]]("curl_easy_unescape")(
#             curl, string, length, outlength
#         )

#     fn curl_free(self, ptr: OpaquePointer) -> NoneType:
#         """Free memory allocated by libcurl."""
#         return self.lib.get_function[fn (OpaquePointer) -> NoneType]("curl_free")(ptr)

#     # String list functions
#     fn curl_slist_append(self, list: curl_slist, string: UnsafePointer[c_char, mut=False]) -> curl_slist:
#         """Append a string to a curl string list."""
#         return self.lib.get_function[fn (curl_slist, UnsafePointer[c_char, mut=False]) -> curl_slist]("curl_slist_append")(
#             list, string
#         )

#     fn curl_slist_free_all(self, list: curl_slist) -> NoneType:
#         """Free an entire curl string list."""
#         return self.lib.get_function[fn (curl_slist) -> NoneType]("curl_slist_free_all")(list)

#     # Multi interface functions
#     fn curl_multi_init(self) -> CURLM:
#         """Initialize a multi session."""
#         return self.lib.get_function[fn () -> CURLM]("curl_multi_init")()

#     fn curl_multi_add_handle(self, multi_handle: CURLM, curl_handle: CURL) -> CURLMcode:
#         """Add an easy handle to a multi session."""
#         return self.lib.get_function[fn (CURLM, CURL) -> CURLMcode]("curl_multi_add_handle")(multi_handle, curl_handle)

#     fn curl_multi_remove_handle(self, multi_handle: CURLM, curl_handle: CURL) -> CURLMcode:
#         """Remove an easy handle from a multi session."""
#         return self.lib.get_function[fn (CURLM, CURL) -> CURLMcode]("curl_multi_remove_handle")(multi_handle, curl_handle)

#     fn curl_multi_perform(self, multi_handle: CURLM, running_handles: UnsafePointer[c_int]) -> CURLMcode:
#         """Perform transfers on all added handles."""
#         return self.lib.get_function[fn (CURLM, UnsafePointer[c_int]) -> CURLMcode]("curl_multi_perform")(
#             multi_handle, running_handles
#         )

#     fn curl_multi_cleanup(self, multi_handle: CURLM) -> CURLMcode:
#         """Clean up a multi session."""
#         return self.lib.get_function[fn (CURLM) -> CURLMcode]("curl_multi_cleanup")(multi_handle)

#     fn curl_multi_info_read(self, multi_handle: CURLM, msgs_in_queue: UnsafePointer[c_int]) -> CURLMsg:
#         """Read info from individual transfers."""
#         return self.lib.get_function[fn (CURLM, UnsafePointer[c_int]) -> CURLMsg]("curl_multi_info_read")(
#             multi_handle, msgs_in_queue
#         )

#     fn curl_multi_strerror(self, code: CURLMcode) -> UnsafePointer[c_char]:
#         """Return string describing multi error code."""
#         return self.lib.get_function[fn (CURLMcode) -> UnsafePointer[c_char]]("curl_multi_strerror")(code)

#     # Utility methods for common operations
#     fn get_error_message(self, code: CURLcode) -> String:
#         """Get a human-readable error message for a curl error code."""
#         if code == CURLE_OK:
#             return "No error"
#         elif code == CURLE_UNSUPPORTED_PROTOCOL:
#             return "Unsupported protocol"
#         elif code == CURLE_FAILED_INIT:
#             return "Failed initialization"
#         elif code == CURLE_URL_MALFORMAT:
#             return "URL malformed"
#         elif code == CURLE_COULDNT_RESOLVE_PROXY:
#             return "Couldn't resolve proxy"
#         elif code == CURLE_COULDNT_RESOLVE_HOST:
#             return "Couldn't resolve host"
#         elif code == CURLE_COULDNT_CONNECT:
#             return "Failed to connect to host"
#         elif code == CURLE_OPERATION_TIMEDOUT:
#             return "Operation timed out"
#         elif code == CURLE_SSL_CONNECT_ERROR:
#             return "SSL connection error"
#         elif code == CURLE_HTTP_RETURNED_ERROR:
#             return "HTTP error returned"
#         elif code == CURLE_WRITE_ERROR:
#             return "Write error"
#         elif code == CURLE_READ_ERROR:
#             return "Read error"
#         elif code == CURLE_OUT_OF_MEMORY:
#             return "Out of memory"
#         elif code == CURLE_PEER_FAILED_VERIFICATION:
#             return "SSL peer certificate error"
#         elif code == CURLE_TOO_MANY_REDIRECTS:
#             return "Too many redirects"
#         else:
#             return "Unknown curl error: " + String(code)

#     fn is_success(self, code: CURLcode) -> Bool:
#         """Check if a curl operation was successful."""
#         return code == CURLE_OK
