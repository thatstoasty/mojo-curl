from sys.ffi import c_char, c_int, c_uint, c_size_t, c_long
from memory import OpaquePointer, UnsafePointer

alias ExternalImmutPointer = UnsafeImmutPointer[origin=ImmutOrigin.external]
alias ExternalImmutOpaquePointer = ExternalImmutPointer[NoneType]
alias ExternalMutPointer = UnsafeMutPointer[origin=MutOrigin.external]
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
alias curl_write_callback = fn (ExternalImmutPointer[c_char], c_size_t, c_size_t, ExternalImmutOpaquePointer) -> c_size_t
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
struct Result(Movable, Copyable, Writable, EqualityComparable):
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
    alias SSL_PINNEDPUBKEYNOTMATCH: Self = 90
    alias SSL_INVALIDCERTSTATUS: Self = 91
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
struct OptionType(Movable, Copyable):
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
struct Option(Movable, Copyable):
    var value: c_int

    alias WRITE_DATA: Self = 10001
    alias FILE: Self = OptionType.OBJECT_POINT.value + 1
    alias URL: Self = OptionType.OBJECT_POINT.value + 2
    alias PORT: Self = 3
    alias PROXY: Self = 10004
    alias USER_PWD: Self = 10005
    alias PROXY_USER_PWD: Self = 10006
    alias RANGE: Self = 10007
    alias READ_DATA: Self = 10009
    alias ERROR_BUFFER: Self = 10010
    alias WRITE_FUNCTION: Self = 20011
    alias READ_FUNCTION: Self = 20012
    alias TIMEOUT: Self = 13
    alias IN_FILE_SIZE: Self = 14
    alias POST_FIELDS: Self = 10015
    alias REFERER: Self = 10016
    alias FTPPORT: Self = 10017
    alias USERAGENT: Self = 10018
    alias LOW_SPEED_LIMIT: Self = 19
    alias LOW_SPEED_TIME: Self = 20
    alias RESUME_FROM: Self = 21
    alias COOKIE: Self = 10022
    alias HTTP_HEADER: Self = 10023
    alias HTTP_POST: Self = 10024
    alias SSL_CERT: Self = 10025
    alias KEY_PASSWD: Self = 10026
    alias CRLF: Self = 27
    alias QUOTE: Self = 10028
    alias HEADER_DATA: Self = 10029
    alias COOKIE_FILE: Self = 10031
    alias SSL_VERSION: Self = 32
    alias TIME_CONDITION: Self = 33
    alias TIME_VALUE: Self = 34
    alias VERBOSE: Self = 41
    alias HEADER: Self = 42
    alias NO_PROGRESS: Self = 43
    alias NO_BODY: Self = 44
    alias FAIL_ON_ERROR: Self = 45
    alias UPLOAD: Self = 46
    alias POST: Self = 47
    alias DIR_LIST_ONLY: Self = 48
    alias APPEND: Self = 50
    alias NETRC: Self = 51
    alias FOLLOW_LOCATION: Self = 52
    alias TRANSFER_TEXT: Self = 53
    alias PUT: Self = 54
    alias PROGRESS_FUNCTION: Self = 20056
    alias PROGRESS_DATA: Self = 10057
    alias AUTO_REFERER: Self = 58
    alias PROXY_PORT: Self = 59
    alias POST_FIELD_SIZE: Self = 60
    alias HTTP_PROXY_TUNNEL: Self = 61
    alias INTERFACE: Self = 10062
    alias KRBLEVEL: Self = 10063
    alias SSL_VERIFYPEER: Self = 64
    alias CAINFO: Self = 10065
    alias MAXREDIRS: Self = 68
    alias FILE_TIME: Self = 69
    alias TELNET_OPTIONS: Self = 10070
    alias MAX_CONNECTS: Self = 71
    alias FRESH_CONNECT: Self = 74
    alias FORBID_REUSE: Self = 75
    alias RANDOM_FILE: Self = 10076
    alias EGD_SOCKET: Self = 10077
    alias CONNECT_TIMEOUT: Self = 78
    alias HEADER_FUNCTION: Self = 20079
    alias HTTPGET: Self = 80
    alias SSL_VERIFY_HOST: Self = 81
    alias COOKIEJAR: Self = 10082
    alias SSL_CIPHER_LIST: Self = 10083
    alias HTTP_VERSION: Self = 84
    alias FTP_USE_EPSV: Self = 85
    alias SSL_CERT_TYPE: Self = 10086
    alias SSL_KEY: Self = 10087
    alias SSL_KEY_TYPE: Self = 10088
    alias SSL_ENGINE: Self = 10089
    alias SSL_ENGINE_DEFAULT: Self = 90
    alias DNS_USE_GLOBAL_CACHE: Self = 91
    alias DNS_CACHE_TIMEOUT: Self = 92
    alias PREQUOTE: Self = 10093
    alias DEBUG_FUNCTION: Self = 20094
    alias DEBUG_DATA: Self = 10095
    alias COOKIE_SESSION: Self = 96
    alias CAPATH: Self = 10097
    alias BUFFER_SIZE: Self = 98
    alias NO_SIGNAL: Self = 99
    alias SHARE: Self = 10100
    alias CA_CACHE_TIMEOUT: Self = 321

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

    @implicit
    fn __init__(out self, value: c_int):
        self.value = value

