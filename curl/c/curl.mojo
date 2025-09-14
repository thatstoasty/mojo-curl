from os import abort, getenv, setenv
from pathlib import Path
from sys import ffi
from sys.ffi import DLHandle, c_char, c_int, c_uint, c_size_t, c_long

from memory import OpaquePointer, UnsafePointer

# Type aliases for curl
alias CURL = OpaquePointer
alias CURLMcode = c_int
alias CURLM = OpaquePointer
alias CURLMsg = OpaquePointer
alias curl_slist = OpaquePointer

alias curl_socket_t = c_int
alias CURL_SOCKET_BAD = -1

alias curl_off_t = c_long

# Callback function types
alias curl_write_callback = fn (UnsafePointer[c_char], c_size_t, c_size_t, UnsafePointer[NoneType]) -> c_size_t
alias curl_read_callback = fn (UnsafePointer[c_char], c_size_t, c_size_t, OpaquePointer) -> c_size_t
alias curl_progress_callback = fn (OpaquePointer, Float64, Float64, Float64, Float64) -> c_int
alias curl_debug_callback = fn (CURL, c_int, UnsafePointer[c_char], c_size_t, OpaquePointer) -> c_int
alias curl_xferinfo_callback = fn (OpaquePointer, curl_off_t, curl_off_t, curl_off_t, curl_off_t) -> c_int
"""This is the CURLOPT_XFERINFOFUNCTION callback prototype. It was introduced 
in 7.32.0, avoids the use of floating point numbers and provides more
detailed information."""

