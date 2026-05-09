from std.ffi import c_char, c_int, c_long, c_size_t, c_uint, c_ulong, c_short, c_ushort
from std.utils import StaticTuple

comptime ImmutExternalPointer = ImmutUnsafePointer[origin=ImmutExternalOrigin, ...]
comptime MutExternalPointer = MutUnsafePointer[origin=MutExternalOrigin, ...]

# Type aliases for curl
comptime CURL = MutExternalPointer[NoneType]
"""Opaque pointer type for CURL easy handles."""

comptime CURLoption = c_int
comptime CURLINFO = c_int
comptime CURLcode = c_int
comptime CURLversion = c_int
comptime curl_socket_t = c_int
"""Type alias for curl socket type. Note that on some platforms this may be defined as an unsigned type, but we use c_int for simplicity and compatibility."""
comptime CURL_SOCKET_BAD = -1
"""Constant representing an invalid socket in curl."""
comptime curl_off_t = c_long
"""Type alias for curl offset type, used for file sizes and offsets."""
comptime time_t = Int64
"""Type alias for time type used in curl, typically representing seconds since the Unix epoch."""

struct curl_httppost:
    """Struct used in curl_formadd to build up a linked list of HTTP POST data."""
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
    var user_ptr: MutExternalPointer[NoneType]
    """Custom user pointer used for HTTPPOST_CALLBACK posts."""
    var contentlen: curl_off_t
    """Alternative length of contents field. Used if CURL_HTTPPOST_LARGE is set. Added in 7.46.0."""


comptime HTTPPOST_FILENAME: c_long = (1 << 0)
"""Specified content is a filename."""
comptime HTTPPOST_READFILE: c_long = (1 << 1)
"""Specified content is a filename."""
comptime HTTPPOST_PTRNAME: c_long = (1 << 2)
"""Name is only stored pointer do not free in formfree."""
comptime HTTPPOST_PTRCONTENTS: c_long = (1 << 3)
"""Contents is only stored pointer do not free in formfree."""
comptime HTTPPOST_BUFFER: c_long = (1 << 4)
"""Upload file from buffer."""
comptime HTTPPOST_PTRBUFFER: c_long = (1 << 5)
"""Upload file from pointer contents."""
comptime HTTPPOST_CALLBACK: c_long = (1 << 6)
"""Upload file contents by using the regular read callback to get the data and
   pass the given pointer as custom pointer."""
comptime HTTPPOST_LARGE: c_long = (1 << 7)
"""Use size in 'contentlen', added in 7.46.0."""

comptime curl_progress_callback = def(ImmutExternalPointer[NoneType], Float64, Float64, Float64, Float64) abi("C") thin -> c_int
"""This is the prototype for the progress callback function used by curl. It was deprecated in favor of `TransferInfoCallbackFn` but is still supported for backward compatibility."""
comptime curl_xferinfo_callback = def(
    ImmutExternalPointer[NoneType], curl_off_t, curl_off_t, curl_off_t, curl_off_t
) abi("C") thin -> c_int
"""This is the XFERINFOFUNCTION callback prototype. It was introduced 
in 7.32.0, avoids the use of floating point numbers and provides more
detailed information."""

comptime CURL_WRITEFUNC_PAUSE: c_size_t = 0x10000001
"""This is a return code for the write callback that, when returned,
will signal libcurl to pause receiving on the current transfer."""

comptime curl_write_callback = def(MutExternalPointer[c_char], c_size_t, c_size_t, MutExternalPointer[NoneType]) abi("C") thin -> c_size_t
"""This is the prototype for the write callback function used by curl. It matches the `CURLOPT_WRITEFUNCTION` prototype and can also be used where a generic read/write signature is needed."""

comptime curlfiletype = c_int
comptime CURLFILETYPE_FILE: curlfiletype = 0
comptime CURLFILETYPE_DIRECTORY: curlfiletype = 1
comptime CURLFILETYPE_SYMLINK: curlfiletype = 2
comptime CURLFILETYPE_DEVICE_BLOCK: curlfiletype = 3
comptime CURLFILETYPE_DEVICE_CHAR: curlfiletype = 4
comptime CURLFILETYPE_NAMEDPIPE: curlfiletype = 5
comptime CURLFILETYPE_SOCKET: curlfiletype = 6
comptime CURLFILETYPE_DOOR: curlfiletype = 7
comptime CURLFILETYPE_UNKNOWN: curlfiletype = 8

comptime CURLFINFOFLAG_KNOWN_FILENAME: c_uint = 1 << 0
comptime CURLFINFOFLAG_KNOWN_FILETYPE: c_uint = 1 << 1
comptime CURLFINFOFLAG_KNOWN_TIME: c_uint = 1 << 2
comptime CURLFINFOFLAG_KNOWN_PERM: c_uint = 1 << 3
comptime CURLFINFOFLAG_KNOWN_UID: c_uint = 1 << 4
comptime CURLFINFOFLAG_KNOWN_GID: c_uint = 1 << 5
comptime CURLFINFOFLAG_KNOWN_SIZE: c_uint = 1 << 6
comptime CURLFINFOFLAG_KNOWN_HLINKCOUNT: c_uint = 1 << 7


struct _fileinfo_strings:
    var time: MutExternalPointer[c_char]
    """Modification time of the file as a string."""
    var perm: MutExternalPointer[c_char]
    """Permissions of the file as a string."""
    var user: MutExternalPointer[c_char]
    """User name of the file owner."""
    var group: MutExternalPointer[c_char]
    """Group name of the file owner."""
    var target: MutExternalPointer[c_char]
    """Pointer to the target filename of a symlink, if this file is a symlink."""

struct curl_fileinfo:
    """Information about a single file, used when doing FTP wildcard matching."""
    var filename: MutExternalPointer[c_char]
    """Name of the file, null-terminated string."""
    var filetype: curlfiletype
    """Type of the file, as defined by curlfiletype enum."""
    var time: time_t
    """Modification time of the file. Always zero!"""
    var perm: c_uint
    """Permissions of the file, as a bitmask."""
    var uid: c_int
    """User ID of the file owner."""
    var gid: c_int
    """Group ID of the file owner."""
    var size: curl_off_t
    """Size of the file in bytes."""
    var hardlinks: c_long
    """Number of hard links to the file."""
    var strings: _fileinfo_strings
    """If some of these fields is not NULL, it is a pointer to b_data."""
    var flags: c_uint
    """Flags for the file, as defined by curl_fileinfo_flags enum."""

    # Private libcurl fields
    var b_data: MutExternalPointer[c_char]
    """Buffer for storing string data pointed to by strings fields."""
    var b_size: c_size_t
    """Size of the buffer b_data."""
    var b_used: c_size_t
    """Amount of the buffer b_data currently used."""

comptime CURL_BLOB_NOCOPY: c_uint = 0
comptime CURL_BLOB_COPY: c_uint = 1