# Info options (commonly used ones)
@fieldwise_init
@register_passable("trivial")
struct Info(Movable, Copyable):
    """CURLINFO options for retrieving information from a CURL handle."""
    var value: c_int
    alias STRING: Self = 0x100000
    alias LONG: Self = 0x200000
    alias DOUBLE: Self = 0x300000
    alias SLIST: Self = 0x400000
    alias PTR: Self = 0x400000
    alias SOCKET: Self = 0x500000
    alias OFF_T: Self = 0x600000
    alias MASK: Self = 0x0fffff
    alias TYPE_MASK: Self = 0xf00000
    alias EFFECTIVE_URL: Self = Int(Self.STRING.value + 1)
    alias RESPONSE_CODE: Self = 2097154
    alias TOTAL_TIME: Self = 3145731
    alias NAME_LOOKUP_TIME: Self = 3145732
    alias CONNECT_TIME: Self = 3145733
    alias PRE_TRANSFER_TIME: Self = 3145734
    alias SIZE_UPLOAD: Self = 3145735
    alias SIZE_DOWNLOAD: Self = 3145736
    alias SPEED_DOWNLOAD: Self = 3145737
    alias SPEED_UPLOAD: Self = 3145738
    alias HEADER_SIZE: Self = 2097163
    alias REQUEST_SIZE: Self = 2097164
    alias SSL_VERIFYRESULT: Self = 2097165
    alias FILETIME: Self = 2097166
    alias CONTENT_LENGTH_DOWNLOAD: Self = 3145743
    alias CONTENT_LENGTH_UPLOAD: Self = 3145744
    alias STARTTRANSFER_TIME: Self = 3145745
    alias CONTENT_TYPE: Self = 1048594
    alias REDIRECT_TIME: Self = 3145747
    alias REDIRECT_COUNT: Self = 2097172
    alias PRIVATE: Self = 1048597
    alias HTTP_CONNECT_CODE: Self = 2097174
    alias HTTPAUTH_AVAIL: Self = 2097175
    alias PROXYAUTH_AVAIL: Self = 2097176
    alias OS_ERRNO: Self = 2097177
    alias NUM_CONNECTS: Self = 2097178
    alias SSL_ENGINES: Self = 4194331
    alias COOKIE_LIST: Self = 4194332
    alias LAST_SOCKET: Self = 2097181
    alias FTP_ENTRY_PATH: Self = 1048606
    alias REDIRECT_URL: Self = 1048607
    alias PRIMARY_IP: Self = 1048608
    alias APP_CONNECT_TIME: Self = 3145761
    alias CERT_INFO: Self = 4194338
    alias HTTP_VERSION: Self = 0x200000 + 46

    @implicit
    fn __init__(out self, value: Int):
        self.value = value

# HTTP version options
@fieldwise_init
@register_passable("trivial")
struct HTTPVersion(Movable, Copyable):
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
struct SSLVersion(Movable, Copyable):
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

struct curl_httppost():
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
"""The maximum receive buffer size configurable via BUFFERSIZE."""

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