struct curl_blob(Movable):
    """CURL blob struct for binary data transfer.
    
    This struct represents binary data that can be passed to curl,
    with control over whether curl should copy the data or use it directly.
    """
    var data: OpaquePointer
    var len: c_size_t
    var flags: c_uint

    fn __init__(out self, data: OpaquePointer, len: c_size_t, flags: c_uint = CURL_BLOB_NOCOPY):
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
@fieldwise_init
@register_passable("trivial")
struct CURLcode(Movable, ExplicitlyCopyable):
    var value: c_int
    alias CURLE_OK: Self = 0
    alias CURLE_UNSUPPORTED_PROTOCOL: Self = 1
    alias CURLE_FAILED_INIT: Self = 2
    alias CURLE_URL_MALFORMAT: Self = 3
    alias CURLE_NOT_BUILT_IN: Self = 4
    alias CURLE_COULDNT_RESOLVE_PROXY: Self = 5
    alias CURLE_COULDNT_RESOLVE_HOST: Self = 6
    alias CURLE_COULDNT_CONNECT: Self = 7
    alias CURLE_WEIRD_SERVER_REPLY: Self = 8
    alias CURLE_REMOTE_ACCESS_DENIED: Self = 9
    alias CURLE_FTP_ACCEPT_FAILED: Self = 10
    alias CURLE_FTP_WEIRD_PASS_REPLY: Self = 11
    alias CURLE_FTP_ACCEPT_TIMEOUT: Self = 12
    alias CURLE_FTP_WEIRD_PASV_REPLY: Self = 13
    alias CURLE_FTP_WEIRD_227_FORMAT: Self = 14
    alias CURLE_FTP_CANT_GET_HOST: Self = 15
    alias CURLE_HTTP2: Self = 16
    alias CURLE_FTP_COULDNT_SET_TYPE: Self = 17
    alias CURLE_PARTIAL_FILE: Self = 18
    alias CURLE_FTP_COULDNT_RETR_FILE: Self = 19
    alias CURLE_OBSOLETE20: Self = 20
    alias CURLE_QUOTE_ERROR: Self = 21
    alias CURLE_HTTP_RETURNED_ERROR: Self = 22
    alias CURLE_WRITE_ERROR: Self = 23
    alias CURLE_OBSOLETE24: Self = 24
    alias CURLE_UPLOAD_FAILED: Self = 25
    alias CURLE_READ_ERROR: Self = 26
    alias CURLE_OUT_OF_MEMORY: Self = 27
    alias CURLE_OPERATION_TIMEDOUT: Self = 28
    alias CURLE_OBSOLETE29: Self = 29
    alias CURLE_FTP_PORT_FAILED: Self = 30
    alias CURLE_FTP_COULDNT_USE_REST: Self = 31
    alias CURLE_OBSOLETE32: Self = 32
    alias CURLE_RANGE_ERROR: Self = 33
    alias CURLE_HTTP_POST_ERROR: Self = 34
    alias CURLE_SSL_CONNECT_ERROR: Self = 35
    alias CURLE_BAD_DOWNLOAD_RESUME: Self = 36
    alias CURLE_FILE_COULDNT_READ_FILE: Self = 37
    alias CURLE_LDAP_CANNOT_BIND: Self = 38
    alias CURLE_LDAP_SEARCH_FAILED: Self = 39
    alias CURLE_OBSOLETE40: Self = 40
    alias CURLE_FUNCTION_NOT_FOUND: Self = 41
    alias CURLE_ABORTED_BY_CALLBACK: Self = 42
    alias CURLE_BAD_FUNCTION_ARGUMENT: Self = 43
    alias CURLE_OBSOLETE44: Self = 44
    alias CURLE_INTERFACE_FAILED: Self = 45
    alias CURLE_OBSOLETE46: Self = 46
    alias CURLE_TOO_MANY_REDIRECTS: Self = 47
    alias CURLE_UNKNOWN_OPTION: Self = 48
    alias CURLE_SETOPT_OPTION_SYNTAX: Self = 49
    alias CURLE_OBSOLETE50: Self = 50
    alias CURLE_OBSOLETE51: Self = 51
    alias CURLE_GOT_NOTHING: Self = 52
    alias CURLE_SSL_ENGINE_NOTFOUND: Self = 53
    alias CURLE_SSL_ENGINE_SETFAILED: Self = 54
    alias CURLE_SEND_ERROR: Self = 55
    alias CURLE_RECV_ERROR: Self = 56
    alias CURLE_OBSOLETE57: Self = 57
    alias CURLE_SSL_CERTPROBLEM: Self = 58
    alias CURLE_SSL_CIPHER: Self = 59
    alias CURLE_PEER_FAILED_VERIFICATION: Self = 60
    alias CURLE_BAD_CONTENT_ENCODING: Self = 61
    alias CURLE_OBSOLETE62: Self = 62
    alias CURLE_FILESIZE_EXCEEDED: Self = 63
    alias CURLE_USE_SSL_FAILED: Self = 64
    alias CURLE_SEND_FAIL_REWIND: Self = 65
    alias CURLE_SSL_ENGINE_INITFAILED: Self = 66
    alias CURLE_LOGIN_DENIED: Self = 67
    alias CURLE_TFTP_NOTFOUND: Self = 68
    alias CURLE_TFTP_PERM: Self = 69
    alias CURLE_REMOTE_DISK_FULL: Self = 70
    alias CURLE_TFTP_ILLEGAL: Self = 71
    alias CURLE_TFTP_UNKNOWNID: Self = 72
    alias CURLE_REMOTE_FILE_EXISTS: Self = 73
    alias CURLE_TFTP_NOSUCHUSER: Self = 74
    alias CURLE_OBSOLETE75: Self = 75
    alias CURLE_OBSOLETE76: Self = 76
    alias CURLE_SSL_CACERT_BADFILE: Self = 77
    alias CURLE_REMOTE_FILE_NOT_FOUND: Self = 78
    alias CURLE_SSH: Self = 79
    alias CURLE_SSL_SHUTDOWN_FAILED: Self = 80
    alias CURLE_AGAIN: Self = 81
    alias CURLE_SSL_CRL_BADFILE: Self = 82
    alias CURLE_SSL_ISSUER_ERROR: Self = 83
    alias CURLE_FTP_PRET_FAILED: Self = 84
    alias CURLE_RTSP_CSEQ_ERROR: Self = 85
    alias CURLE_RTSP_SESSION_ERROR: Self = 86
    alias CURLE_FTP_BAD_FILE_LIST: Self = 87
    alias CURLE_CHUNK_FAILED: Self = 88
    alias CURLE_NO_CONNECTION_AVAILABLE: Self = 89
    alias CURLE_SSL_PINNEDPUBKEYNOTMATCH: Self = 90
    alias CURLE_SSL_INVALIDCERTSTATUS: Self = 91
    alias CURLE_HTTP2_STREAM: Self = 92
    alias CURLE_RECURSIVE_API_CALL: Self = 93
    alias CURLE_AUTH_ERROR: Self = 94
    alias CURLE_HTTP3: Self = 95
    alias CURLE_QUIC_CONNECT_ERROR: Self = 96
    alias CURLE_PROXY: Self = 97
    alias CURLE_SSL_CLIENTCERT: Self = 98
    alias CURLE_UNRECOVERABLE_POLL: Self = 99
    alias CURLE_SSL_PEER_CERTIFICATE: Self = 60  # Alias for CURLE_PEER_FAILED_VERIFICATION

    @implicit
    fn __init__(out self, value: Int):
        self.value = value