struct curl_blob[origin: MutOrigin, //](Movable):
    """CURL blob struct for binary data transfer.

    This struct represents binary data that can be passed to curl,
    with control over whether curl should copy the data or use it directly.
    """

    var data: MutOpaquePointer[Self.origin]
    """Pointer to the binary data."""
    var len: c_size_t
    """Length of the binary data."""
    var flags: c_uint
    """Control flags for the blob."""

    def __init__(out self, data: MutOpaquePointer[Self.origin], len: c_size_t, flags: c_uint = CURL_BLOB_COPY):
        """Initialize a curl_blob struct.

        Args:
            data: Pointer to the binary data.
            len: Length of the data in bytes.
            flags: Control flags (CURL_BLOB_COPY or CURL_BLOB_NOCOPY).
        """
        self.data = data
        self.len = len
        self.flags = flags

# return codes for CURLOPT_CHUNK_BGN_FUNCTION
comptime CURL_CHUNK_BGN_FUNC_OK: c_long = 0
"""Indicates that the chunk processing should continue."""
comptime CURL_CHUNK_BGN_FUNC_FAIL: c_long = 1
"""Indicates that the chunk processing should be aborted and the transfer should end with an error."""
comptime CURL_CHUNK_BGN_FUNC_SKIP: c_long = 2
"""Skip this chunk over. Note that if this is returned, then the CHUNK_END_FUNCTION callback will not be called for this chunk."""

comptime curl_chunk_bgn_callback = def(ImmutExternalPointer[NoneType], MutExternalPointer[NoneType], c_int) abi("C") thin -> c_long
"""If splitting of data transfer is enabled, this callback is called before
download of an individual chunk started. Note that parameter "remains" works
only for FTP wildcard downloading (for now), otherwise is not used."""

# Return codes for CURLOPT_CHUNK_END_FUNCTION
comptime CURL_CHUNK_END_FUNC_OK: c_long = 0
"""Indicates that the chunk processing should continue."""
comptime CURL_CHUNK_END_FUNC_FAIL: c_long = 1
"""Indicates that the chunk processing should be aborted and the transfer should end with an error."""

comptime curl_chunk_end_callback = def(MutExternalPointer[NoneType]) abi("C") thin -> c_long
"""If splitting of data transfer is enabled this callback is called after
download of an individual chunk finished.
Note! After this callback was set then it have to be called FOR ALL chunks.
Even if downloading of this chunk was skipped in CHUNK_BGN_FUNC.
This is the reason why we do not need "transfer_info" parameter in this
callback and we are not interested in "remains" parameter too."""

# Return codes for FNMATCHFUNCTION
comptime CURL_FNMATCHFUNC_MATCH: c_int = 0
"""String corresponds to the pattern."""
comptime CURL_FNMATCHFUNC_NOMATCH: c_int = 1
"""Pattern does not match the string."""
comptime CURL_FNMATCHFUNC_FAIL: c_int = 2
"""An error occurred."""

comptime curl_fnmatch_callback = def(MutExternalPointer[NoneType], ImmutExternalPointer[c_char], ImmutExternalPointer[c_char]) abi("C") thin -> c_int
"""Callback type for wildcard downloading pattern matching. If the
string matches the pattern, return CURL_FNMATCHFUNC_MATCH value, etc."""

comptime CURL_SEEKFUNC_OK: c_int = 0
"""This is a return code for the seek callback that, when returned, will signal
libcurl that the callback successfully seeked to the requested position."""
comptime CURL_SEEKFUNC_FAIL: c_int = 1
"""This is a return code for the seek callback that, when returned, will signal
libcurl that the callback failed to seek to the requested position."""
comptime CURL_SEEKFUNC_CANTSEEK: c_int = 2
"""This is a return code for the seek callback that, when returned, will signal
libcurl that seeking cannot be done, so libcurl might try other means instead."""

comptime curl_seek_callback = def(MutExternalPointer[NoneType], curl_off_t, c_int) abi("C") thin -> c_int
"""This callback will be called when libcurl needs to seek in the input stream."""

comptime CURL_READFUNC_ABORT: c_size_t = 0x10000000
"""This is a return code for the read callback that, when returned,
will signal libcurl to abort the current transfer."""
comptime CURL_READFUNC_PAUSE: c_size_t = 0x10000001
"""This is a return code for the read callback that, when returned,
will signal libcurl to pause sending data on the current transfer."""
comptime curl_read_callback = def(MutExternalPointer[c_char], c_size_t, c_size_t, MutExternalPointer[NoneType]) abi("C") thin -> c_size_t
"""This is the prototype for the read callback function used by curl. It matches the `CURLOPT_READFUNCTION` prototype, where the first argument is a writable buffer that the callback must fill."""

comptime CURL_TRAILERFUNC_OK: c_int = 0
"""Return code for when the trailing headers' callback has terminated without any errors."""
comptime CURL_TRAILERFUNC_ABORT: c_int = 1
"""Return code for when there was an error in the trailing header's list and we want to abort the request."""
comptime TrailerCallbackFn = def(MutExternalPointer[MutExternalPointer[curl_slist]], MutExternalPointer[NoneType]) abi("C") thin -> c_int
"""This is the prototype for the trailing headers callback function used by curl. It matches the `CURLOPT_TRAILERFUNCTION` prototype, where the first argument is a pointer to a pointer to a curl_slist that the callback must fill with the trailing headers."""

# The return code from the sockopt_callback can signal information back to libcurl
comptime CURL_SOCKOPT_OK: c_int = 0
"""Indicates that the socket options were set successfully and libcurl can continue as usual."""
comptime CURL_SOCKOPT_ERROR: c_int = 1
"""Indicates that there was an error setting the socket options and libcurl should abort the current transfer. libcurl will return `CURLE_ABORTED_BY_CALLBACK`."""
comptime CURL_SOCKOPT_ALREADY_CONNECTED: c_int = 2
"""Indicates that the socket is already connected."""

comptime curl_sockopt_callback = def(MutExternalPointer[NoneType], curl_socket_t, curlsocktype) abi("C") thin -> c_int
"""This callback will be called immediately after a socket is created by libcurl, and allows the application to set custom options on the socket. The callback should return CURL_SOCKOPT_OK if the options were set successfully, CURL_SOCKOPT_ERROR if there was an error and the transfer should be aborted, or CURL_SOCKOPT_ALREADY_CONNECTED if the socket is already connected."""

comptime curlioerr = c_int
"""Enumeration of return codes for the `CURLOPT_IOCTLFUNCTION` callback."""
comptime CURLIOE_OK: curlioerr = 0
"""Indicates that the I/O operation was successful."""
comptime CURLIOE_UNKNOWNCMD: curlioerr = 1
"""Indicates that the command was unknown to the callback."""
comptime CURLIOE_FAILRESTART: curlioerr = 2
"""Indicates that the callback failed to restart the read."""

comptime curliocmd = c_int
"""Enumeration of commands for the `CURLOPT_IOCTLFUNCTION` callback."""
comptime CURLIOCMD_NOP: curliocmd = 0
"""No operation. This command is used when libcurl wants to check if the callback is still alive."""
comptime CURLIOCMD_RESTARTREAD: curliocmd = 1
"""Restart the read stream from the beginning. This command is used when libcurl needs to restart the read stream, for example when a retry is needed after a failed upload."""

comptime curl_ioctl_callback = def(CURL, curliocmd, MutExternalPointer[NoneType]) abi("C") thin -> curlioerr
"""This is the prototype for the ioctl callback function used by curl. It matches the `CURLOPT_IOCTLFUNCTION` prototype, where the `cmd` parameter is one of the `curliocmd` values and the return value should be one of the `curlioerr` values."""

# The following typedef's are signatures of malloc, free, realloc, strdup and calloc respectively.
# Function pointers of these types can be passed to the
# curl_global_init_mem() function to set user defined memory management
# callback routines.
comptime curl_malloc_callback = def(size: c_size_t) abi("C") thin -> MutExternalPointer[NoneType]
comptime curl_free_callback = def(ptr: MutExternalPointer[NoneType]) abi("C") thin -> None
comptime curl_realloc_callback = def(ptr: MutExternalPointer[NoneType], size: c_size_t) abi("C") thin -> MutExternalPointer[NoneType]
comptime curl_strdup_callback = def(str: ImmutExternalPointer[c_char]) abi("C") thin -> MutExternalPointer[c_char]
comptime curl_calloc_callback = def(nmemb: c_size_t, size: c_size_t) abi("C") thin -> MutExternalPointer[NoneType]


comptime curl_infotype = c_int
"""Enumeration of information types used in the `CURLOPT_DEBUGFUNCTION` callback."""
comptime CURLINFO_TEXT: curl_infotype = 0
"""Informational text. This is the default type of information passed to the debug callback."""
comptime CURLINFO_HEADER_IN: curl_infotype = 1
"""Header data received from the server."""
comptime CURLINFO_HEADER_OUT: curl_infotype = 2
"""Header data sent to the server."""
comptime CURLINFO_DATA_IN: curl_infotype = 3
"""Data received from the server."""
comptime CURLINFO_DATA_OUT: curl_infotype = 4
"""Data sent to the server."""
comptime CURLINFO_SSL_DATA_IN: curl_infotype = 5
"""SSL data received from the server."""
comptime CURLINFO_SSL_DATA_OUT: curl_infotype = 6
"""SSL data sent to the server."""

comptime curl_debug_callback = def(CURL, c_int, MutExternalPointer[c_char], c_size_t, MutExternalPointer[NoneType]) abi("C") thin -> c_int
"""This is the prototype for the debug callback function used by curl. It is used for `CURLOPT_DEBUGFUNCTION`."""

comptime CURLE_OK: CURLcode = 0
comptime CURLE_UNSUPPORTED_PROTOCOL: CURLcode = 1
comptime CURLE_FAILED_INIT: CURLcode = 2
comptime CURLE_URL_MALFORMAT: CURLcode = 3
comptime CURLE_NOT_BUILT_IN: CURLcode = 4
comptime CURLE_COULDNT_RESOLVE_PROXY: CURLcode = 5
comptime CURLE_COULDNT_RESOLVE_HOST: CURLcode = 6
comptime CURLE_COULDNT_CONNECT: CURLcode = 7
comptime CURLE_FTP_WEIRD_SERVER_REPLY: CURLcode = 8
comptime CURLE_REMOTE_ACCESS_DENIED: CURLcode = 9
comptime CURLE_FTP_ACCEPT_FAILED: CURLcode = 10
comptime CURLE_FTP_WEIRD_PASS_REPLY: CURLcode = 11
comptime CURLE_FTP_ACCEPT_TIMEOUT: CURLcode = 12
comptime CURLE_FTP_WEIRD_PASV_REPLY: CURLcode = 13
comptime CURLE_FTP_WEIRD_227_FORMAT: CURLcode = 14
comptime CURLE_FTP_CANT_GET_HOST: CURLcode = 15
comptime CURLE_HTTP2: CURLcode = 16
comptime CURLE_FTP_COULDNT_SET_TYPE: CURLcode = 17
comptime CURLE_PARTIAL_FILE: CURLcode = 18
comptime CURLE_FTP_COULDNT_RETR_FILE: CURLcode = 19
comptime CURLE_OBSOLETE20: CURLcode = 20
comptime CURLE_QUOTE_ERROR: CURLcode = 21
comptime CURLE_HTTP_RETURNED_ERROR: CURLcode = 22
comptime CURLE_WRITE_ERROR: CURLcode = 23
comptime CURLE_OBSOLETE24: CURLcode = 24
comptime CURLE_UPLOAD_FAILED: CURLcode = 25
comptime CURLE_READ_ERROR: CURLcode = 26
comptime CURLE_OUT_OF_MEMORY: CURLcode = 27
comptime CURLE_OPERATION_TIMEDOUT: CURLcode = 28
comptime CURLE_OBSOLETE29: CURLcode = 29
comptime CURLE_FTP_PORT_FAILED: CURLcode = 30
comptime CURLE_FTP_COULDNT_USE_REST: CURLcode = 31
comptime CURLE_OBSOLETE32: CURLcode = 32
comptime CURLE_RANGE_ERROR: CURLcode = 33
comptime CURLE_HTTP_POST_ERROR: CURLcode = 34
comptime CURLE_SSL_CONNECT_ERROR: CURLcode = 35
comptime CURLE_BAD_DOWNLOAD_RESUME: CURLcode = 36
comptime CURLE_FILE_COULDNT_READ_FILE: CURLcode = 37
comptime CURLE_LDAP_CANNOT_BIND: CURLcode = 38
comptime CURLE_LDAP_SEARCH_FAILED: CURLcode = 39
comptime CURLE_OBSOLETE40: CURLcode = 40
comptime CURLE_FUNCTION_NOT_FOUND: CURLcode = 41
comptime CURLE_ABORTED_BY_CALLBACK: CURLcode = 42
comptime CURLE_BAD_FUNCTION_ARGUMENT: CURLcode = 43
comptime CURLE_OBSOLETE44: CURLcode = 44
comptime CURLE_INTERFACE_FAILED: CURLcode = 45
comptime CURLE_OBSOLETE46: CURLcode = 46
comptime CURLE_TOO_MANY_REDIRECTS: CURLcode = 47
comptime CURLE_UNKNOWN_OPTION: CURLcode = 48
comptime CURLE_TELNET_OPTION_SYNTAX: CURLcode = 49
comptime CURLE_OBSOLETE50: CURLcode = 50
comptime CURLE_PEER_FAILED_VERIFICATION: CURLcode = 60
comptime CURLE_GOT_NOTHING: CURLcode = 52
comptime CURLE_SSL_ENGINE_NOTFOUND: CURLcode = 53
comptime CURLE_SSL_ENGINE_SETFAILED: CURLcode = 54
comptime CURLE_SEND_ERROR: CURLcode = 55
comptime CURLE_RECV_ERROR: CURLcode = 56
comptime CURLE_OBSOLETE57: CURLcode = 57
comptime CURLE_SSL_CERTPROBLEM: CURLcode = 58
comptime CURLE_SSL_CIPHER: CURLcode = 59
comptime CURLE_SSL_CACERT: CURLcode = 60
comptime CURLE_BAD_CONTENT_ENCODING: CURLcode = 61
comptime CURLE_LDAP_INVALID_URL: CURLcode = 62
comptime CURLE_FILESIZE_EXCEEDED: CURLcode = 63
comptime CURLE_USE_SSL_FAILED: CURLcode = 64
comptime CURLE_SEND_FAIL_REWIND: CURLcode = 65
comptime CURLE_SSL_ENGINE_INITFAILED: CURLcode = 66
comptime CURLE_LOGIN_DENIED: CURLcode = 67
comptime CURLE_TFTP_NOTFOUND: CURLcode = 68
comptime CURLE_TFTP_PERM: CURLcode = 69
comptime CURLE_REMOTE_DISK_FULL: CURLcode = 70
comptime CURLE_TFTP_ILLEGAL: CURLcode = 71
comptime CURLE_TFTP_UNKNOWNID: CURLcode = 72
comptime CURLE_REMOTE_FILE_EXISTS: CURLcode = 73
comptime CURLE_TFTP_NOSUCHUSER: CURLcode = 74
comptime CURLE_CONV_FAILED: CURLcode = 75
comptime CURLE_CONV_REQD: CURLcode = 76
comptime CURLE_SSL_CACERT_BADFILE: CURLcode = 77
comptime CURLE_REMOTE_FILE_NOT_FOUND: CURLcode = 78
comptime CURLE_SSH: CURLcode = 79
comptime CURLE_SSL_SHUTDOWN_FAILED: CURLcode = 80
comptime CURLE_AGAIN: CURLcode = 81
comptime CURLE_SSL_CRL_BADFILE: CURLcode = 82
comptime CURLE_SSL_ISSUER_ERROR: CURLcode = 83
comptime CURLE_FTP_PRET_FAILED: CURLcode = 84
comptime CURLE_RTSP_CSEQ_ERROR: CURLcode = 85
comptime CURLE_RTSP_SESSION_ERROR: CURLcode = 86
comptime CURLE_FTP_BAD_FILE_LIST: CURLcode = 87
comptime CURLE_CHUNK_FAILED: CURLcode = 88
comptime CURLE_NO_CONNECTION_AVAILABLE: CURLcode = 89
comptime CURLE_SSL_PINNEDPUBKEYNOTMATCH: CURLcode = 90
comptime CURLE_SSL_INVALIDCERTSTATUS: CURLcode = 91
comptime CURLE_HTTP2_STREAM: CURLcode = 92
comptime CURLE_RECURSIVE_API_CALL: CURLcode = 93

comptime curl_conv_callback = def(MutExternalPointer[c_char], c_size_t, MutExternalPointer[NoneType]) abi("C") thin -> c_int
comptime curl_ssl_ctx_callback = def(CURL, MutExternalPointer[NoneType], MutExternalPointer[NoneType]) abi("C") thin -> CURLcode

comptime curl_proxytype = c_int
comptime CURLPROXY_HTTP: curl_proxytype = 0
comptime CURLPROXY_HTTP_1_0: curl_proxytype = 1
comptime CURLPROXY_SOCKS4: curl_proxytype = 4
comptime CURLPROXY_SOCKS5: curl_proxytype = 5
comptime CURLPROXY_SOCKS4A: curl_proxytype = 6
comptime CURLPROXY_SOCKS5_HOSTNAME: curl_proxytype = 7

comptime CURLAUTH_NONE: c_ulong = 0
comptime CURLAUTH_BASIC: c_ulong = 1 << 0
comptime CURLAUTH_DIGEST: c_ulong = 1 << 1
comptime CURLAUTH_GSSNEGOTIATE: c_ulong = 1 << 2
comptime CURLAUTH_NTLM: c_ulong = 1 << 3
comptime CURLAUTH_DIGEST_IE: c_ulong = 1 << 4
comptime CURLAUTH_NTLM_WB: c_ulong = 1 << 5
comptime CURLAUTH_AWS_SIGV4: c_ulong = 1 << 7
comptime CURLAUTH_ONLY: c_ulong = 1 << 31
comptime CURLAUTH_ANY: c_ulong = (~CURLAUTH_DIGEST_IE) & c_ulong(0xffffffff)
comptime CURLAUTH_ANYSAFE: c_ulong = (~(CURLAUTH_BASIC | CURLAUTH_DIGEST_IE)) & c_ulong(0xffffffff)

comptime CURLSSH_AUTH_ANY: c_ulong = c_ulong(0xffffffff)
comptime CURLSSH_AUTH_NONE: c_ulong = 0
comptime CURLSSH_AUTH_PUBLICKEY: c_ulong = 1 << 0
comptime CURLSSH_AUTH_PASSWORD: c_ulong = 1 << 1
comptime CURLSSH_AUTH_HOST: c_ulong = 1 << 2
comptime CURLSSH_AUTH_KEYBOARD: c_ulong = 1 << 3
comptime CURLSSH_AUTH_AGENT: c_ulong = 1 << 4
comptime CURLSSH_AUTH_DEFAULT: c_ulong = CURLSSH_AUTH_ANY

comptime CURLGSSAPI_DELEGATION_NONE: c_ulong = 0
comptime CURLGSSAPI_DELEGATION_POLICY_FLAG: c_ulong = 1 << 0
comptime CURLGSSAPI_DELEGATION_FLAG: c_ulong = 1 << 1

comptime CURL_NETRC_IGNORED: c_ulong = 0
comptime CURL_NETRC_OPTIONAL: c_ulong = 1
comptime CURL_NETRC_REQUIRED: c_ulong = 2

comptime curl_usessl = c_int
comptime CURLUSESSL_NONE: curl_usessl = 0
comptime CURLUSESSL_TRY: curl_usessl = 1
comptime CURLUSESSL_CONTROL: curl_usessl = 2
comptime CURLUSESSL_ALL: curl_usessl = 3

comptime CURLPROTO_HTTP: c_int = 1 << 0
comptime CURLPROTO_HTTPS: c_int = 1 << 1
comptime CURLPROTO_FILE: c_int = 1 << 10

comptime CURLOPTTYPE_LONG: CURLoption = 0
comptime CURLOPTTYPE_OBJECTPOINT: CURLoption = 10_000
comptime CURLOPTTYPE_FUNCTIONPOINT: CURLoption = 20_000
comptime CURLOPTTYPE_OFF_T: CURLoption = 30_000
comptime CURLOPTTYPE_BLOB: CURLoption = 40_000
comptime CURLOPTTYPE_VALUES: CURLoption = CURLOPTTYPE_LONG

comptime CURLOPT_FILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 1
comptime CURLOPT_URL: CURLoption = CURLOPTTYPE_OBJECTPOINT + 2
comptime CURLOPT_PORT: CURLoption = CURLOPTTYPE_LONG + 3
comptime CURLOPT_PROXY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 4
comptime CURLOPT_USERPWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 5
comptime CURLOPT_PROXYUSERPWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 6
comptime CURLOPT_RANGE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 7
comptime CURLOPT_INFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 9
comptime CURLOPT_ERRORBUFFER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 10
comptime CURLOPT_WRITEFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 11
comptime CURLOPT_READFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 12
comptime CURLOPT_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 13
comptime CURLOPT_INFILESIZE: CURLoption = CURLOPTTYPE_LONG + 14
comptime CURLOPT_POSTFIELDS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 15
comptime CURLOPT_REFERER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 16
comptime CURLOPT_FTPPORT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 17
comptime CURLOPT_USERAGENT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 18
comptime CURLOPT_LOW_SPEED_LIMIT: CURLoption = CURLOPTTYPE_LONG + 19
comptime CURLOPT_LOW_SPEED_TIME: CURLoption = CURLOPTTYPE_LONG + 20
comptime CURLOPT_RESUME_FROM: CURLoption = CURLOPTTYPE_LONG + 21
comptime CURLOPT_COOKIE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 22
comptime CURLOPT_HTTPHEADER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 23
comptime CURLOPT_HTTPPOST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 24
comptime CURLOPT_SSLCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 25
comptime CURLOPT_KEYPASSWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 26
comptime CURLOPT_CRLF: CURLoption = CURLOPTTYPE_LONG + 27
comptime CURLOPT_QUOTE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 28
comptime CURLOPT_WRITEHEADER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 29
comptime CURLOPT_COOKIEFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 31
comptime CURLOPT_SSLVERSION: CURLoption = CURLOPTTYPE_LONG + 32
comptime CURLOPT_TIMECONDITION: CURLoption = CURLOPTTYPE_LONG + 33
comptime CURLOPT_TIMEVALUE: CURLoption = CURLOPTTYPE_LONG + 34
comptime CURLOPT_CUSTOMREQUEST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 36
comptime CURLOPT_STDERR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 37
comptime CURLOPT_POSTQUOTE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 39
#deprecated - has no effect
comptime CURLOPT_WRITEINFO: CURLoption = 9999
comptime CURLOPT_VERBOSE: CURLoption = CURLOPTTYPE_LONG + 41
comptime CURLOPT_HEADER: CURLoption = CURLOPTTYPE_LONG + 42
comptime CURLOPT_NOPROGRESS: CURLoption = CURLOPTTYPE_LONG + 43
comptime CURLOPT_NOBODY: CURLoption = CURLOPTTYPE_LONG + 44
comptime CURLOPT_FAILONERROR: CURLoption = CURLOPTTYPE_LONG + 45
comptime CURLOPT_UPLOAD: CURLoption = CURLOPTTYPE_LONG + 46
comptime CURLOPT_POST: CURLoption = CURLOPTTYPE_LONG + 47
comptime CURLOPT_DIRLISTONLY: CURLoption = CURLOPTTYPE_LONG + 48
comptime CURLOPT_APPEND: CURLoption = CURLOPTTYPE_LONG + 50
comptime CURLOPT_NETRC: CURLoption = CURLOPTTYPE_LONG + 51
comptime CURLOPT_FOLLOWLOCATION: CURLoption = CURLOPTTYPE_LONG + 52
comptime CURLOPT_TRANSFERTEXT: CURLoption = CURLOPTTYPE_LONG + 53
comptime CURLOPT_PUT: CURLoption = CURLOPTTYPE_LONG + 54
comptime CURLOPT_PROGRESSFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 56
comptime CURLOPT_PROGRESSDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 57
comptime CURLOPT_AUTOREFERER: CURLoption = CURLOPTTYPE_LONG + 58
comptime CURLOPT_PROXYPORT: CURLoption = CURLOPTTYPE_LONG + 59
comptime CURLOPT_POSTFIELDSIZE: CURLoption = CURLOPTTYPE_LONG + 60
comptime CURLOPT_HTTPPROXYTUNNEL: CURLoption = CURLOPTTYPE_LONG + 61
comptime CURLOPT_INTERFACE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 62
comptime CURLOPT_KRBLEVEL: CURLoption = CURLOPTTYPE_OBJECTPOINT + 63
comptime CURLOPT_SSL_VERIFYPEER: CURLoption = CURLOPTTYPE_LONG + 64
comptime CURLOPT_CAINFO: CURLoption = CURLOPTTYPE_OBJECTPOINT + 65
comptime CURLOPT_MAXREDIRS: CURLoption = CURLOPTTYPE_LONG + 68
comptime CURLOPT_FILETIME: CURLoption = CURLOPTTYPE_LONG + 69
comptime CURLOPT_TELNETOPTIONS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 70
comptime CURLOPT_MAXCONNECTS: CURLoption = CURLOPTTYPE_LONG + 71
#deprecated - has no effect
comptime CURLOPT_CLOSEPOLICY: CURLoption = 9999
comptime CURLOPT_FRESH_CONNECT: CURLoption = CURLOPTTYPE_LONG + 74
comptime CURLOPT_FORBID_REUSE: CURLoption = CURLOPTTYPE_LONG + 75
comptime CURLOPT_RANDOM_FILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 76
comptime CURLOPT_EGDSOCKET: CURLoption = CURLOPTTYPE_OBJECTPOINT + 77
comptime CURLOPT_CONNECTTIMEOUT: CURLoption = CURLOPTTYPE_LONG + 78
comptime CURLOPT_HEADERFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 79
comptime CURLOPT_HTTPGET: CURLoption = CURLOPTTYPE_LONG + 80
comptime CURLOPT_SSL_VERIFYHOST: CURLoption = CURLOPTTYPE_LONG + 81
comptime CURLOPT_COOKIEJAR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 82
comptime CURLOPT_SSL_CIPHER_LIST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 83
comptime CURLOPT_HTTP_VERSION: CURLoption = CURLOPTTYPE_LONG + 84
comptime CURLOPT_FTP_USE_EPSV: CURLoption = CURLOPTTYPE_LONG + 85
comptime CURLOPT_SSLCERTTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 86
comptime CURLOPT_SSLKEY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 87
comptime CURLOPT_SSLKEYTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 88
comptime CURLOPT_SSLENGINE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 89
comptime CURLOPT_SSLENGINE_DEFAULT: CURLoption = CURLOPTTYPE_LONG + 90
comptime CURLOPT_DNS_USE_GLOBAL_CACHE: CURLoption = CURLOPTTYPE_LONG + 91
comptime CURLOPT_DNS_CACHE_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 92
comptime CURLOPT_PREQUOTE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 93
comptime CURLOPT_DEBUGFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 94
comptime CURLOPT_DEBUGDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 95
comptime CURLOPT_COOKIESESSION: CURLoption = CURLOPTTYPE_LONG + 96
comptime CURLOPT_CAPATH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 97
comptime CURLOPT_BUFFERSIZE: CURLoption = CURLOPTTYPE_LONG + 98
comptime CURLOPT_NOSIGNAL: CURLoption = CURLOPTTYPE_LONG + 99
comptime CURLOPT_SHARE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 100
comptime CURLOPT_PROXYTYPE: CURLoption = CURLOPTTYPE_LONG + 101
comptime CURLOPT_ACCEPT_ENCODING: CURLoption = CURLOPTTYPE_OBJECTPOINT + 102
comptime CURLOPT_PRIVATE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 103
comptime CURLOPT_HTTP200ALIASES: CURLoption = CURLOPTTYPE_OBJECTPOINT + 104
comptime CURLOPT_UNRESTRICTED_AUTH: CURLoption = CURLOPTTYPE_LONG + 105
comptime CURLOPT_FTP_USE_EPRT: CURLoption = CURLOPTTYPE_LONG + 106
comptime CURLOPT_HTTPAUTH: CURLoption = CURLOPTTYPE_LONG + 107
comptime CURLOPT_SSL_CTX_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 108
comptime CURLOPT_SSL_CTX_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 109
comptime CURLOPT_FTP_CREATE_MISSING_DIRS: CURLoption = CURLOPTTYPE_LONG + 110
comptime CURLOPT_PROXYAUTH: CURLoption = CURLOPTTYPE_LONG + 111
comptime CURLOPT_FTP_RESPONSE_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 112
comptime CURLOPT_IPRESOLVE: CURLoption = CURLOPTTYPE_LONG + 113
comptime CURLOPT_MAXFILESIZE: CURLoption = CURLOPTTYPE_LONG + 114
comptime CURLOPT_INFILESIZE_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 115
comptime CURLOPT_RESUME_FROM_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 116
comptime CURLOPT_MAXFILESIZE_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 117
comptime CURLOPT_NETRC_FILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 118
comptime CURLOPT_USE_SSL: CURLoption = CURLOPTTYPE_LONG + 119
comptime CURLOPT_POSTFIELDSIZE_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 120
comptime CURLOPT_TCP_NODELAY: CURLoption = CURLOPTTYPE_LONG + 121
comptime CURLOPT_FTPSSLAUTH: CURLoption = CURLOPTTYPE_LONG + 129
comptime CURLOPT_IOCTLFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 130
comptime CURLOPT_IOCTLDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 131
comptime CURLOPT_FTP_ACCOUNT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 134
comptime CURLOPT_COOKIELIST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 135
comptime CURLOPT_IGNORE_CONTENT_LENGTH: CURLoption = CURLOPTTYPE_LONG + 136
comptime CURLOPT_FTP_SKIP_PASV_IP: CURLoption = CURLOPTTYPE_LONG + 137
comptime CURLOPT_FTP_FILEMETHOD: CURLoption = CURLOPTTYPE_LONG + 138
comptime CURLOPT_LOCALPORT: CURLoption = CURLOPTTYPE_LONG + 139
comptime CURLOPT_LOCALPORTRANGE: CURLoption = CURLOPTTYPE_LONG + 140
comptime CURLOPT_CONNECT_ONLY: CURLoption = CURLOPTTYPE_LONG + 141
comptime CURLOPT_CONV_FROM_NETWORK_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 142
comptime CURLOPT_CONV_TO_NETWORK_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 143
comptime CURLOPT_CONV_FROM_UTF8_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 144
comptime CURLOPT_MAX_SEND_SPEED_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 145
comptime CURLOPT_MAX_RECV_SPEED_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 146
comptime CURLOPT_FTP_ALTERNATIVE_TO_USER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 147
comptime CURLOPT_SOCKOPTFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 148
comptime CURLOPT_SOCKOPTDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 149
comptime CURLOPT_SSL_SESSIONID_CACHE: CURLoption = CURLOPTTYPE_LONG + 150
comptime CURLOPT_SSH_AUTH_TYPES: CURLoption = CURLOPTTYPE_LONG + 151
comptime CURLOPT_SSH_PUBLIC_KEYFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 152
comptime CURLOPT_SSH_PRIVATE_KEYFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 153
comptime CURLOPT_FTP_SSL_CCC: CURLoption = CURLOPTTYPE_LONG + 154
comptime CURLOPT_TIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 155
comptime CURLOPT_CONNECTTIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 156
comptime CURLOPT_HTTP_TRANSFER_DECODING: CURLoption = CURLOPTTYPE_LONG + 157
comptime CURLOPT_HTTP_CONTENT_DECODING: CURLoption = CURLOPTTYPE_LONG + 158
comptime CURLOPT_NEW_FILE_PERMS: CURLoption = CURLOPTTYPE_LONG + 159
comptime CURLOPT_NEW_DIRECTORY_PERMS: CURLoption = CURLOPTTYPE_LONG + 160
comptime CURLOPT_POSTREDIR: CURLoption = CURLOPTTYPE_LONG + 161
comptime CURLOPT_SSH_HOST_PUBLIC_KEY_MD5: CURLoption = CURLOPTTYPE_OBJECTPOINT + 162
comptime CURLOPT_OPENSOCKETFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 163
comptime CURLOPT_OPENSOCKETDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 164
comptime CURLOPT_COPYPOSTFIELDS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 165
comptime CURLOPT_PROXY_TRANSFER_MODE: CURLoption = CURLOPTTYPE_LONG + 166
comptime CURLOPT_SEEKFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 167
comptime CURLOPT_SEEKDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 168
comptime CURLOPT_CRLFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 169
comptime CURLOPT_ISSUERCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 170
comptime CURLOPT_ADDRESS_SCOPE: CURLoption = CURLOPTTYPE_LONG + 171
comptime CURLOPT_CERTINFO: CURLoption = CURLOPTTYPE_LONG + 172
comptime CURLOPT_USERNAME: CURLoption = CURLOPTTYPE_OBJECTPOINT + 173
comptime CURLOPT_PASSWORD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 174
comptime CURLOPT_PROXYUSERNAME: CURLoption = CURLOPTTYPE_OBJECTPOINT + 175
comptime CURLOPT_PROXYPASSWORD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 176
comptime CURLOPT_NOPROXY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 177
comptime CURLOPT_TFTP_BLKSIZE: CURLoption = CURLOPTTYPE_LONG + 178
comptime CURLOPT_SOCKS5_GSSAPI_SERVICE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 179
comptime CURLOPT_SOCKS5_GSSAPI_NEC: CURLoption = CURLOPTTYPE_LONG + 180
comptime CURLOPT_PROTOCOLS: CURLoption = CURLOPTTYPE_LONG + 181
comptime CURLOPT_REDIR_PROTOCOLS: CURLoption = CURLOPTTYPE_LONG + 182
comptime CURLOPT_SSH_KNOWNHOSTS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 183
comptime CURLOPT_SSH_KEYFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 184
comptime CURLOPT_SSH_KEYDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 185
comptime CURLOPT_MAIL_FROM: CURLoption = CURLOPTTYPE_OBJECTPOINT + 186
comptime CURLOPT_MAIL_RCPT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 187
comptime CURLOPT_FTP_USE_PRET: CURLoption = CURLOPTTYPE_LONG + 188
comptime CURLOPT_RTSP_REQUEST: CURLoption = CURLOPTTYPE_LONG + 189
comptime CURLOPT_RTSP_SESSION_ID: CURLoption = CURLOPTTYPE_OBJECTPOINT + 190
comptime CURLOPT_RTSP_STREAM_URI: CURLoption = CURLOPTTYPE_OBJECTPOINT + 191
comptime CURLOPT_RTSP_TRANSPORT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 192
comptime CURLOPT_RTSP_CLIENT_CSEQ: CURLoption = CURLOPTTYPE_LONG + 193
comptime CURLOPT_RTSP_SERVER_CSEQ: CURLoption = CURLOPTTYPE_LONG + 194
comptime CURLOPT_INTERLEAVEDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 195
comptime CURLOPT_INTERLEAVEFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 196
comptime CURLOPT_WILDCARDMATCH: CURLoption = CURLOPTTYPE_LONG + 197
comptime CURLOPT_CHUNK_BGN_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 198
comptime CURLOPT_CHUNK_END_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 199
comptime CURLOPT_FNMATCH_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 200
comptime CURLOPT_CHUNK_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 201
comptime CURLOPT_FNMATCH_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 202
comptime CURLOPT_RESOLVE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 203
comptime CURLOPT_TLSAUTH_USERNAME: CURLoption = CURLOPTTYPE_OBJECTPOINT + 204
comptime CURLOPT_TLSAUTH_PASSWORD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 205
comptime CURLOPT_TLSAUTH_TYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 206
comptime CURLOPT_TRANSFER_ENCODING: CURLoption = CURLOPTTYPE_LONG + 207
comptime CURLOPT_CLOSESOCKETFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 208
comptime CURLOPT_CLOSESOCKETDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 209
comptime CURLOPT_GSSAPI_DELEGATION: CURLoption = CURLOPTTYPE_LONG + 210
comptime CURLOPT_DNS_SERVERS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 211
comptime CURLOPT_TCP_KEEPALIVE: CURLoption = CURLOPTTYPE_LONG + 213
comptime CURLOPT_TCP_KEEPIDLE: CURLoption = CURLOPTTYPE_LONG + 214
comptime CURLOPT_TCP_KEEPINTVL: CURLoption = CURLOPTTYPE_LONG + 215
comptime CURLOPT_SSL_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 216
comptime CURLOPT_EXPECT_100_TIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 227
comptime CURLOPT_PINNEDPUBLICKEY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 230
comptime CURLOPT_UNIX_SOCKET_PATH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 231
comptime CURLOPT_PATH_AS_IS: CURLoption = CURLOPTTYPE_LONG + 234
comptime CURLOPT_PIPEWAIT: CURLoption = CURLOPTTYPE_LONG + 237
comptime CURLOPT_CONNECT_TO: CURLoption = CURLOPTTYPE_OBJECTPOINT + 243
comptime CURLOPT_PROXY_CAINFO: CURLoption = CURLOPTTYPE_OBJECTPOINT + 246
comptime CURLOPT_PROXY_CAPATH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 247
comptime CURLOPT_PROXY_SSL_VERIFYPEER: CURLoption = CURLOPTTYPE_LONG + 248
comptime CURLOPT_PROXY_SSL_VERIFYHOST: CURLoption = CURLOPTTYPE_LONG + 249
comptime CURLOPT_PROXY_SSLVERSION: CURLoption = CURLOPTTYPE_VALUES + 250
comptime CURLOPT_PROXY_SSLCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 254
comptime CURLOPT_PROXY_SSLCERTTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 255
comptime CURLOPT_PROXY_SSLKEY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 256
comptime CURLOPT_PROXY_SSLKEYTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 257
comptime CURLOPT_PROXY_KEYPASSWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 258
comptime CURLOPT_PROXY_SSL_CIPHER_LIST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 259
comptime CURLOPT_PROXY_CRLFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 260
comptime CURLOPT_PROXY_SSL_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 261

comptime CURLOPT_ABSTRACT_UNIX_SOCKET: CURLoption = CURLOPTTYPE_OBJECTPOINT + 264

comptime CURLOPT_DOH_URL: CURLoption = CURLOPTTYPE_OBJECTPOINT + 279
comptime CURLOPT_UPLOAD_BUFFERSIZE: CURLoption = CURLOPTTYPE_LONG + 280

comptime CURLOPT_HTTP09_ALLOWED: CURLoption = CURLOPTTYPE_LONG + 285

comptime CURLOPT_MAXAGE_CONN: CURLoption = CURLOPTTYPE_LONG + 288

comptime CURLOPT_SSLCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 291
comptime CURLOPT_SSLKEY_BLOB: CURLoption = CURLOPTTYPE_BLOB + 292
comptime CURLOPT_PROXY_SSLCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 293
comptime CURLOPT_PROXY_SSLKEY_BLOB: CURLoption = CURLOPTTYPE_BLOB + 294
comptime CURLOPT_ISSUERCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 295

comptime CURLOPT_PROXY_ISSUERCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 296
comptime CURLOPT_PROXY_ISSUERCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 297

comptime CURLOPT_AWS_SIGV4: CURLoption = CURLOPTTYPE_OBJECTPOINT + 305

comptime CURLOPT_DOH_SSL_VERIFYPEER: CURLoption = CURLOPTTYPE_LONG + 306
comptime CURLOPT_DOH_SSL_VERIFYHOST: CURLoption = CURLOPTTYPE_LONG + 307
comptime CURLOPT_DOH_SSL_VERIFYSTATUS: CURLoption = CURLOPTTYPE_LONG + 308
comptime CURLOPT_CAINFO_BLOB: CURLoption = CURLOPTTYPE_BLOB + 309
comptime CURLOPT_PROXY_CAINFO_BLOB: CURLoption = CURLOPTTYPE_BLOB + 310
comptime CURLOPT_SSH_HOST_PUBLIC_KEY_SHA256: CURLoption = CURLOPTTYPE_OBJECTPOINT + 311
comptime CURLOPT_PREREQ_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 312
comptime CURLOPT_PREREQ_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 313
comptime CURLOPT_MAX_LIFETIME_CONN: CURLoption = CURLOPTTYPE_LONG + 314
comptime CURLOPT_MIME_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 315
comptime CURLOPT_SSH_HOST_KEY_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 316
comptime CURLOPT_SSH_HOST_KEY_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 317
comptime CURLOPT_PROTOCOLS_STR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 318
comptime CURLOPT_REDIR_PROTOCOLS_STR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 319
comptime CURLOPT_WS_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 320
comptime CURLOPT_CA_CACHE_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 321
comptime CURLOPT_QUICK_EXIT: CURLoption = CURLOPTTYPE_LONG + 322
comptime CURLOPT_HAPROXY_CLIENT_IP: CURLoption = CURLOPTTYPE_OBJECTPOINT + 323
comptime CURLOPT_SERVER_RESPONSE_TIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 324
comptime CURLOPT_ECH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 325
comptime CURLOPT_TCP_KEEPCNT: CURLoption = CURLOPTTYPE_LONG + 326
comptime CURLOPT_UPLOAD_FLAGS: CURLoption = CURLOPTTYPE_LONG + 327
comptime CURLOPT_SSL_SIGNATURE_ALGORITHMS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 328

comptime CURL_IPRESOLVE_WHATEVER: c_int = 0
comptime CURL_IPRESOLVE_V4: c_int = 1
comptime CURL_IPRESOLVE_V6: c_int = 2

comptime CURLSSLOPT_ALLOW_BEAST: c_long = 1 << 0
comptime CURLSSLOPT_NO_REVOKE: c_long = 1 << 1
comptime CURLSSLOPT_NO_PARTIALCHAIN: c_long = 1 << 2
comptime CURLSSLOPT_REVOKE_BEST_EFFORT: c_long = 1 << 3
comptime CURLSSLOPT_NATIVE_CA: c_long = 1 << 4
comptime CURLSSLOPT_AUTO_CLIENT_CERT: c_long = 1 << 5

# These enums are for use with the CURLOPT_HTTP_VERSION option.
# Setting this means we don't care, and that we'd like the library to choose the best possible for us!
comptime CURL_HTTP_VERSION_NONE: c_int = 0
"""Please use HTTP 1.0 in the request."""
comptime CURL_HTTP_VERSION_1_0: c_int = 1
"""Please use HTTP 1.1 in the request."""
comptime CURL_HTTP_VERSION_1_1: c_int = 2
"""Please use HTTP 2 in the request."""
comptime CURL_HTTP_VERSION_2_0: c_int = 3
"""Use version 2 for HTTPS, version 1.1 for HTTP."""
comptime CURL_HTTP_VERSION_2TLS: c_int = 4
"""Please use HTTP 2 without HTTP/1.1 Upgrade."""
comptime CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE: c_int = 5
"""Use HTTP/3, fallback to HTTP/2 or HTTP/1 if needed."""
comptime CURL_HTTP_VERSION_3: c_int = 30

comptime CURL_SSLVERSION_DEFAULT: c_long = 0
comptime CURL_SSLVERSION_TLSv1: c_long = 1
comptime CURL_SSLVERSION_SSLv2: c_long = 2
comptime CURL_SSLVERSION_SSLv3: c_long = 3
comptime CURL_SSLVERSION_TLSv1_0: c_long = 4
comptime CURL_SSLVERSION_TLSv1_1: c_long = 5
comptime CURL_SSLVERSION_TLSv1_2: c_long = 6
comptime CURL_SSLVERSION_TLSv1_3: c_long = 7

comptime CURLOPT_READDATA: CURLoption = CURLOPT_INFILE
comptime CURLOPT_WRITEDATA: CURLoption = CURLOPT_FILE
comptime CURLOPT_HEADERDATA: CURLoption = CURLOPT_WRITEHEADER

comptime curl_TimeCond = c_int
comptime CURL_TIMECOND_NONE: curl_TimeCond = 0
comptime CURL_TIMECOND_IFMODSINCE: curl_TimeCond = 1
comptime CURL_TIMECOND_IFUNMODSINCE: curl_TimeCond = 2
comptime CURL_TIMECOND_LASTMOD: curl_TimeCond = 3

comptime CURLformoption = c_int
comptime CURLFORM_NOTHING: CURLformoption = 0
comptime CURLFORM_COPYNAME: CURLformoption = 1
comptime CURLFORM_PTRNAME: CURLformoption = 2
comptime CURLFORM_NAMELENGTH: CURLformoption = 3
comptime CURLFORM_COPYCONTENTS: CURLformoption = 4
comptime CURLFORM_PTRCONTENTS: CURLformoption = 5
comptime CURLFORM_CONTENTSLENGTH: CURLformoption = 6
comptime CURLFORM_FILECONTENT: CURLformoption = 7
comptime CURLFORM_ARRAY: CURLformoption = 8
comptime CURLFORM_OBSOLETE: CURLformoption = 9
comptime CURLFORM_FILE: CURLformoption = 10
comptime CURLFORM_BUFFER: CURLformoption = 11
comptime CURLFORM_BUFFERPTR: CURLformoption = 12
comptime CURLFORM_BUFFERLENGTH: CURLformoption = 13
comptime CURLFORM_CONTENTTYPE: CURLformoption = 14
comptime CURLFORM_CONTENTHEADER: CURLformoption = 15
comptime CURLFORM_FILENAME: CURLformoption = 16
comptime CURLFORM_END: CURLformoption = 17
comptime CURLFORM_STREAM: CURLformoption = 19

comptime CURLFORMcode = c_int
comptime CURL_FORMADD_OK: CURLFORMcode = 0
comptime CURL_FORMADD_MEMORY: CURLFORMcode = 1
comptime CURL_FORMADD_OPTION_TWICE: CURLFORMcode = 2
comptime CURL_FORMADD_NULL: CURLFORMcode = 3
comptime CURL_FORMADD_UNKNOWN_OPTION: CURLFORMcode = 4
comptime CURL_FORMADD_INCOMPLETE: CURLFORMcode = 5
comptime CURL_FORMADD_ILLEGAL_ARRAY: CURLFORMcode = 6
comptime CURL_FORMADD_DISABLED: CURLFORMcode = 7

comptime CURL_REDIR_POST_301: c_ulong = 1
comptime CURL_REDIR_POST_302: c_ulong = 2
comptime CURL_REDIR_POST_303: c_ulong = 4
comptime CURL_REDIR_POST_ALL: c_ulong = (CURL_REDIR_POST_301 | CURL_REDIR_POST_302 | CURL_REDIR_POST_303)


struct curl_forms():
    var option: CURLformoption
    var value: ImmutExternalPointer[c_char]

comptime curl_formget_callback = def(MutExternalPointer[c_char], ImmutExternalPointer[NoneType], c_size_t) abi("C") thin -> c_int

struct curl_slist(TrivialRegisterPassable):
    """Singly linked list structure for curl string lists."""

    var data: MutExternalPointer[c_char]
    """Pointer to the data string for this node."""
    var next: MutExternalPointer[curl_slist]
    """Pointer to the next node in the list."""

struct curl_certinfo:
    var num_of_certs: c_int
    """Number of certificates in the certinfo list."""
    var certinfo: MutExternalPointer[MutExternalPointer[curl_slist]]
    """Pointer to an array of pointers to curl_slist structures, each representing a certificate's information."""

comptime curl_sslbackend = c_int
comptime CURLSSLBACKEND_NONE: curl_sslbackend = 0
comptime CURLSSLBACKEND_OPENSSL: curl_sslbackend = 1
comptime CURLSSLBACKEND_GNUTLS: curl_sslbackend = 2
comptime CURLSSLBACKEND_NSS: curl_sslbackend = 3
comptime CURLSSLBACKEND_QSOSSL: curl_sslbackend = 4
comptime CURLSSLBACKEND_GSKIT: curl_sslbackend = 5
comptime CURLSSLBACKEND_POLARSSL: curl_sslbackend = 6
comptime CURLSSLBACKEND_CYASSL: curl_sslbackend = 7
comptime CURLSSLBACKEND_SCHANNEL: curl_sslbackend = 8
comptime CURLSSLBACKEND_DARWINSSL: curl_sslbackend = 9


struct curl_tlssessioninfo:
    """Structure to hold TLS session information for a connection."""
    var backend: curl_sslbackend
    """The SSL backend used for the TLS session."""
    var internals: MutExternalPointer[NoneType]
    """Pointer to backend-specific internal data for the TLS session."""

comptime CURLINFO_STRING: CURLINFO = 0x100000
comptime CURLINFO_LONG: CURLINFO = 0x200000
comptime CURLINFO_DOUBLE: CURLINFO = 0x300000
comptime CURLINFO_SLIST: CURLINFO = 0x400000
comptime CURLINFO_PTR: CURLINFO = 0x400000 # same as SLIST
comptime CURLINFO_SOCKET: CURLINFO = 0x500000
comptime CURLINFO_OFF_T: CURLINFO = 0x600000
comptime CURLINFO_MASK: CURLINFO = 0x0fffff
comptime CURLINFO_TYPEMASK: CURLINFO = 0xf00000

comptime CURLINFO_EFFECTIVE_URL: CURLINFO = CURLINFO_STRING + 1
comptime CURLINFO_RESPONSE_CODE: CURLINFO = CURLINFO_LONG + 2
comptime CURLINFO_TOTAL_TIME: CURLINFO = CURLINFO_DOUBLE + 3
comptime CURLINFO_NAMELOOKUP_TIME: CURLINFO = CURLINFO_DOUBLE + 4
comptime CURLINFO_CONNECT_TIME: CURLINFO = CURLINFO_DOUBLE + 5
comptime CURLINFO_PRETRANSFER_TIME: CURLINFO = CURLINFO_DOUBLE + 6
comptime CURLINFO_SIZE_UPLOAD: CURLINFO = CURLINFO_DOUBLE + 7
comptime CURLINFO_SIZE_DOWNLOAD: CURLINFO = CURLINFO_DOUBLE + 8
comptime CURLINFO_SPEED_DOWNLOAD: CURLINFO = CURLINFO_DOUBLE + 9
comptime CURLINFO_SPEED_UPLOAD: CURLINFO = CURLINFO_DOUBLE + 10
comptime CURLINFO_HEADER_SIZE: CURLINFO = CURLINFO_LONG + 11
comptime CURLINFO_REQUEST_SIZE: CURLINFO = CURLINFO_LONG + 12
comptime CURLINFO_SSL_VERIFYRESULT: CURLINFO = CURLINFO_LONG + 13
comptime CURLINFO_FILETIME: CURLINFO = CURLINFO_LONG + 14
comptime CURLINFO_CONTENT_LENGTH_DOWNLOAD: CURLINFO = CURLINFO_DOUBLE + 15
comptime CURLINFO_CONTENT_LENGTH_UPLOAD: CURLINFO = CURLINFO_DOUBLE + 16
comptime CURLINFO_STARTTRANSFER_TIME: CURLINFO = CURLINFO_DOUBLE + 17
comptime CURLINFO_CONTENT_TYPE: CURLINFO = CURLINFO_STRING + 18
comptime CURLINFO_REDIRECT_TIME: CURLINFO = CURLINFO_DOUBLE + 19
comptime CURLINFO_REDIRECT_COUNT: CURLINFO = CURLINFO_LONG + 20
comptime CURLINFO_PRIVATE: CURLINFO = CURLINFO_STRING + 21
comptime CURLINFO_HTTP_CONNECTCODE: CURLINFO = CURLINFO_LONG + 22
comptime CURLINFO_HTTPAUTH_AVAIL: CURLINFO = CURLINFO_LONG + 23
comptime CURLINFO_PROXYAUTH_AVAIL: CURLINFO = CURLINFO_LONG + 24
comptime CURLINFO_OS_ERRNO: CURLINFO = CURLINFO_LONG + 25
comptime CURLINFO_NUM_CONNECTS: CURLINFO = CURLINFO_LONG + 26
comptime CURLINFO_SSL_ENGINES: CURLINFO = CURLINFO_SLIST + 27
comptime CURLINFO_COOKIELIST: CURLINFO = CURLINFO_SLIST + 28
comptime CURLINFO_LASTSOCKET: CURLINFO = CURLINFO_LONG + 29
comptime CURLINFO_FTP_ENTRY_PATH: CURLINFO = CURLINFO_STRING + 30
comptime CURLINFO_REDIRECT_URL: CURLINFO = CURLINFO_STRING + 31
comptime CURLINFO_PRIMARY_IP: CURLINFO = CURLINFO_STRING + 32
comptime CURLINFO_APPCONNECT_TIME: CURLINFO = CURLINFO_DOUBLE + 33
comptime CURLINFO_CERTINFO: CURLINFO = CURLINFO_SLIST + 34
comptime CURLINFO_CONDITION_UNMET: CURLINFO = CURLINFO_LONG + 35
comptime CURLINFO_RTSP_SESSION_ID: CURLINFO = CURLINFO_STRING + 36
comptime CURLINFO_RTSP_CLIENT_CSEQ: CURLINFO = CURLINFO_LONG + 37
comptime CURLINFO_RTSP_SERVER_CSEQ: CURLINFO = CURLINFO_LONG + 38
comptime CURLINFO_RTSP_CSEQ_RECV: CURLINFO = CURLINFO_LONG + 39
comptime CURLINFO_PRIMARY_PORT: CURLINFO = CURLINFO_LONG + 40
comptime CURLINFO_LOCAL_IP: CURLINFO = CURLINFO_STRING + 41
comptime CURLINFO_LOCAL_PORT: CURLINFO = CURLINFO_LONG + 42
comptime CURLINFO_TLS_SESSION: CURLINFO = CURLINFO_SLIST + 43
comptime CURLINFO_ACTIVESOCKET: CURLINFO = CURLINFO_SOCKET + 44
comptime CURLINFO_TLS_SSL_PTR: CURLINFO = CURLINFO_PTR + 45
comptime CURLINFO_HTTP_VERSION: CURLINFO = CURLINFO_LONG + 46
comptime CURLINFO_PROXY_SSL_VERIFYRESULT: CURLINFO = CURLINFO_LONG + 47
comptime CURLINFO_PROTOCOL: CURLINFO = CURLINFO_LONG + 48  # CURL_DEPRECATED(7.85.0, "Use CURLINFO_SCHEME")
comptime CURLINFO_SCHEME: CURLINFO = CURLINFO_STRING + 49
comptime CURLINFO_TOTAL_TIME_T: CURLINFO = CURLINFO_OFF_T + 50
comptime CURLINFO_NAMELOOKUP_TIME_T: CURLINFO = CURLINFO_OFF_T + 51
comptime CURLINFO_CONNECT_TIME_T: CURLINFO = CURLINFO_OFF_T + 52
comptime CURLINFO_PRETRANSFER_TIME_T: CURLINFO = CURLINFO_OFF_T + 53
comptime CURLINFO_STARTTRANSFER_TIME_T: CURLINFO = CURLINFO_OFF_T + 54
comptime CURLINFO_REDIRECT_TIME_T: CURLINFO = CURLINFO_OFF_T + 55
comptime CURLINFO_APPCONNECT_TIME_T: CURLINFO = CURLINFO_OFF_T + 56
comptime CURLINFO_RETRY_AFTER: CURLINFO = CURLINFO_OFF_T + 57
comptime CURLINFO_EFFECTIVE_METHOD: CURLINFO = CURLINFO_STRING + 58
comptime CURLINFO_PROXY_ERROR: CURLINFO = CURLINFO_LONG + 59
comptime CURLINFO_REFERER: CURLINFO = CURLINFO_STRING + 60
comptime CURLINFO_CAINFO: CURLINFO = CURLINFO_STRING + 61
comptime CURLINFO_CAPATH: CURLINFO = CURLINFO_STRING + 62
comptime CURLINFO_XFER_ID: CURLINFO = CURLINFO_OFF_T + 63
comptime CURLINFO_CONN_ID: CURLINFO = CURLINFO_OFF_T + 64
comptime CURLINFO_QUEUE_TIME_T: CURLINFO = CURLINFO_OFF_T + 65
comptime CURLINFO_USED_PROXY: CURLINFO = CURLINFO_LONG + 66
comptime CURLINFO_POSTTRANSFER_TIME_T: CURLINFO = CURLINFO_OFF_T + 67
comptime CURLINFO_EARLYDATA_SENT_T: CURLINFO = CURLINFO_OFF_T + 68
comptime CURLINFO_HTTPAUTH_USED: CURLINFO = CURLINFO_LONG + 69
comptime CURLINFO_PROXYAUTH_USED: CURLINFO = CURLINFO_LONG + 70
comptime CURLINFO_SIZE_DELIVERED: CURLINFO = CURLINFO_OFF_T + 71

comptime curl_closepolicy = c_int
comptime CURLCLOSEPOLICY_NONE: curl_closepolicy = 0
comptime CURLCLOSEPOLICY_OLDEST: curl_closepolicy = 1
comptime CURLCLOSEPOLICY_LEAST_RECENTLY_USED: curl_closepolicy = 2
comptime CURLCLOSEPOLICY_LEAST_TRAFFIC: curl_closepolicy = 3
comptime CURLCLOSEPOLICY_SLOWEST: curl_closepolicy = 4
comptime CURLCLOSEPOLICY_CALLBACK: curl_closepolicy = 5

comptime CURL_GLOBAL_SSL: c_long = 1 << 0
comptime CURL_GLOBAL_WIN32: c_long = 1 << 1
comptime CURL_GLOBAL_ALL: c_long = CURL_GLOBAL_SSL | CURL_GLOBAL_WIN32
comptime CURL_GLOBAL_NOTHING: c_long = 0
comptime CURL_GLOBAL_DEFAULT: c_long = CURL_GLOBAL_ALL
comptime CURL_GLOBAL_ACK_EINTR: c_long = 1 << 2

comptime curl_lock_data = c_int
comptime CURL_LOCK_DATA_NONE: curl_lock_data = 0
comptime CURL_LOCK_DATA_SHARE: curl_lock_data = 1
comptime CURL_LOCK_DATA_COOKIE: curl_lock_data = 2
comptime CURL_LOCK_DATA_DNS: curl_lock_data = 3
comptime CURL_LOCK_DATA_SSL_SESSION: curl_lock_data = 4
comptime CURL_LOCK_DATA_CONNECT: curl_lock_data = 5

comptime curl_lock_access = c_int
comptime CURL_LOCK_ACCESS_NONE: curl_lock_access = 0
comptime CURL_LOCK_ACCESS_SHARED: curl_lock_access = 1
comptime CURL_LOCK_ACCESS_SINGLE: curl_lock_access = 2

comptime curl_lock_function = def(CURL, curl_lock_data, curl_lock_access, MutExternalPointer[NoneType]) abi("C") thin -> NoneType
comptime curl_unlock_function = def(CURL, curl_lock_data, MutExternalPointer[NoneType]) abi("C") thin -> NoneType

comptime CURLSH = MutExternalPointer[NoneType]

comptime CURLSHcode = c_int
comptime CURLSHE_OK: CURLSHcode = 0
comptime CURLSHE_BAD_OPTION: CURLSHcode = 1
comptime CURLSHE_IN_USE: CURLSHcode = 2
comptime CURLSHE_INVALID: CURLSHcode = 3
comptime CURLSHE_NOMEM: CURLSHcode = 4
comptime CURLSHE_NOT_BUILT_IN: CURLSHcode = 5

comptime CURLSHoption = c_int
comptime CURLSHOPT_NONE: CURLSHoption = 0
comptime CURLSHOPT_SHARE: CURLSHoption = 1
comptime CURLSHOPT_UNSHARE: CURLSHoption = 2
comptime CURLSHOPT_LOCKFUNC: CURLSHoption = 3
comptime CURLSHOPT_UNLOCKFUNC: CURLSHoption = 4
comptime CURLSHOPT_USERDATA: CURLSHoption = 5

comptime CURLVERSION_FIRST: CURLversion = 0
comptime CURLVERSION_SECOND: CURLversion = 1
comptime CURLVERSION_THIRD: CURLversion = 2
comptime CURLVERSION_FOURTH: CURLversion = 3
comptime CURLVERSION_FIFTH: CURLversion = 4
comptime CURLVERSION_SIXTH: CURLversion = 5
comptime CURLVERSION_SEVENTH: CURLversion = 6
comptime CURLVERSION_EIGHTH: CURLversion = 7
comptime CURLVERSION_NINTH: CURLversion = 8
comptime CURLVERSION_TENTH: CURLversion = 9
comptime CURLVERSION_ELEVENTH: CURLversion = 10
comptime CURLVERSION_TWELFTH: CURLversion = 11
comptime CURLVERSION_NOW: CURLversion = CURLVERSION_TWELFTH


@fieldwise_init
struct curl_version_info_data:
    """Version information structure returned by curl_version_info."""

    var age: c_int
    """The size of this struct, allowing for future expansion without breaking old programs."""
    var version: ImmutExternalPointer[c_char]
    """The version of libcurl in use."""
    var version_num: c_uint
    """Numeric version of libcurl multiplied by 100000. It makes it easy to compare versions, without needing to parse a string and to deal with alpha/beta suffixes."""
    var host: ImmutExternalPointer[c_char]
    """Host name libcurl was built for."""
    var features: c_int
    """Bitmask of available features, see below."""
    var ssl_version: ImmutExternalPointer[c_char]
    """Version of SSL library in use, or "none" if no SSL support was compiled in."""
    var ssl_version_num: c_long
    """Numeric version of SSL library multiplied by 100000. It makes it easy to compare versions, without needing to parse a string and to deal with alpha/beta suffixes."""
    var libz_version: ImmutExternalPointer[c_char]
    """Version of libz in use, or "none" if no libz support was compiled in."""
    var protocols: ImmutExternalPointer[ImmutExternalPointer[c_char]]
    """Protocols supported by libcurl, null-terminated array of null-terminated strings."""
    var ares: ImmutExternalPointer[c_char]
    """Version of c-ares in use, or "none" if no c-ares support was compiled in."""
    var ares_num: c_int
    """Numeric version of c-ares multiplied by 100000. It makes it easy to compare versions, without needing to parse a string and to deal with alpha/beta suffixes."""
    var libidn: ImmutExternalPointer[c_char]
    """Version of libidn in use, or "none" if no libidn support was compiled in."""
    var iconv_ver_num: c_int
    """Numeric version of iconv multiplied by 100000. It makes it easy to compare versions, without needing to parse a string and to deal with alpha/beta suffixes."""
    var libssh_version: ImmutExternalPointer[c_char]
    """Version of libssh in use, or "none" if no libssh support was compiled in."""
    var brotli_ver_num: c_uint
    """Numeric version of brotli multiplied by 100000. It makes it easy to compare versions, without needing to parse a string and to deal with alpha/beta suffixes."""
    var brotli_version: ImmutExternalPointer[c_char]
    """Version of brotli in use, or "none" if no brotli support was compiled in."""
    var nghttp2_ver_num: c_uint
    """Numeric version of nghttp2 multiplied by 100000. It makes it easy to compare versions, without needing to parse a string and to deal with alpha/beta suffixes."""
    var nghttp2_version: ImmutExternalPointer[c_char]
    """Version of nghttp2 in use, or "none" if no nghttp2 support was compiled in."""
    var quic_version: ImmutExternalPointer[c_char]
    """Version of quic in use, or "none" if no quic support was compiled in."""
    var cainfo: ImmutExternalPointer[c_char]
    """CA bundle version. It is the file name of the CA bundle in use, or "none" if no CA bundle is in use."""
    var capath: ImmutExternalPointer[c_char]
    """CA path version. It is the directory name of the CA path in use, or "none" if no CA path is in use."""
    var zstd_ver_num: c_uint
    """Numeric version of zstd multiplied by 100000. It makes it easy to compare versions, without needing to parse a string and to deal with alpha/beta suffixes."""
    var zstd_version: ImmutExternalPointer[c_char]
    """Version of zstd in use, or "none" if no zstd support was compiled in."""
    var hyper_version: ImmutExternalPointer[c_char]
    """Version of hyper in use, or "none" if no hyper support was compiled in."""
    var gsasl_version: ImmutExternalPointer[c_char]
    """Version of gsasl in use, or "none" if no gsasl support was compiled in."""
    var feature_names: ImmutExternalPointer[ImmutExternalPointer[c_char]]
    """Null-terminated array of null-terminated strings, each describing a feature that libcurl supports. The features are described in the same order as the bits in the features field, so if the first bit in features is set, the first string in this array describes that feature."""
    var rtmp_version: ImmutExternalPointer[c_char]
    """Version of RTMP in use, or "none" if no RTMP support was compiled in."""


comptime CURL_VERSION_IPV6: c_int = 1 << 0
comptime CURL_VERSION_KERBEROS4: c_int = 1 << 1
comptime CURL_VERSION_SSL: c_int = 1 << 2
comptime CURL_VERSION_LIBZ: c_int = 1 << 3
comptime CURL_VERSION_NTLM: c_int = 1 << 4
comptime CURL_VERSION_GSSNEGOTIATE: c_int = 1 << 5
comptime CURL_VERSION_DEBUG: c_int = 1 << 6
comptime CURL_VERSION_ASYNCHDNS: c_int = 1 << 7
comptime CURL_VERSION_SPNEGO: c_int = 1 << 8
comptime CURL_VERSION_LARGEFILE: c_int = 1 << 9
comptime CURL_VERSION_IDN: c_int = 1 << 10
comptime CURL_VERSION_SSPI: c_int = 1 << 11
comptime CURL_VERSION_CONV: c_int = 1 << 12
comptime CURL_VERSION_CURLDEBUG: c_int = 1 << 13
comptime CURL_VERSION_TLSAUTH_SRP: c_int = 1 << 14
comptime CURL_VERSION_NTLM_WB: c_int = 1 << 15
comptime CURL_VERSION_HTTP2: c_int = 1 << 16
comptime CURL_VERSION_UNIX_SOCKETS: c_int = 1 << 19
comptime CURL_VERSION_HTTPS_PROXY: c_int = 1 << 21
comptime CURL_VERSION_BROTLI: c_int = 1 << 23
comptime CURL_VERSION_ALTSVC: c_int = 1 << 24
comptime CURL_VERSION_HTTP3: c_int = 1 << 25
comptime CURL_VERSION_ZSTD: c_int = 1 << 26
comptime CURL_VERSION_UNICODE: c_int = 1 << 27
comptime CURL_VERSION_HSTS: c_int = 1 << 28
comptime CURL_VERSION_GSASL: c_int = 1 << 29

comptime CURLPAUSE_RECV: c_int = 1 << 0
comptime CURLPAUSE_RECV_CONT: c_int = 0
comptime CURLPAUSE_SEND: c_int = 1 << 2
comptime CURLPAUSE_SEND_CONT: c_int = 0

comptime CURLM = MutExternalPointer[NoneType]

comptime CURLMcode = c_int
comptime CURLM_CALL_MULTI_PERFORM: CURLMcode = -1
comptime CURLM_OK: CURLMcode = 0
comptime CURLM_BAD_HANDLE: CURLMcode = 1
comptime CURLM_BAD_EASY_HANDLE: CURLMcode = 2
comptime CURLM_OUT_OF_MEMORY: CURLMcode = 3
comptime CURLM_INTERNAL_ERROR: CURLMcode = 4
comptime CURLM_BAD_SOCKET: CURLMcode = 5
comptime CURLM_UNKNOWN_OPTION: CURLMcode = 6
comptime CURLM_ADDED_ALREADY: CURLMcode = 7

comptime CURLMSG = c_int
comptime CURLMSG_NONE: CURLMSG = 0
comptime CURLMSG_DONE: CURLMSG = 1

struct CURLMsg:
    """Message structure used in multi interface to report completed transfers."""
    var msg: CURLMSG
    """The message type, currently only CURLMSG_DONE is used."""
    var easy_handle: MutExternalPointer[NoneType]
    """Pointer to the easy handle that completed the transfer."""
    var data: MutExternalPointer[NoneType]
    """Pointer to private data associated with the transfer, set by the application when the handle was added to the multi handle."""

comptime CURL_WAIT_POLLIN: c_short = 0x1
comptime CURL_WAIT_POLLPRI: c_short = 0x2
comptime CURL_WAIT_POLLOUT: c_short = 0x4

struct curl_waitfd:
    """Structure used to specify a file descriptor and the events to wait for in the multi interface."""
    var fd: curl_socket_t
    """The file descriptor to wait on."""
    var events: c_short
    """Bitmask of events to wait for, using CURL_WAIT_POLLIN, CURL_WAIT_POLLPRI, and/or CURL_WAIT_POLLOUT."""
    var revents: c_short
    """Bitmask of events that occurred, set by the library when the wait is complete."""

comptime CURL_POLL_NONE: c_int = 0
comptime CURL_POLL_IN: c_int = 1
comptime CURL_POLL_OUT: c_int = 2
comptime CURL_POLL_INOUT: c_int = 3
comptime CURL_POLL_REMOVE: c_int = 4
comptime CURL_CSELECT_IN: c_int = 1
comptime CURL_CSELECT_OUT: c_int = 2
comptime CURL_CSELECT_ERR: c_int = 4
comptime CURL_SOCKET_TIMEOUT: curl_socket_t = CURL_SOCKET_BAD

comptime curl_socket_callback = def(CURL, curl_socket_t, c_int, MutExternalPointer[NoneType], MutExternalPointer[NoneType]) abi("C") thin -> c_int
comptime curl_multi_timer_callback = def(CURLM, c_long, MutExternalPointer[NoneType]) abi("C") thin -> c_int

comptime CURLMoption = c_int
comptime CURLMOPT_SOCKETFUNCTION: CURLMoption = CURLOPTTYPE_FUNCTIONPOINT + 1
comptime CURLMOPT_SOCKETDATA: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 2
comptime CURLMOPT_PIPELINING: CURLMoption = CURLOPTTYPE_LONG + 3
comptime CURLMOPT_TIMERFUNCTION: CURLMoption = CURLOPTTYPE_FUNCTIONPOINT + 4
comptime CURLMOPT_TIMERDATA: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 5
comptime CURLMOPT_MAXCONNECTS: CURLMoption = CURLOPTTYPE_LONG + 6
comptime CURLMOPT_MAX_HOST_CONNECTIONS: CURLMoption = CURLOPTTYPE_LONG + 7
comptime CURLMOPT_MAX_PIPELINE_LENGTH: CURLMoption = CURLOPTTYPE_LONG + 8
comptime CURLMOPT_CONTENT_LENGTH_PENALTY_SIZE: CURLMoption = CURLOPTTYPE_OFF_T + 9
comptime CURLMOPT_CHUNK_LENGTH_PENALTY_SIZE: CURLMoption = CURLOPTTYPE_OFF_T + 10
comptime CURLMOPT_PIPELINING_SITE_BL: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 11
comptime CURLMOPT_PIPELINING_SERVER_BL: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 12
comptime CURLMOPT_MAX_TOTAL_CONNECTIONS: CURLMoption = CURLOPTTYPE_LONG + 13
comptime CURLMOPT_PUSHFUNCTION: CURLMoption = CURLOPTTYPE_FUNCTIONPOINT + 14
comptime CURLMOPT_PUSHDATA: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 15
comptime CURLMOPT_MAX_CONCURRENT_STREAMS: CURLMoption = CURLOPTTYPE_LONG + 16

# These enums are for use with the CURLMOPT_PIPELINING option.
comptime CURLPIPE_NOTHING: c_long = 0
comptime CURLPIPE_HTTP1: c_long = 1
comptime CURLPIPE_MULTIPLEX: c_long = 2

comptime CURL_ERROR_SIZE: UInt = 256

comptime curl_opensocket_callback = def(CURL, curlsocktype, MutExternalPointer[curl_sockaddr]) abi("C") thin -> curl_socket_t
comptime curlsocktype = c_int
"""Enumeration of socket types used in `CURLOPT_OPENSOCKETFUNCTION` callback."""
comptime CURLSOCKTYPE_IPCXN: curlsocktype = 0
"""Socket created for a specific IP connection."""
comptime CURLSOCKTYPE_ACCEPT: curlsocktype = 1
"""Socket created by accept() call."""

comptime sa_family_t = c_ushort
"""Address family type."""

struct sockaddr(TrivialRegisterPassable):
    """Struct representing a socket address."""
    var sa_family: sa_family_t
    """Address family (e.g., AF_INET for IPv4, AF_INET6 for IPv6)."""
    var sa_data: StaticTuple[c_char, 14]
    """Address data (14 bytes, typically used for storing the actual address and port)."""

    def __init__(
        out self,
        family: sa_family_t = 0,
        data: StaticTuple[c_char, 14] = StaticTuple[c_char, 14](),
    ):
        """Initializes a `sockaddr` struct with the given address family and data.
        
        Args:
            family: The address family (e.g., AF_INET for IPv4, AF_INET6 for IPv6).
            data: The address data (14 bytes, typically used for storing the actual address and port).
        """
        self.sa_family = family
        self.sa_data = data


struct curl_sockaddr():
    var family: c_int
    var socktype: c_int
    var protocol: c_int
    var addrlen: c_uint
    """Length of the address in bytes. This was a `socklen_t` type before 7.18.0 but it turned really ugly and painful on the systems that lack this type."""
    var addr: sockaddr
    """The actual address. The size of this field is determined by the `addrlen` field."""