# CURLOPT options (commonly used ones)
@register_passable("trivial")
struct CURLOPT(Movable, Copyable):
    var value: c_int

    alias CURLOPTTYPE_LONG: Self = 0
    alias CURLOPTTYPE_OBJECTPOINT: Self = 10_000
    alias CURLOPTTYPE_FUNCTIONPOINT: Self = 20_000
    alias CURLOPTTYPE_OFF_T: Self = 30_000
    alias CURLOPTTYPE_BLOB: Self = 40_000
    alias CURLOPTTYPE_VALUES: Self = Self.CURLOPTTYPE_LONG.value

    alias CURLOPT_WRITEDATA: Self = 10001
    alias CURLOPT_FILE: Self = Self.CURLOPTTYPE_OBJECTPOINT.value + 1
    alias CURLOPT_URL: Self = Self.CURLOPTTYPE_OBJECTPOINT.value + 2
    alias CURLOPT_PORT: Self = 3
    alias CURLOPT_PROXY: Self = 10004
    alias CURLOPT_USERPWD: Self = 10005
    alias CURLOPT_PROXYUSERPWD: Self = 10006
    alias CURLOPT_RANGE: Self = 10007
    alias CURLOPT_READDATA: Self = 10009
    alias CURLOPT_ERRORBUFFER: Self = 10010
    alias CURLOPT_WRITEFUNCTION: Self = 20011
    alias CURLOPT_READFUNCTION: Self = 20012
    alias CURLOPT_TIMEOUT: Self = 13
    alias CURLOPT_INFILESIZE: Self = 14
    alias CURLOPT_POSTFIELDS: Self = 10015
    alias CURLOPT_REFERER: Self = 10016
    alias CURLOPT_FTPPORT: Self = 10017
    alias CURLOPT_USERAGENT: Self = 10018
    alias CURLOPT_LOW_SPEED_LIMIT: Self = 19
    alias CURLOPT_LOW_SPEED_TIME: Self = 20
    alias CURLOPT_RESUME_FROM: Self = 21
    alias CURLOPT_COOKIE: Self = 10022
    alias CURLOPT_HTTPHEADER: Self = 10023
    alias CURLOPT_HTTPPOST: Self = 10024
    alias CURLOPT_SSLCERT: Self = 10025
    alias CURLOPT_KEYPASSWD: Self = 10026
    alias CURLOPT_CRLF: Self = 27
    alias CURLOPT_QUOTE: Self = 10028
    alias CURLOPT_HEADERDATA: Self = 10029
    alias CURLOPT_COOKIEFILE: Self = 10031
    alias CURLOPT_SSLVERSION: Self = 32
    alias CURLOPT_TIMECONDITION: Self = 33
    alias CURLOPT_TIMEVALUE: Self = 34
    alias CURLOPT_VERBOSE: Self = 41
    alias CURLOPT_HEADER: Self = 42
    alias CURLOPT_NOPROGRESS: Self = 43
    alias CURLOPT_NOBODY: Self = 44
    alias CURLOPT_FAILONERROR: Self = 45
    alias CURLOPT_UPLOAD: Self = 46
    alias CURLOPT_POST: Self = 47
    alias CURLOPT_DIRLISTONLY: Self = 48
    alias CURLOPT_APPEND: Self = 50
    alias CURLOPT_NETRC: Self = 51
    alias CURLOPT_FOLLOWLOCATION: Self = 52
    alias CURLOPT_TRANSFERTEXT: Self = 53
    alias CURLOPT_PUT: Self = 54
    alias CURLOPT_PROGRESSFUNCTION: Self = 20056
    alias CURLOPT_PROGRESSDATA: Self = 10057
    alias CURLOPT_AUTOREFERER: Self = 58
    alias CURLOPT_PROXYPORT: Self = 59
    alias CURLOPT_POSTFIELDSIZE: Self = 60
    alias CURLOPT_HTTPPROXYTUNNEL: Self = 61
    alias CURLOPT_INTERFACE: Self = 10062
    alias CURLOPT_KRBLEVEL: Self = 10063
    alias CURLOPT_SSL_VERIFYPEER: Self = 64
    alias CURLOPT_CAINFO: Self = 10065
    alias CURLOPT_MAXREDIRS: Self = 68
    alias CURLOPT_FILETIME: Self = 69
    alias CURLOPT_TELNETOPTIONS: Self = 10070
    alias CURLOPT_MAXCONNECTS: Self = 71
    alias CURLOPT_OBSOLETE72: Self = 72
    alias CURLOPT_FRESH_CONNECT: Self = 74
    alias CURLOPT_FORBID_REUSE: Self = 75
    alias CURLOPT_RANDOM_FILE: Self = 10076
    alias CURLOPT_EGDSOCKET: Self = 10077
    alias CURLOPT_CONNECTTIMEOUT: Self = 78
    alias CURLOPT_HEADERFUNCTION: Self = 20079
    alias CURLOPT_HTTPGET: Self = 80
    alias CURLOPT_SSL_VERIFYHOST: Self = 81
    alias CURLOPT_COOKIEJAR: Self = 10082
    alias CURLOPT_SSL_CIPHER_LIST: Self = 10083
    alias CURLOPT_HTTP_VERSION: Self = 84
    alias CURLOPT_FTP_USE_EPSV: Self = 85
    alias CURLOPT_SSLCERTTYPE: Self = 10086
    alias CURLOPT_SSLKEY: Self = 10087
    alias CURLOPT_SSLKEYTYPE: Self = 10088
    alias CURLOPT_SSLENGINE: Self = 10089
    alias CURLOPT_SSLENGINE_DEFAULT: Self = 90
    alias CURLOPT_DNS_USE_GLOBAL_CACHE: Self = 91
    alias CURLOPT_DNS_CACHE_TIMEOUT: Self = 92
    alias CURLOPT_PREQUOTE: Self = 10093
    alias CURLOPT_DEBUGFUNCTION: Self = 20094
    alias CURLOPT_DEBUGDATA: Self = 10095
    alias CURLOPT_COOKIESESSION: Self = 96
    alias CURLOPT_CAPATH: Self = 10097
    alias CURLOPT_BUFFERSIZE: Self = 98
    alias CURLOPT_NOSIGNAL: Self = 99
    alias CURLOPT_SHARE: Self = 10100

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    @implicit
    fn __init__(out self, value: c_int):
        self.value = value

# CURLINFO options (commonly used ones)
@fieldwise_init
@register_passable("trivial")
struct CURLINFO(Movable, ExplicitlyCopyable):
    var value: c_int
    alias CURLINFO_STRING: Self = 0x100000
    alias CURLINFO_LONG: Self = 0x200000
    alias CURLINFO_DOUBLE: Self = 0x300000
    alias CURLINFO_SLIST: Self = 0x400000
    alias CURLINFO_PTR: Self = 0x400000
    alias CURLINFO_SOCKET: Self = 0x500000
    alias CURLINFO_OFF_T: Self = 0x600000
    alias CURLINFO_MASK: Self = 0x0fffff
    alias CURLINFO_TYPEMASK: Self = 0xf00000
    alias CURLINFO_EFFECTIVE_URL: Self = Int(Self.CURLINFO_STRING.value + 1)
    alias CURLINFO_RESPONSE_CODE: Self = 2097154
    alias CURLINFO_TOTAL_TIME: Self = 3145731
    alias CURLINFO_NAMELOOKUP_TIME: Self = 3145732
    alias CURLINFO_CONNECT_TIME: Self = 3145733
    alias CURLINFO_PRETRANSFER_TIME: Self = 3145734
    alias CURLINFO_SIZE_UPLOAD: Self = 3145735
    alias CURLINFO_SIZE_DOWNLOAD: Self = 3145736
    alias CURLINFO_SPEED_DOWNLOAD: Self = 3145737
    alias CURLINFO_SPEED_UPLOAD: Self = 3145738
    alias CURLINFO_HEADER_SIZE: Self = 2097163
    alias CURLINFO_REQUEST_SIZE: Self = 2097164
    alias CURLINFO_SSL_VERIFYRESULT: Self = 2097165
    alias CURLINFO_FILETIME: Self = 2097166
    alias CURLINFO_CONTENT_LENGTH_DOWNLOAD: Self = 3145743
    alias CURLINFO_CONTENT_LENGTH_UPLOAD: Self = 3145744
    alias CURLINFO_STARTTRANSFER_TIME: Self = 3145745
    alias CURLINFO_CONTENT_TYPE: Self = 1048594
    alias CURLINFO_REDIRECT_TIME: Self = 3145747
    alias CURLINFO_REDIRECT_COUNT: Self = 2097172
    alias CURLINFO_PRIVATE: Self = 1048597
    alias CURLINFO_HTTP_CONNECTCODE: Self = 2097174
    alias CURLINFO_HTTPAUTH_AVAIL: Self = 2097175
    alias CURLINFO_PROXYAUTH_AVAIL: Self = 2097176
    alias CURLINFO_OS_ERRNO: Self = 2097177
    alias CURLINFO_NUM_CONNECTS: Self = 2097178
    alias CURLINFO_SSL_ENGINES: Self = 4194331
    alias CURLINFO_COOKIELIST: Self = 4194332
    alias CURLINFO_LASTSOCKET: Self = 2097181
    alias CURLINFO_FTP_ENTRY_PATH: Self = 1048606
    alias CURLINFO_REDIRECT_URL: Self = 1048607
    alias CURLINFO_PRIMARY_IP: Self = 1048608
    alias CURLINFO_APPCONNECT_TIME: Self = 3145761
    alias CURLINFO_CERTINFO: Self = 4194338

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

# HTTP version options
@fieldwise_init
@register_passable("trivial")
struct CURL_HTTP_VERSION(Movable, ExplicitlyCopyable):
    var value: c_int
    alias CURL_HTTP_VERSION_NONE: Self = 0
    alias CURL_HTTP_VERSION_1_0: Self = 1
    alias CURL_HTTP_VERSION_1_1: Self = 2
    alias CURL_HTTP_VERSION_2_0: Self = 3
    alias CURL_HTTP_VERSION_2TLS: Self = 4
    alias CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE: Self = 5
    alias CURL_HTTP_VERSION_3: Self = 30

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

# SSL version options
@fieldwise_init
@register_passable("trivial")
struct CURL_SSLVERSION(Movable, ExplicitlyCopyable):
    var value: c_int
    alias CURL_SSLVERSION_DEFAULT: Self = 0
    alias CURL_SSLVERSION_TLSv1: Self = 1
    alias CURL_SSLVERSION_SSLv2: Self = 2
    alias CURL_SSLVERSION_SSLv3: Self = 3
    alias CURL_SSLVERSION_TLSv1_0: Self = 4
    alias CURL_SSLVERSION_TLSv1_1: Self = 5
    alias CURL_SSLVERSION_TLSv1_2: Self = 6
    alias CURL_SSLVERSION_TLSv1_3: Self = 7

    @implicit
    fn __init__(out self, value: Int):
        self.value = value


struct curl_version_info_data:
    """Version information structure returned by curl_version_info."""
    var age: c_int
    var version: UnsafePointer[c_char]
    var version_num: c_uint
    var host: UnsafePointer[c_char]
    var features: c_int
    var ssl_version: UnsafePointer[c_char]
    var ssl_version_num: c_long
    var libz_version: UnsafePointer[c_char]
    var protocols: UnsafePointer[UnsafePointer[c_char]]


struct curl_ssl_backend:
    """CURL SSL backend information structure.
    
    This struct represents information about a specific SSL backend used by curl.
    """
    var value: Int

    alias NONE: Self = 0
    alias OPENSSL: Self = 1
    alias AWSLC: Self = 1
    alias BORINGSSL: Self = 1
    alias LIBRESSL: Self = 1
    alias GNUTLS: Self = 2
    alias NSS: Self = 3
    alias OBSOLETE4: Self = 4
    alias GSKIT: Self = 5
    alias POLARSSL: Self = 6
    alias WOLFSSL: Self = 7
    alias CYASSL: Self = 7
    alias SCHANNEL: Self = 8
    alias SECURETRANSPORT: Self = 9
    alias DARWINSSL: Self = 9
    alias AXTLS: Self = 10
    alias MBEDTLS: Self = 11
    alias MESALINK: Self = 12
    alias BEARSSL: Self = 13
    alias RUSTLS: Self = 14

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

alias CURLFOLLOW_ALL: c_long = 1
"""bits for the CURLOPT_FOLLOWLOCATION option"""

alias CURLFOLLOW_OBEYCODE: c_long = 2
"""Do not use the custom method in the follow-up request if the HTTP code instructs so (301, 302, 303)."""

alias CURLFOLLOW_FIRSTONLY: c_long = 3
"""Only use the custom method in the first request, always reset in the next"""

struct curl_httppost():
    var next: UnsafePointer[curl_httppost]
    """Next entry in the list."""
    var name: UnsafePointer[c_char]
    """Pointer to allocated name."""
    var namelength: c_long
    """Length of name length."""
    var contents: UnsafePointer[c_char]
    """Pointer to allocated data contents."""
    var contents_length: c_long
    """Length of contents field, see also CURL_HTTPPOST_LARGE."""
    var buffer: UnsafePointer[c_char]
    """Pointer to allocated buffer contents."""
    var bufferlength: c_long
    """Length of buffer field."""
    var content_type: UnsafePointer[c_char]
    """Content-Type."""
    var content_header: UnsafePointer[curl_slist]
    """List of extra headers for this form."""
    var more: UnsafePointer[curl_httppost]
    """If one field name has more than one file, this link should link to following files."""
    var flags: c_long
    """As defined below."""
    var show_file_name: UnsafePointer[c_char]
    """The filename to show. If not set, the actual filename will be used (if this is a file part)."""
    var user_ptr: OpaquePointer
    """Custom user pointer used for HTTPPOST_CALLBACK posts."""
    var contentlen: curl_off_t
    """Alternative length of contents field. Used if CURL_HTTPPOST_LARGE is set. Added in 7.46.0."""


alias CURL_HTTPPOST_FILENAME = (1<<0)
"""specified content is a filename."""
alias CURL_HTTPPOST_READFILE = (1<<1)
"""specified content is a filename."""
alias CURL_HTTPPOST_PTRNAME = (1<<2)
"""name is only stored pointer do not free in formfree."""
alias CURL_HTTPPOST_PTRCONTENTS = (1<<3)
"""contents is only stored pointer do not free in formfree."""
alias CURL_HTTPPOST_BUFFER = (1<<4)
"""upload file from buffer."""
alias CURL_HTTPPOST_PTRBUFFER = (1<<5)
"""upload file from pointer contents."""
alias CURL_HTTPPOST_CALLBACK = (1<<6)
"""upload file contents by using the regular read callback to get the data and
   pass the given pointer as custom pointer."""
alias CURL_HTTPPOST_LARGE = (1<<7)
"""use size in 'contentlen', added in 7.46.0."""


alias CURL_MAX_READ_SIZE = (10*1024*1024)
"""The maximum receive buffer size configurable via CURLOPT_BUFFERSIZE."""

alias CURL_MAX_WRITE_SIZE = (16*1024)
"""Tests have proven that 20K is a bad buffer size for uploads on Windows,
while 16K for some odd reason performed a lot better. We do the ifndef
check to allow this value to easier be changed at build time for those
who feel adventurous. The practical minimum is about 400 bytes since
libcurl uses a buffer of this size as a scratch area (unrelated to
network send operations)."""


alias CURL_MAX_HTTP_HEADER = (100*1024)
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



alias CURL_GLOBAL_SSL = (1<<0)
alias CURL_GLOBAL_WIN32 = (1<<1)
alias CURL_GLOBAL_ALL = (CURL_GLOBAL_SSL|CURL_GLOBAL_WIN32)
alias CURL_GLOBAL_NOTHING = 0
alias CURL_GLOBAL_DEFAULT = CURL_GLOBAL_ALL
alias CURL_GLOBAL_ACK_EINTR = (1<<2)
