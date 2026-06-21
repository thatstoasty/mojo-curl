"""CURL C type definitions and constants from libcurl."""

from std.ffi import c_char, c_int, c_long, c_size_t, c_uint, c_ulong, c_short, c_ushort
from std.utils import StaticTuple

comptime ImmutExternalPointer = ImmutUnsafePointer[origin=ImmutUntrackedOrigin, ...]
"""Type alias for immutable external pointers to untrackedorigin memory.

Parameters:
    type: The pointee type, inferred from usage context.
    address_space: The address space, fixed to untracked origin.
"""
comptime MutExternalPointer = MutUnsafePointer[origin=MutUntrackedOrigin, ...]
"""Type alias for mutable external pointers to untracked origin memory.

Parameters:
    type: The pointee type, inferred from usage context.
    address_space: The address space, fixed to untracked origin.
"""

# Type aliases for curl
comptime CURL = MutExternalPointer[NoneType]
"""Opaque pointer type for CURL easy handles."""

comptime CURLoption = c_int
"""Type alias for CURL option enumeration."""
comptime CURLINFO = c_int
"""Type alias for CURL info enumeration."""
comptime CURLcode = c_int
"""Type alias for CURL result codes."""
comptime CURLversion = c_int
"""Type alias for CURL version enumeration."""
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

comptime curl_progress_callback = def(ImmutExternalPointer[NoneType], Float64, Float64, Float64, Float64) abi(
    "C"
) thin -> c_int
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

comptime curl_write_callback = def(MutExternalPointer[c_char], c_size_t, c_size_t, MutExternalPointer[NoneType]) abi(
    "C"
) thin -> c_size_t
"""This is the prototype for the write callback function used by curl. It matches the `CURLOPT_WRITEFUNCTION` prototype and can also be used where a generic read/write signature is needed."""

comptime curlfiletype = c_int
"""Enumeration of file types in FTP wildcard matching."""
comptime CURLFILETYPE_FILE: curlfiletype = 0
"""File type is a regular file."""
comptime CURLFILETYPE_DIRECTORY: curlfiletype = 1
"""File type is a directory."""
comptime CURLFILETYPE_SYMLINK: curlfiletype = 2
"""File type is a symbolic link."""
comptime CURLFILETYPE_DEVICE_BLOCK: curlfiletype = 3
"""File type is a block device."""
comptime CURLFILETYPE_DEVICE_CHAR: curlfiletype = 4
"""File type is a character device."""
comptime CURLFILETYPE_NAMEDPIPE: curlfiletype = 5
"""File type is a named pipe (FIFO)."""
comptime CURLFILETYPE_SOCKET: curlfiletype = 6
"""File type is a socket."""
comptime CURLFILETYPE_DOOR: curlfiletype = 7
"""File type is a Solaris door."""
comptime CURLFILETYPE_UNKNOWN: curlfiletype = 8
"""File type is unknown."""

comptime CURLFINFOFLAG_KNOWN_FILENAME: c_uint = 1 << 0
"""The filename field is known."""
comptime CURLFINFOFLAG_KNOWN_FILETYPE: c_uint = 1 << 1
"""The filetype field is known."""
comptime CURLFINFOFLAG_KNOWN_TIME: c_uint = 1 << 2
"""The time field is known."""
comptime CURLFINFOFLAG_KNOWN_PERM: c_uint = 1 << 3
"""The permissions field is known."""
comptime CURLFINFOFLAG_KNOWN_UID: c_uint = 1 << 4
"""The UID field is known."""
comptime CURLFINFOFLAG_KNOWN_GID: c_uint = 1 << 5
"""The GID field is known."""
comptime CURLFINFOFLAG_KNOWN_SIZE: c_uint = 1 << 6
"""The size field is known."""
comptime CURLFINFOFLAG_KNOWN_HLINKCOUNT: c_uint = 1 << 7
"""The hard link count field is known."""


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
"""Blob flag to not copy the data."""
comptime CURL_BLOB_COPY: c_uint = 1
"""Blob flag to copy the data."""


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

comptime curl_chunk_bgn_callback = def(ImmutExternalPointer[NoneType], MutExternalPointer[NoneType], c_int) abi(
    "C"
) thin -> c_long
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

comptime curl_fnmatch_callback = def(
    MutExternalPointer[NoneType], ImmutExternalPointer[c_char], ImmutExternalPointer[c_char]
) abi("C") thin -> c_int
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
comptime curl_read_callback = def(MutExternalPointer[c_char], c_size_t, c_size_t, MutExternalPointer[NoneType]) abi(
    "C"
) thin -> c_size_t
"""This is the prototype for the read callback function used by curl. It matches the `CURLOPT_READFUNCTION` prototype, where the first argument is a writable buffer that the callback must fill."""

comptime CURL_TRAILERFUNC_OK: c_int = 0
"""Return code for when the trailing headers' callback has terminated without any errors."""
comptime CURL_TRAILERFUNC_ABORT: c_int = 1
"""Return code for when there was an error in the trailing header's list and we want to abort the request."""
comptime TrailerCallbackFn = def(MutExternalPointer[MutExternalPointer[curl_slist]], MutExternalPointer[NoneType]) abi(
    "C"
) thin -> c_int
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
"""Callback for malloc memory allocation."""
comptime curl_free_callback = def(ptr: MutExternalPointer[NoneType]) abi("C") thin -> None
"""Callback for free memory deallocation."""
comptime curl_realloc_callback = def(ptr: MutExternalPointer[NoneType], size: c_size_t) abi(
    "C"
) thin -> MutExternalPointer[NoneType]
"""Callback for realloc memory reallocation."""
comptime curl_strdup_callback = def(str: ImmutExternalPointer[c_char]) abi("C") thin -> MutExternalPointer[c_char]
"""Callback for strdup string duplication."""
comptime curl_calloc_callback = def(nmemb: c_size_t, size: c_size_t) abi("C") thin -> MutExternalPointer[NoneType]
"""Callback for calloc memory allocation with initialization."""


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

comptime curl_debug_callback = def(CURL, c_int, MutExternalPointer[c_char], c_size_t, MutExternalPointer[NoneType]) abi(
    "C"
) thin -> c_int
"""This is the prototype for the debug callback function used by curl. It is used for `CURLOPT_DEBUGFUNCTION`."""

comptime CURLE_OK: CURLcode = 0
"""Operation completed successfully."""
comptime CURLE_UNSUPPORTED_PROTOCOL: CURLcode = 1
"""Unsupported protocol."""
comptime CURLE_FAILED_INIT: CURLcode = 2
"""Failed to initialize."""
comptime CURLE_URL_MALFORMAT: CURLcode = 3
"""URL format was not correct."""
comptime CURLE_NOT_BUILT_IN: CURLcode = 4
"""Feature requested is not built in."""
comptime CURLE_COULDNT_RESOLVE_PROXY: CURLcode = 5
"""Could not resolve proxy."""
comptime CURLE_COULDNT_RESOLVE_HOST: CURLcode = 6
"""Could not resolve host."""
comptime CURLE_COULDNT_CONNECT: CURLcode = 7
"""Could not connect to host."""
comptime CURLE_FTP_WEIRD_SERVER_REPLY: CURLcode = 8
"""FTP server returned a weird 4xx response."""
comptime CURLE_REMOTE_ACCESS_DENIED: CURLcode = 9
"""Remote access denied."""
comptime CURLE_FTP_ACCEPT_FAILED: CURLcode = 10
"""FTP PORT command failed."""
comptime CURLE_FTP_WEIRD_PASS_REPLY: CURLcode = 11
"""FTP server returned a weird PASS reply."""
comptime CURLE_FTP_ACCEPT_TIMEOUT: CURLcode = 12
"""FTP server timeout."""
comptime CURLE_FTP_WEIRD_PASV_REPLY: CURLcode = 13
"""FTP server returned a weird PASV reply."""
comptime CURLE_FTP_WEIRD_227_FORMAT: CURLcode = 14
"""FTP server returned a weird 227 format."""
comptime CURLE_FTP_CANT_GET_HOST: CURLcode = 15
"""FTP could not get the hostname."""
comptime CURLE_HTTP2: CURLcode = 16
"""HTTP/2 error."""
comptime CURLE_FTP_COULDNT_SET_TYPE: CURLcode = 17
"""FTP could not set file type."""
comptime CURLE_PARTIAL_FILE: CURLcode = 18
"""Partial file received."""
comptime CURLE_FTP_COULDNT_RETR_FILE: CURLcode = 19
"""FTP could not retrieve the file."""
comptime CURLE_OBSOLETE20: CURLcode = 20
"""Obsolete error code."""
comptime CURLE_QUOTE_ERROR: CURLcode = 21
"""Quote command error."""
comptime CURLE_HTTP_RETURNED_ERROR: CURLcode = 22
"""HTTP returned an error."""
comptime CURLE_WRITE_ERROR: CURLcode = 23
"""Write error."""
comptime CURLE_OBSOLETE24: CURLcode = 24
"""Obsolete error code."""
comptime CURLE_UPLOAD_FAILED: CURLcode = 25
"""Upload failed."""
comptime CURLE_READ_ERROR: CURLcode = 26
"""Read error."""
comptime CURLE_OUT_OF_MEMORY: CURLcode = 27
"""Out of memory."""
comptime CURLE_OPERATION_TIMEDOUT: CURLcode = 28
"""Operation timeout."""
comptime CURLE_OBSOLETE29: CURLcode = 29
"""Obsolete error code."""
comptime CURLE_FTP_PORT_FAILED: CURLcode = 30
"""FTP PORT command failed."""
comptime CURLE_FTP_COULDNT_USE_REST: CURLcode = 31
"""FTP could not use REST."""
comptime CURLE_OBSOLETE32: CURLcode = 32
"""Obsolete error code."""
comptime CURLE_RANGE_ERROR: CURLcode = 33
"""Range error."""
comptime CURLE_HTTP_POST_ERROR: CURLcode = 34
"""HTTP POST error."""
comptime CURLE_SSL_CONNECT_ERROR: CURLcode = 35
"""SSL connection error."""
comptime CURLE_BAD_DOWNLOAD_RESUME: CURLcode = 36
"""Bad download resume."""
comptime CURLE_FILE_COULDNT_READ_FILE: CURLcode = 37
"""Could not read file."""
comptime CURLE_LDAP_CANNOT_BIND: CURLcode = 38
"""LDAP cannot bind."""
comptime CURLE_LDAP_SEARCH_FAILED: CURLcode = 39
"""LDAP search failed."""
comptime CURLE_OBSOLETE40: CURLcode = 40
"""Obsolete error code."""
comptime CURLE_FUNCTION_NOT_FOUND: CURLcode = 41
"""Function not found."""
comptime CURLE_ABORTED_BY_CALLBACK: CURLcode = 42
"""Aborted by callback."""
comptime CURLE_BAD_FUNCTION_ARGUMENT: CURLcode = 43
"""Bad function argument."""
comptime CURLE_OBSOLETE44: CURLcode = 44
"""Obsolete error code."""
comptime CURLE_INTERFACE_FAILED: CURLcode = 45
"""Interface failed."""
comptime CURLE_OBSOLETE46: CURLcode = 46
"""Obsolete error code."""
comptime CURLE_TOO_MANY_REDIRECTS: CURLcode = 47
"""Too many redirects."""
comptime CURLE_UNKNOWN_OPTION: CURLcode = 48
"""Unknown option."""
comptime CURLE_TELNET_OPTION_SYNTAX: CURLcode = 49
"""Telnet option syntax error."""
comptime CURLE_OBSOLETE50: CURLcode = 50
"""Obsolete error code."""
comptime CURLE_PEER_FAILED_VERIFICATION: CURLcode = 60
"""Peer verification failed."""
comptime CURLE_GOT_NOTHING: CURLcode = 52
"""Got nothing."""
comptime CURLE_SSL_ENGINE_NOTFOUND: CURLcode = 53
"""SSL engine not found."""
comptime CURLE_SSL_ENGINE_SETFAILED: CURLcode = 54
"""SSL engine set failed."""
comptime CURLE_SEND_ERROR: CURLcode = 55
"""Send error."""
comptime CURLE_RECV_ERROR: CURLcode = 56
"""Receive error."""
comptime CURLE_OBSOLETE57: CURLcode = 57
"""Obsolete error code."""
comptime CURLE_SSL_CERTPROBLEM: CURLcode = 58
"""SSL certificate problem."""
comptime CURLE_SSL_CIPHER: CURLcode = 59
"""SSL cipher error."""
comptime CURLE_SSL_CACERT: CURLcode = 60
"""SSL CA certificate problem."""
comptime CURLE_BAD_CONTENT_ENCODING: CURLcode = 61
"""Bad content encoding."""
comptime CURLE_LDAP_INVALID_URL: CURLcode = 62
"""Invalid LDAP URL."""
comptime CURLE_FILESIZE_EXCEEDED: CURLcode = 63
"""File size exceeded."""
comptime CURLE_USE_SSL_FAILED: CURLcode = 64
"""SSL failed."""
comptime CURLE_SEND_FAIL_REWIND: CURLcode = 65
"""Send failed (rewind)."""
comptime CURLE_SSL_ENGINE_INITFAILED: CURLcode = 66
"""SSL engine initialization failed."""
comptime CURLE_LOGIN_DENIED: CURLcode = 67
"""Login denied."""
comptime CURLE_TFTP_NOTFOUND: CURLcode = 68
"""TFTP file not found."""
comptime CURLE_TFTP_PERM: CURLcode = 69
"""TFTP permission denied."""
comptime CURLE_REMOTE_DISK_FULL: CURLcode = 70
"""Remote disk full."""
comptime CURLE_TFTP_ILLEGAL: CURLcode = 71
"""TFTP illegal operation."""
comptime CURLE_TFTP_UNKNOWNID: CURLcode = 72
"""TFTP unknown ID."""
comptime CURLE_REMOTE_FILE_EXISTS: CURLcode = 73
"""Remote file exists."""
comptime CURLE_TFTP_NOSUCHUSER: CURLcode = 74
"""TFTP no such user."""
comptime CURLE_CONV_FAILED: CURLcode = 75
"""Conversion failed."""
comptime CURLE_CONV_REQD: CURLcode = 76
"""Conversion required."""
comptime CURLE_SSL_CACERT_BADFILE: CURLcode = 77
"""SSL CA certificate bad file."""
comptime CURLE_REMOTE_FILE_NOT_FOUND: CURLcode = 78
"""Remote file not found."""
comptime CURLE_SSH: CURLcode = 79
"""SSH error."""
comptime CURLE_SSL_SHUTDOWN_FAILED: CURLcode = 80
"""SSL shutdown failed."""
comptime CURLE_AGAIN: CURLcode = 81
"""Again."""
comptime CURLE_SSL_CRL_BADFILE: CURLcode = 82
"""SSL CRL bad file."""
comptime CURLE_SSL_ISSUER_ERROR: CURLcode = 83
"""SSL issuer error."""
comptime CURLE_FTP_PRET_FAILED: CURLcode = 84
"""FTP PRET command failed."""
comptime CURLE_RTSP_CSEQ_ERROR: CURLcode = 85
"""RTSP CSEQ mismatch."""
comptime CURLE_RTSP_SESSION_ERROR: CURLcode = 86
"""RTSP session error."""
comptime CURLE_FTP_BAD_FILE_LIST: CURLcode = 87
"""FTP bad file list."""
comptime CURLE_CHUNK_FAILED: CURLcode = 88
"""Chunk failed."""
comptime CURLE_NO_CONNECTION_AVAILABLE: CURLcode = 89
"""No connection available."""
comptime CURLE_SSL_PINNEDPUBKEYNOTMATCH: CURLcode = 90
"""SSL pinned public key not match."""
comptime CURLE_SSL_INVALIDCERTSTATUS: CURLcode = 91
"""SSL invalid certificate status."""
comptime CURLE_HTTP2_STREAM: CURLcode = 92
"""HTTP/2 stream error."""
comptime CURLE_RECURSIVE_API_CALL: CURLcode = 93
"""Recursive API call."""

comptime curl_conv_callback = def(MutExternalPointer[c_char], c_size_t, MutExternalPointer[NoneType]) abi(
    "C"
) thin -> c_int
"""Callback function for character conversion."""
comptime curl_ssl_ctx_callback = def(CURL, MutExternalPointer[NoneType], MutExternalPointer[NoneType]) abi(
    "C"
) thin -> CURLcode
"""Callback function for SSL context customization."""

comptime curl_proxytype = c_int
"""Enumeration of proxy types."""
comptime CURLPROXY_HTTP: curl_proxytype = 0
"""HTTP proxy type."""
comptime CURLPROXY_HTTP_1_0: curl_proxytype = 1
"""HTTP 1.0 proxy type."""
comptime CURLPROXY_SOCKS4: curl_proxytype = 4
"""SOCKS4 proxy type."""
comptime CURLPROXY_SOCKS5: curl_proxytype = 5
"""SOCKS5 proxy type."""
comptime CURLPROXY_SOCKS4A: curl_proxytype = 6
"""SOCKS4a proxy type."""
comptime CURLPROXY_SOCKS5_HOSTNAME: curl_proxytype = 7
"""SOCKS5 proxy with hostname support."""

comptime CURLAUTH_NONE: c_ulong = 0
"""No authentication."""
comptime CURLAUTH_BASIC: c_ulong = 1 << 0
"""HTTP Basic authentication."""
comptime CURLAUTH_DIGEST: c_ulong = 1 << 1
"""HTTP Digest authentication."""
comptime CURLAUTH_GSSNEGOTIATE: c_ulong = 1 << 2
"""GSS-Negotiate authentication."""
comptime CURLAUTH_NTLM: c_ulong = 1 << 3
"""NTLM authentication."""
comptime CURLAUTH_DIGEST_IE: c_ulong = 1 << 4
"""HTTP Digest authentication (IE version)."""
comptime CURLAUTH_NTLM_WB: c_ulong = 1 << 5
"""NTLM authentication with WinBind."""
comptime CURLAUTH_AWS_SIGV4: c_ulong = 1 << 7
"""AWS Signature Version 4 authentication."""
comptime CURLAUTH_ONLY: c_ulong = 1 << 31
"""Only use the authentication type requested."""
comptime CURLAUTH_ANY: c_ulong = (~CURLAUTH_DIGEST_IE) & c_ulong(0xFFFFFFFF)
"""Any authentication type."""
comptime CURLAUTH_ANYSAFE: c_ulong = (~(CURLAUTH_BASIC | CURLAUTH_DIGEST_IE)) & c_ulong(0xFFFFFFFF)
"""Any safe authentication type."""

comptime CURLSSH_AUTH_ANY: c_ulong = c_ulong(0xFFFFFFFF)
"""Any SSH authentication method."""
comptime CURLSSH_AUTH_NONE: c_ulong = 0
"""No SSH authentication."""
comptime CURLSSH_AUTH_PUBLICKEY: c_ulong = 1 << 0
"""SSH public key authentication."""
comptime CURLSSH_AUTH_PASSWORD: c_ulong = 1 << 1
"""SSH password authentication."""
comptime CURLSSH_AUTH_HOST: c_ulong = 1 << 2
"""SSH host-based authentication."""
comptime CURLSSH_AUTH_KEYBOARD: c_ulong = 1 << 3
"""SSH keyboard-interactive authentication."""
comptime CURLSSH_AUTH_AGENT: c_ulong = 1 << 4
"""SSH authentication agent."""
comptime CURLSSH_AUTH_DEFAULT: c_ulong = CURLSSH_AUTH_ANY
"""Default SSH authentication methods."""

comptime CURLGSSAPI_DELEGATION_NONE: c_ulong = 0
"""No GSSAPI delegation."""
comptime CURLGSSAPI_DELEGATION_POLICY_FLAG: c_ulong = 1 << 0
"""GSSAPI delegation policy flag."""
comptime CURLGSSAPI_DELEGATION_FLAG: c_ulong = 1 << 1
"""GSSAPI delegation flag."""

comptime CURL_NETRC_IGNORED: c_ulong = 0
"""Ignore the .netrc file."""
comptime CURL_NETRC_OPTIONAL: c_ulong = 1
"""Use .netrc file if it exists."""
comptime CURL_NETRC_REQUIRED: c_ulong = 2
"""Use .netrc file and fail if it does not exist."""

comptime curl_usessl = c_int
"""Enumeration of SSL usage options."""
comptime CURLUSESSL_NONE: curl_usessl = 0
"""Do not attempt to use SSL."""
comptime CURLUSESSL_TRY: curl_usessl = 1
"""Try using SSL, but do not require it."""
comptime CURLUSESSL_CONTROL: curl_usessl = 2
"""Require SSL for the control connection."""
comptime CURLUSESSL_ALL: curl_usessl = 3
"""Require SSL for all connections."""

comptime CURLPROTO_HTTP: c_int = 1 << 0
"""HTTP protocol."""
comptime CURLPROTO_HTTPS: c_int = 1 << 1
"""HTTPS protocol."""
comptime CURLPROTO_FILE: c_int = 1 << 10
"""FILE protocol."""

comptime CURLOPTTYPE_LONG: CURLoption = 0
"""Long integer option type."""
comptime CURLOPTTYPE_OBJECTPOINT: CURLoption = 10_000
"""Object pointer option type."""
comptime CURLOPTTYPE_FUNCTIONPOINT: CURLoption = 20_000
"""Function pointer option type."""
comptime CURLOPTTYPE_OFF_T: CURLoption = 30_000
"""Offset type option."""
comptime CURLOPTTYPE_BLOB: CURLoption = 40_000
"""Binary blob option type."""
comptime CURLOPTTYPE_VALUES: CURLoption = CURLOPTTYPE_LONG
"""Values option type."""

comptime CURLOPT_FILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 1
"""Custom pointer passed to the write callback as its last argument."""
comptime CURLOPT_URL: CURLoption = CURLOPTTYPE_OBJECTPOINT + 2
"""The URL to fetch or upload to."""
comptime CURLOPT_PORT: CURLoption = CURLOPTTYPE_LONG + 3
"""The port number to connect to, overriding the one in the URL."""
comptime CURLOPT_PROXY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 4
"""The proxy to use, in the form `[scheme://][user:password@]host[:port]`."""
comptime CURLOPT_USERPWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 5
"""The `user:password` pair to use for the connection."""
comptime CURLOPT_PROXYUSERPWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 6
"""The `user:password` pair to use for proxy authentication."""
comptime CURLOPT_RANGE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 7
"""The byte range(s) to request from the server, e.g. `0-499`."""
comptime CURLOPT_INFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 9
"""Custom pointer passed to the read callback as its last argument."""
comptime CURLOPT_ERRORBUFFER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 10
"""A buffer to store human-readable error messages in, at least `CURL_ERROR_SIZE` bytes."""
comptime CURLOPT_WRITEFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 11
"""The callback function invoked to write received data."""
comptime CURLOPT_READFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 12
"""The callback function invoked to read data to be uploaded."""
comptime CURLOPT_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 13
"""The maximum time in seconds the entire transfer is allowed to take."""
comptime CURLOPT_INFILESIZE: CURLoption = CURLOPTTYPE_LONG + 14
"""The expected size in bytes of the file to upload."""
comptime CURLOPT_POSTFIELDS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 15
"""The full data to send in an HTTP POST request."""
comptime CURLOPT_REFERER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 16
"""The value to use for the `Referer` HTTP header."""
comptime CURLOPT_FTPPORT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 17
"""The value for the FTP `PORT` command, enabling active FTP mode."""
comptime CURLOPT_USERAGENT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 18
"""The value to use for the `User-Agent` HTTP header."""
comptime CURLOPT_LOW_SPEED_LIMIT: CURLoption = CURLOPTTYPE_LONG + 19
"""The minimum transfer speed in bytes/second below which the transfer is aborted."""
comptime CURLOPT_LOW_SPEED_TIME: CURLoption = CURLOPTTYPE_LONG + 20
"""The duration in seconds the transfer speed may stay at or below `CURLOPT_LOW_SPEED_LIMIT` before aborting."""
comptime CURLOPT_RESUME_FROM: CURLoption = CURLOPTTYPE_LONG + 21
"""The byte offset to resume a download or upload from."""
comptime CURLOPT_COOKIE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 22
"""The contents of the `Cookie` HTTP header to send."""
comptime CURLOPT_HTTPHEADER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 23
"""A linked list of extra HTTP headers to send with the request."""
comptime CURLOPT_HTTPPOST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 24
"""A linked list specifying a multipart/formdata HTTP POST."""
comptime CURLOPT_SSLCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 25
"""The path to the SSL client certificate file."""
comptime CURLOPT_KEYPASSWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 26
"""The password for the SSL private key or certificate."""
comptime CURLOPT_CRLF: CURLoption = CURLOPTTYPE_LONG + 27
"""Whether to convert Unix newlines to CRLF when uploading."""
comptime CURLOPT_QUOTE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 28
"""A linked list of commands to run on the server before the transfer."""
comptime CURLOPT_WRITEHEADER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 29
"""Custom pointer passed to the header callback as its last argument."""
comptime CURLOPT_COOKIEFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 31
"""The path to a file to read cookies from."""
comptime CURLOPT_SSLVERSION: CURLoption = CURLOPTTYPE_LONG + 32
"""The SSL/TLS version to use for the connection."""
comptime CURLOPT_TIMECONDITION: CURLoption = CURLOPTTYPE_LONG + 33
"""The condition to apply when using `CURLOPT_TIMEVALUE` (e.g. modified since/before)."""
comptime CURLOPT_TIMEVALUE: CURLoption = CURLOPTTYPE_LONG + 34
"""The time value, in seconds since the epoch, used together with `CURLOPT_TIMECONDITION`."""
comptime CURLOPT_CUSTOMREQUEST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 36
"""A custom request method string to use instead of the default (e.g. `DELETE`)."""
comptime CURLOPT_STDERR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 37
"""The stream to use instead of stderr for messages from libcurl."""
comptime CURLOPT_POSTQUOTE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 39
"""A linked list of commands to run on the server after the transfer."""
# deprecated - has no effect
comptime CURLOPT_WRITEINFO: CURLoption = 9999
"""Deprecated and has no effect."""
comptime CURLOPT_VERBOSE: CURLoption = CURLOPTTYPE_LONG + 41
"""Whether to enable detailed informational output during the transfer."""
comptime CURLOPT_HEADER: CURLoption = CURLOPTTYPE_LONG + 42
"""Whether to include the response headers in the body output."""
comptime CURLOPT_NOPROGRESS: CURLoption = CURLOPTTYPE_LONG + 43
"""Whether to disable the progress meter for the transfer."""
comptime CURLOPT_NOBODY: CURLoption = CURLOPTTYPE_LONG + 44
"""Whether to exclude the response body from the output."""
comptime CURLOPT_FAILONERROR: CURLoption = CURLOPTTYPE_LONG + 45
"""Whether to fail silently (return an error) on HTTP response codes >= 400."""
comptime CURLOPT_UPLOAD: CURLoption = CURLOPTTYPE_LONG + 46
"""Whether to prepare for an upload rather than a download."""
comptime CURLOPT_POST: CURLoption = CURLOPTTYPE_LONG + 47
"""Whether to perform an HTTP POST request."""
comptime CURLOPT_DIRLISTONLY: CURLoption = CURLOPTTYPE_LONG + 48
"""Whether to list only the names of files in an FTP/POP3/IMAP directory."""
comptime CURLOPT_APPEND: CURLoption = CURLOPTTYPE_LONG + 50
"""Whether to append to the remote file instead of overwriting it when uploading."""
comptime CURLOPT_NETRC: CURLoption = CURLOPTTYPE_LONG + 51
"""Whether and how to use a `.netrc` file for credentials."""
comptime CURLOPT_FOLLOWLOCATION: CURLoption = CURLOPTTYPE_LONG + 52
"""Whether to follow HTTP 3xx redirects."""
comptime CURLOPT_TRANSFERTEXT: CURLoption = CURLOPTTYPE_LONG + 53
"""Whether to use ASCII/text transfer mode for FTP transfers."""
comptime CURLOPT_PUT: CURLoption = CURLOPTTYPE_LONG + 54
"""Whether to perform an HTTP PUT request."""
comptime CURLOPT_PROGRESSFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 56
"""The deprecated callback function invoked to report transfer progress."""
comptime CURLOPT_PROGRESSDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 57
"""Custom pointer passed to the progress callback as its last argument."""
comptime CURLOPT_AUTOREFERER: CURLoption = CURLOPTTYPE_LONG + 58
"""Whether to automatically set the `Referer` header when following redirects."""
comptime CURLOPT_PROXYPORT: CURLoption = CURLOPTTYPE_LONG + 59
"""The port number of the proxy to connect to."""
comptime CURLOPT_POSTFIELDSIZE: CURLoption = CURLOPTTYPE_LONG + 60
"""The size in bytes of the data set with `CURLOPT_POSTFIELDS`."""
comptime CURLOPT_HTTPPROXYTUNNEL: CURLoption = CURLOPTTYPE_LONG + 61
"""Whether to tunnel all operations through the HTTP proxy."""
comptime CURLOPT_INTERFACE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 62
"""The outgoing network interface to use for the connection."""
comptime CURLOPT_KRBLEVEL: CURLoption = CURLOPTTYPE_OBJECTPOINT + 63
"""The Kerberos security level to use for FTP transfers."""
comptime CURLOPT_SSL_VERIFYPEER: CURLoption = CURLOPTTYPE_LONG + 64
"""Whether to verify the peer's SSL certificate."""
comptime CURLOPT_CAINFO: CURLoption = CURLOPTTYPE_OBJECTPOINT + 65
"""The path to a file holding one or more CA certificates to verify the peer with."""
comptime CURLOPT_MAXREDIRS: CURLoption = CURLOPTTYPE_LONG + 68
"""The maximum number of redirects to follow."""
comptime CURLOPT_FILETIME: CURLoption = CURLOPTTYPE_LONG + 69
"""Whether to retrieve the remote file's modification time."""
comptime CURLOPT_TELNETOPTIONS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 70
"""A linked list of Telnet options to send to the server."""
comptime CURLOPT_MAXCONNECTS: CURLoption = CURLOPTTYPE_LONG + 71
"""The maximum size of the connection cache to keep in memory."""
# deprecated - has no effect
comptime CURLOPT_CLOSEPOLICY: CURLoption = 9999
"""Deprecated and has no effect."""
comptime CURLOPT_FRESH_CONNECT: CURLoption = CURLOPTTYPE_LONG + 74
"""Whether to force the use of a new connection rather than a cached one."""
comptime CURLOPT_FORBID_REUSE: CURLoption = CURLOPTTYPE_LONG + 75
"""Whether to close the connection after use instead of caching it for reuse."""
comptime CURLOPT_RANDOM_FILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 76
"""The path to a file used to seed the random number generator for SSL."""
comptime CURLOPT_EGDSOCKET: CURLoption = CURLOPTTYPE_OBJECTPOINT + 77
"""The path to an EGD socket used to seed the random number generator for SSL."""
comptime CURLOPT_CONNECTTIMEOUT: CURLoption = CURLOPTTYPE_LONG + 78
"""The maximum time in seconds allowed for the connection phase."""
comptime CURLOPT_HEADERFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 79
"""The callback function invoked to handle received header data."""
comptime CURLOPT_HTTPGET: CURLoption = CURLOPTTYPE_LONG + 80
"""Whether to reset the request method to HTTP GET."""
comptime CURLOPT_SSL_VERIFYHOST: CURLoption = CURLOPTTYPE_LONG + 81
"""Whether to verify the certificate's name against the host."""
comptime CURLOPT_COOKIEJAR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 82
"""The path to a file to save cookies to when the handle is closed."""
comptime CURLOPT_SSL_CIPHER_LIST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 83
"""The list of ciphers to use for the SSL connection."""
comptime CURLOPT_HTTP_VERSION: CURLoption = CURLOPTTYPE_LONG + 84
"""The HTTP protocol version to prefer when negotiating with the server."""
comptime CURLOPT_FTP_USE_EPSV: CURLoption = CURLOPTTYPE_LONG + 85
"""Whether to attempt the EPSV command when doing passive FTP transfers."""
comptime CURLOPT_SSLCERTTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 86
"""The format of the SSL client certificate, e.g. `PEM` or `DER`."""
comptime CURLOPT_SSLKEY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 87
"""The path to the private key file for the SSL client certificate."""
comptime CURLOPT_SSLKEYTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 88
"""The format of the private key file, e.g. `PEM`, `DER`, or `ENG`."""
comptime CURLOPT_SSLENGINE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 89
"""The identifier of the SSL engine to use for cryptographic operations."""
comptime CURLOPT_SSLENGINE_DEFAULT: CURLoption = CURLOPTTYPE_LONG + 90
"""Whether to make the SSL engine set with `CURLOPT_SSLENGINE` the default for crypto operations."""
comptime CURLOPT_DNS_USE_GLOBAL_CACHE: CURLoption = CURLOPTTYPE_LONG + 91
"""Deprecated option for the global DNS cache; has no effect."""
comptime CURLOPT_DNS_CACHE_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 92
"""The lifetime in seconds of DNS cache entries."""
comptime CURLOPT_PREQUOTE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 93
"""A linked list of commands to run on the server prior to an FTP transfer, after the transfer type is set."""
comptime CURLOPT_DEBUGFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 94
"""The callback function invoked to receive debug information about the transfer."""
comptime CURLOPT_DEBUGDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 95
"""Custom pointer passed to the debug callback as its last argument."""
comptime CURLOPT_COOKIESESSION: CURLoption = CURLOPTTYPE_LONG + 96
"""Whether to start a new cookie session, ignoring previously loaded session cookies."""
comptime CURLOPT_CAPATH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 97
"""The path to a directory holding multiple CA certificates to verify the peer with."""
comptime CURLOPT_BUFFERSIZE: CURLoption = CURLOPTTYPE_LONG + 98
"""The preferred size in bytes of the receive buffer."""
comptime CURLOPT_NOSIGNAL: CURLoption = CURLOPTTYPE_LONG + 99
"""Whether to disable signal handling installed by libcurl, e.g. for timeouts."""
comptime CURLOPT_SHARE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 100
"""A share handle to use for sharing data such as cookies and DNS cache between handles."""
comptime CURLOPT_PROXYTYPE: CURLoption = CURLOPTTYPE_LONG + 101
"""The type of proxy to use, e.g. HTTP or SOCKS."""
comptime CURLOPT_ACCEPT_ENCODING: CURLoption = CURLOPTTYPE_OBJECTPOINT + 102
"""The contents of the `Accept-Encoding` header, enabling automatic content decoding."""
comptime CURLOPT_PRIVATE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 103
"""A private pointer to store and retrieve with the handle, unused by libcurl itself."""
comptime CURLOPT_HTTP200ALIASES: CURLoption = CURLOPTTYPE_OBJECTPOINT + 104
"""A linked list of strings to treat as equivalent to an HTTP 200 response."""
comptime CURLOPT_UNRESTRICTED_AUTH: CURLoption = CURLOPTTYPE_LONG + 105
"""Whether to continue sending authentication credentials when following redirects to a different host."""
comptime CURLOPT_FTP_USE_EPRT: CURLoption = CURLOPTTYPE_LONG + 106
"""Whether to attempt the EPRT command when doing active FTP transfers."""
comptime CURLOPT_HTTPAUTH: CURLoption = CURLOPTTYPE_LONG + 107
"""The HTTP authentication method(s) to use."""
comptime CURLOPT_SSL_CTX_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 108
"""The callback function invoked to allow direct configuration of the SSL context."""
comptime CURLOPT_SSL_CTX_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 109
"""Custom pointer passed to the SSL context callback as its last argument."""
comptime CURLOPT_FTP_CREATE_MISSING_DIRS: CURLoption = CURLOPTTYPE_LONG + 110
"""Whether to create missing directories on the remote FTP server when uploading."""
comptime CURLOPT_PROXYAUTH: CURLoption = CURLOPTTYPE_LONG + 111
"""The HTTP authentication method(s) to use for the proxy."""
comptime CURLOPT_FTP_RESPONSE_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 112
"""The maximum time in seconds to wait for an FTP server response."""
comptime CURLOPT_IPRESOLVE: CURLoption = CURLOPTTYPE_LONG + 113
"""Which IP version(s) to use when resolving host names."""
comptime CURLOPT_MAXFILESIZE: CURLoption = CURLOPTTYPE_LONG + 114
"""The maximum allowed size in bytes of a file to download."""
comptime CURLOPT_INFILESIZE_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 115
"""The expected size in bytes of the file to upload, as a large file offset."""
comptime CURLOPT_RESUME_FROM_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 116
"""The byte offset to resume a download or upload from, as a large file offset."""
comptime CURLOPT_MAXFILESIZE_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 117
"""The maximum allowed size in bytes of a file to download, as a large file offset."""
comptime CURLOPT_NETRC_FILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 118
"""The path to a custom `.netrc` file to use instead of the default location."""
comptime CURLOPT_USE_SSL: CURLoption = CURLOPTTYPE_LONG + 119
"""The level of SSL/TLS usage to require for FTP, SMTP, POP3, or IMAP connections."""
comptime CURLOPT_POSTFIELDSIZE_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 120
"""The size in bytes of the data set with `CURLOPT_POSTFIELDS`, as a large file offset."""
comptime CURLOPT_TCP_NODELAY: CURLoption = CURLOPTTYPE_LONG + 121
"""Whether to disable the TCP Nagle algorithm on the connection."""
comptime CURLOPT_FTPSSLAUTH: CURLoption = CURLOPTTYPE_LONG + 129
"""The order in which to try `SSL` and `TLS` for `AUTH TLS`/`AUTH SSL` with FTP."""
comptime CURLOPT_IOCTLFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 130
"""The deprecated callback function used to control the data stream during transfer."""
comptime CURLOPT_IOCTLDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 131
"""Custom pointer passed to the ioctl callback as its last argument."""
comptime CURLOPT_FTP_ACCOUNT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 134
"""The account information string to send via the FTP `ACCT` command."""
comptime CURLOPT_COOKIELIST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 135
"""A cookie command or cookie added to the internal cookie storage, or a request for cookie state."""
comptime CURLOPT_IGNORE_CONTENT_LENGTH: CURLoption = CURLOPTTYPE_LONG + 136
"""Whether to ignore the `Content-Length` header in the response."""
comptime CURLOPT_FTP_SKIP_PASV_IP: CURLoption = CURLOPTTYPE_LONG + 137
"""Whether to ignore the IP address returned in the FTP server's `227` response to `PASV`."""
comptime CURLOPT_FTP_FILEMETHOD: CURLoption = CURLOPTTYPE_LONG + 138
"""The method libcurl should use to reach a file on an FTP server."""
comptime CURLOPT_LOCALPORT: CURLoption = CURLOPTTYPE_LONG + 139
"""The preferred local port number to use for the connection."""
comptime CURLOPT_LOCALPORTRANGE: CURLoption = CURLOPTTYPE_LONG + 140
"""The number of attempted local ports to try, starting from `CURLOPT_LOCALPORT`."""
comptime CURLOPT_CONNECT_ONLY: CURLoption = CURLOPTTYPE_LONG + 141
"""Whether to stop after the connection phase, without performing a transfer."""
comptime CURLOPT_CONV_FROM_NETWORK_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 142
"""The deprecated callback function used to convert data from network to host encoding."""
comptime CURLOPT_CONV_TO_NETWORK_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 143
"""The deprecated callback function used to convert data from host to network encoding."""
comptime CURLOPT_CONV_FROM_UTF8_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 144
"""The deprecated callback function used to convert data from UTF-8 to host encoding."""
comptime CURLOPT_MAX_SEND_SPEED_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 145
"""The maximum upload speed in bytes/second, as a large file offset."""
comptime CURLOPT_MAX_RECV_SPEED_LARGE: CURLoption = CURLOPTTYPE_OFF_T + 146
"""The maximum download speed in bytes/second, as a large file offset."""
comptime CURLOPT_FTP_ALTERNATIVE_TO_USER: CURLoption = CURLOPTTYPE_OBJECTPOINT + 147
"""An alternative string to send to the FTP server instead of the `USER` command."""
comptime CURLOPT_SOCKOPTFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 148
"""The callback function invoked after a socket is created but before connecting."""
comptime CURLOPT_SOCKOPTDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 149
"""Custom pointer passed to the sockopt callback as its last argument."""
comptime CURLOPT_SSL_SESSIONID_CACHE: CURLoption = CURLOPTTYPE_LONG + 150
"""Whether to enable libcurl's in-memory cache of SSL session IDs."""
comptime CURLOPT_SSH_AUTH_TYPES: CURLoption = CURLOPTTYPE_LONG + 151
"""The SSH authentication method(s) to allow for an SFTP/SCP connection."""
comptime CURLOPT_SSH_PUBLIC_KEYFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 152
"""The path to the public key file used for SSH authentication."""
comptime CURLOPT_SSH_PRIVATE_KEYFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 153
"""The path to the private key file used for SSH authentication."""
comptime CURLOPT_FTP_SSL_CCC: CURLoption = CURLOPTTYPE_LONG + 154
"""Whether and how to send a `CCC` (Clear Command Channel) after an FTPS authentication."""
comptime CURLOPT_TIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 155
"""The maximum time in milliseconds the entire transfer is allowed to take."""
comptime CURLOPT_CONNECTTIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 156
"""The maximum time in milliseconds allowed for the connection phase."""
comptime CURLOPT_HTTP_TRANSFER_DECODING: CURLoption = CURLOPTTYPE_LONG + 157
"""Whether to automatically decode `Transfer-Encoding` content."""
comptime CURLOPT_HTTP_CONTENT_DECODING: CURLoption = CURLOPTTYPE_LONG + 158
"""Whether to automatically decode `Content-Encoding` content."""
comptime CURLOPT_NEW_FILE_PERMS: CURLoption = CURLOPTTYPE_LONG + 159
"""The permission bits to use when creating a new remote file."""
comptime CURLOPT_NEW_DIRECTORY_PERMS: CURLoption = CURLOPTTYPE_LONG + 160
"""The permission bits to use when creating a new remote directory."""
comptime CURLOPT_POSTREDIR: CURLoption = CURLOPTTYPE_LONG + 161
"""Which HTTP request methods to switch to after a redirect following a POST."""
comptime CURLOPT_SSH_HOST_PUBLIC_KEY_MD5: CURLoption = CURLOPTTYPE_OBJECTPOINT + 162
"""The MD5 checksum of the remote SSH host's public key, used for verification."""
comptime CURLOPT_OPENSOCKETFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 163
"""The callback function invoked to create a socket for the connection."""
comptime CURLOPT_OPENSOCKETDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 164
"""Custom pointer passed to the open-socket callback as its last argument."""
comptime CURLOPT_COPYPOSTFIELDS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 165
"""The data to send in an HTTP POST request, copied internally by libcurl."""
comptime CURLOPT_PROXY_TRANSFER_MODE: CURLoption = CURLOPTTYPE_LONG + 166
"""Whether to add the FTP transfer mode (`type=A`/`type=I`) to the proxy-tunneled URL."""
comptime CURLOPT_SEEKFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 167
"""The callback function invoked to seek within the input data being uploaded."""
comptime CURLOPT_SEEKDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 168
"""Custom pointer passed to the seek callback as its last argument."""
comptime CURLOPT_CRLFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 169
"""The path to a file containing a certificate revocation list to verify the peer with."""
comptime CURLOPT_ISSUERCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 170
"""The path to a file holding the issuer certificate to verify against the peer certificate."""
comptime CURLOPT_ADDRESS_SCOPE: CURLoption = CURLOPTTYPE_LONG + 171
"""The scope ID to use for IPv6 link-local and site-local addresses."""
comptime CURLOPT_CERTINFO: CURLoption = CURLOPTTYPE_LONG + 172
"""Whether to gather certificate chain information, retrievable via `CURLINFO_CERTINFO`."""
comptime CURLOPT_USERNAME: CURLoption = CURLOPTTYPE_OBJECTPOINT + 173
"""The username to use for the connection's authentication."""
comptime CURLOPT_PASSWORD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 174
"""The password to use for the connection's authentication."""
comptime CURLOPT_PROXYUSERNAME: CURLoption = CURLOPTTYPE_OBJECTPOINT + 175
"""The username to use for proxy authentication."""
comptime CURLOPT_PROXYPASSWORD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 176
"""The password to use for proxy authentication."""
comptime CURLOPT_NOPROXY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 177
"""A comma-separated list of hosts that should bypass the proxy."""
comptime CURLOPT_TFTP_BLKSIZE: CURLoption = CURLOPTTYPE_LONG + 178
"""The block size to request for TFTP transfers."""
comptime CURLOPT_SOCKS5_GSSAPI_SERVICE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 179
"""The SOCKS5 proxy's GSS-API service name (deprecated; use `CURLOPT_PROXY_SERVICE_NAME`)."""
comptime CURLOPT_SOCKS5_GSSAPI_NEC: CURLoption = CURLOPTTYPE_LONG + 180
"""Whether to enable insecure NEC reference implementation behavior for SOCKS5 GSS-API."""
comptime CURLOPT_PROTOCOLS: CURLoption = CURLOPTTYPE_LONG + 181
"""Deprecated bitmask of protocols libcurl is allowed to use for the transfer."""
comptime CURLOPT_REDIR_PROTOCOLS: CURLoption = CURLOPTTYPE_LONG + 182
"""Deprecated bitmask of protocols libcurl is allowed to follow to via redirects."""
comptime CURLOPT_SSH_KNOWNHOSTS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 183
"""The path to a file containing known SSH host public key fingerprints."""
comptime CURLOPT_SSH_KEYFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 184
"""The callback function invoked when libcurl needs to check an SSH host's key."""
comptime CURLOPT_SSH_KEYDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 185
"""Custom pointer passed to the SSH key callback as its last argument."""
comptime CURLOPT_MAIL_FROM: CURLoption = CURLOPTTYPE_OBJECTPOINT + 186
"""The address to use for the SMTP `MAIL FROM` command."""
comptime CURLOPT_MAIL_RCPT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 187
"""A linked list of recipient addresses for the SMTP `RCPT TO` command."""
comptime CURLOPT_FTP_USE_PRET: CURLoption = CURLOPTTYPE_LONG + 188
"""Whether to send a `PRET` command before `PASV` on FTP transfers."""
comptime CURLOPT_RTSP_REQUEST: CURLoption = CURLOPTTYPE_LONG + 189
"""The RTSP request method to use."""
comptime CURLOPT_RTSP_SESSION_ID: CURLoption = CURLOPTTYPE_OBJECTPOINT + 190
"""The RTSP session ID to use for the connection."""
comptime CURLOPT_RTSP_STREAM_URI: CURLoption = CURLOPTTYPE_OBJECTPOINT + 191
"""The RTSP stream URI to operate on."""
comptime CURLOPT_RTSP_TRANSPORT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 192
"""The value to use for the RTSP `Transport` header."""
comptime CURLOPT_RTSP_CLIENT_CSEQ: CURLoption = CURLOPTTYPE_LONG + 193
"""The CSeq number to use for the next RTSP client request."""
comptime CURLOPT_RTSP_SERVER_CSEQ: CURLoption = CURLOPTTYPE_LONG + 194
"""The CSeq number expected in the next RTSP server-to-client request."""
comptime CURLOPT_INTERLEAVEDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 195
"""Custom pointer passed to the RTSP interleave callback as its last argument."""
comptime CURLOPT_INTERLEAVEFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 196
"""The callback function invoked to handle RTSP interleaved (RTP) data."""
comptime CURLOPT_WILDCARDMATCH: CURLoption = CURLOPTTYPE_LONG + 197
"""Whether to enable wildcard matching of remote filenames for FTP transfers."""
comptime CURLOPT_CHUNK_BGN_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 198
"""The callback function invoked before transferring a chunk in wildcard FTP matching."""
comptime CURLOPT_CHUNK_END_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 199
"""The callback function invoked after transferring a chunk in wildcard FTP matching."""
comptime CURLOPT_FNMATCH_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 200
"""The callback function invoked to perform custom wildcard filename matching."""
comptime CURLOPT_CHUNK_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 201
"""Custom pointer passed to the chunk begin/end callbacks as their last argument."""
comptime CURLOPT_FNMATCH_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 202
"""Custom pointer passed to the fnmatch callback as its last argument."""
comptime CURLOPT_RESOLVE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 203
"""A linked list of custom hostname-to-IP-address resolves to use instead of DNS."""
comptime CURLOPT_TLSAUTH_USERNAME: CURLoption = CURLOPTTYPE_OBJECTPOINT + 204
"""The username to use for TLS authentication."""
comptime CURLOPT_TLSAUTH_PASSWORD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 205
"""The password to use for TLS authentication."""
comptime CURLOPT_TLSAUTH_TYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 206
"""The TLS authentication method to use."""
comptime CURLOPT_TRANSFER_ENCODING: CURLoption = CURLOPTTYPE_LONG + 207
"""Whether to ask the server to use `Transfer-Encoding` for the request."""
comptime CURLOPT_CLOSESOCKETFUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 208
"""The callback function invoked instead of the default close-socket behavior."""
comptime CURLOPT_CLOSESOCKETDATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 209
"""Custom pointer passed to the close-socket callback as its last argument."""
comptime CURLOPT_GSSAPI_DELEGATION: CURLoption = CURLOPTTYPE_LONG + 210
"""The GSS-API credential delegation policy to use."""
comptime CURLOPT_DNS_SERVERS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 211
"""A comma-separated list of custom DNS server addresses to use."""
comptime CURLOPT_TCP_KEEPALIVE: CURLoption = CURLOPTTYPE_LONG + 213
"""Whether to enable TCP keep-alive probing on the connection."""
comptime CURLOPT_TCP_KEEPIDLE: CURLoption = CURLOPTTYPE_LONG + 214
"""The delay in seconds before the first TCP keep-alive probe is sent."""
comptime CURLOPT_TCP_KEEPINTVL: CURLoption = CURLOPTTYPE_LONG + 215
"""The interval in seconds between subsequent TCP keep-alive probes."""
comptime CURLOPT_SSL_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 216
"""A bitmask of SSL-related behavior options."""
comptime CURLOPT_EXPECT_100_TIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 227
"""The time in milliseconds to wait for a `100-continue` response before sending the request body."""
comptime CURLOPT_PINNEDPUBLICKEY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 230
"""The public key, in PEM/DER format or as a hash, to pin the peer's key to."""
comptime CURLOPT_UNIX_SOCKET_PATH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 231
"""The path to a Unix domain socket to connect through instead of a network socket."""
comptime CURLOPT_PATH_AS_IS: CURLoption = CURLOPTTYPE_LONG + 234
"""Whether to leave the URL path as-is, without squashing `..` and `.` sequences."""
comptime CURLOPT_PIPEWAIT: CURLoption = CURLOPTTYPE_LONG + 237
"""Whether to wait for pipelining/multiplexing before starting a new connection."""
comptime CURLOPT_CONNECT_TO: CURLoption = CURLOPTTYPE_OBJECTPOINT + 243
"""A linked list of specific host/port pairs to connect to instead of the request's URL host/port."""
comptime CURLOPT_PROXY_CAINFO: CURLoption = CURLOPTTYPE_OBJECTPOINT + 246
"""The path to a file holding CA certificates used to verify the HTTPS proxy."""
comptime CURLOPT_PROXY_CAPATH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 247
"""The path to a directory holding CA certificates used to verify the HTTPS proxy."""
comptime CURLOPT_PROXY_SSL_VERIFYPEER: CURLoption = CURLOPTTYPE_LONG + 248
"""Whether to verify the HTTPS proxy's SSL certificate."""
comptime CURLOPT_PROXY_SSL_VERIFYHOST: CURLoption = CURLOPTTYPE_LONG + 249
"""Whether to verify the HTTPS proxy certificate's name against the host."""
comptime CURLOPT_PROXY_SSLVERSION: CURLoption = CURLOPTTYPE_VALUES + 250
"""The SSL/TLS version to use for the connection to the HTTPS proxy."""
comptime CURLOPT_PROXY_SSLCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 254
"""The path to the SSL client certificate file for the HTTPS proxy."""
comptime CURLOPT_PROXY_SSLCERTTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 255
"""The format of the SSL client certificate for the HTTPS proxy."""
comptime CURLOPT_PROXY_SSLKEY: CURLoption = CURLOPTTYPE_OBJECTPOINT + 256
"""The path to the private key file for the HTTPS proxy's SSL client certificate."""
comptime CURLOPT_PROXY_SSLKEYTYPE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 257
"""The format of the private key file for the HTTPS proxy."""
comptime CURLOPT_PROXY_KEYPASSWD: CURLoption = CURLOPTTYPE_OBJECTPOINT + 258
"""The password for the HTTPS proxy's SSL private key or certificate."""
comptime CURLOPT_PROXY_SSL_CIPHER_LIST: CURLoption = CURLOPTTYPE_OBJECTPOINT + 259
"""The list of ciphers to use for the connection to the HTTPS proxy."""
comptime CURLOPT_PROXY_CRLFILE: CURLoption = CURLOPTTYPE_OBJECTPOINT + 260
"""The path to a certificate revocation list file used to verify the HTTPS proxy."""
comptime CURLOPT_PROXY_SSL_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 261
"""A bitmask of SSL-related behavior options for the HTTPS proxy connection."""

comptime CURLOPT_ABSTRACT_UNIX_SOCKET: CURLoption = CURLOPTTYPE_OBJECTPOINT + 264
"""The path to an abstract Unix domain socket to connect through."""

comptime CURLOPT_DOH_URL: CURLoption = CURLOPTTYPE_OBJECTPOINT + 279
"""The URL of the DNS-over-HTTPS server to use for name resolution."""
comptime CURLOPT_UPLOAD_BUFFERSIZE: CURLoption = CURLOPTTYPE_LONG + 280
"""The preferred size in bytes of the upload buffer."""

comptime CURLOPT_HTTP09_ALLOWED: CURLoption = CURLOPTTYPE_LONG + 285
"""Whether to allow HTTP/0.9 responses."""

comptime CURLOPT_MAXAGE_CONN: CURLoption = CURLOPTTYPE_LONG + 288
"""The maximum age in seconds of cached connections eligible for reuse."""

comptime CURLOPT_SSLCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 291
"""The SSL client certificate, provided as an in-memory blob."""
comptime CURLOPT_SSLKEY_BLOB: CURLoption = CURLOPTTYPE_BLOB + 292
"""The private key for the SSL client certificate, provided as an in-memory blob."""
comptime CURLOPT_PROXY_SSLCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 293
"""The HTTPS proxy's SSL client certificate, provided as an in-memory blob."""
comptime CURLOPT_PROXY_SSLKEY_BLOB: CURLoption = CURLOPTTYPE_BLOB + 294
"""The private key for the HTTPS proxy's SSL client certificate, provided as an in-memory blob."""
comptime CURLOPT_ISSUERCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 295
"""The issuer certificate used to verify the peer certificate, provided as an in-memory blob."""

comptime CURLOPT_PROXY_ISSUERCERT: CURLoption = CURLOPTTYPE_OBJECTPOINT + 296
"""The path to a file holding the issuer certificate to verify against the HTTPS proxy certificate."""
comptime CURLOPT_PROXY_ISSUERCERT_BLOB: CURLoption = CURLOPTTYPE_BLOB + 297
"""The issuer certificate to verify against the HTTPS proxy certificate, provided as an in-memory blob."""

comptime CURLOPT_AWS_SIGV4: CURLoption = CURLOPTTYPE_OBJECTPOINT + 305
"""The AWS V4 signature configuration string to use for the request."""

comptime CURLOPT_DOH_SSL_VERIFYPEER: CURLoption = CURLOPTTYPE_LONG + 306
"""Whether to verify the DNS-over-HTTPS server's SSL certificate."""
comptime CURLOPT_DOH_SSL_VERIFYHOST: CURLoption = CURLOPTTYPE_LONG + 307
"""Whether to verify the DNS-over-HTTPS certificate's name against the host."""
comptime CURLOPT_DOH_SSL_VERIFYSTATUS: CURLoption = CURLOPTTYPE_LONG + 308
"""Whether to verify the DNS-over-HTTPS server's certificate status (OCSP)."""
comptime CURLOPT_CAINFO_BLOB: CURLoption = CURLOPTTYPE_BLOB + 309
"""The CA certificate(s) used to verify the peer, provided as an in-memory blob."""
comptime CURLOPT_PROXY_CAINFO_BLOB: CURLoption = CURLOPTTYPE_BLOB + 310
"""The CA certificate(s) used to verify the HTTPS proxy, provided as an in-memory blob."""
comptime CURLOPT_SSH_HOST_PUBLIC_KEY_SHA256: CURLoption = CURLOPTTYPE_OBJECTPOINT + 311
"""The SHA256 checksum of the remote SSH host's public key, used for verification."""
comptime CURLOPT_PREREQ_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 312
"""The callback function invoked after the connection is established but before the request is sent."""
comptime CURLOPT_PREREQ_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 313
"""Custom pointer passed to the pre-request callback as its last argument."""
comptime CURLOPT_MAX_LIFETIME_CONN: CURLoption = CURLOPTTYPE_LONG + 314
"""The maximum lifetime in seconds, from creation, of cached connections eligible for reuse."""
comptime CURLOPT_MIME_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 315
"""A bitmask of options that control MIME/post-field formatting behavior."""
comptime CURLOPT_SSH_HOST_KEY_FUNCTION: CURLoption = CURLOPTTYPE_FUNCTIONPOINT + 316
"""The callback function invoked to verify the remote SSH host's key."""
comptime CURLOPT_SSH_HOST_KEY_DATA: CURLoption = CURLOPTTYPE_OBJECTPOINT + 317
"""Custom pointer passed to the SSH host key callback as its last argument."""
comptime CURLOPT_PROTOCOLS_STR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 318
"""A comma-separated list of protocol names libcurl is allowed to use for the transfer."""
comptime CURLOPT_REDIR_PROTOCOLS_STR: CURLoption = CURLOPTTYPE_OBJECTPOINT + 319
"""A comma-separated list of protocol names libcurl is allowed to follow to via redirects."""
comptime CURLOPT_WS_OPTIONS: CURLoption = CURLOPTTYPE_LONG + 320
"""A bitmask of WebSocket-related behavior options."""
comptime CURLOPT_CA_CACHE_TIMEOUT: CURLoption = CURLOPTTYPE_LONG + 321
"""The lifetime in seconds of the in-memory CA certificate cache."""
comptime CURLOPT_QUICK_EXIT: CURLoption = CURLOPTTYPE_LONG + 322
"""Whether to skip potentially slow cleanup procedures when the process exits."""
comptime CURLOPT_HAPROXY_CLIENT_IP: CURLoption = CURLOPTTYPE_OBJECTPOINT + 323
"""The fake client IP to send in a HAProxy PROXY protocol header."""
comptime CURLOPT_SERVER_RESPONSE_TIMEOUT_MS: CURLoption = CURLOPTTYPE_LONG + 324
"""The maximum time in milliseconds to wait for a server response on protocols like FTP and IMAP."""
comptime CURLOPT_ECH: CURLoption = CURLOPTTYPE_OBJECTPOINT + 325
"""The Encrypted Client Hello (ECH) configuration string to use."""
comptime CURLOPT_TCP_KEEPCNT: CURLoption = CURLOPTTYPE_LONG + 326
"""The maximum number of TCP keep-alive probes to send before considering the connection dead."""
comptime CURLOPT_UPLOAD_FLAGS: CURLoption = CURLOPTTYPE_LONG + 327
"""A bitmask of flags controlling upload behavior."""
comptime CURLOPT_SSL_SIGNATURE_ALGORITHMS: CURLoption = CURLOPTTYPE_OBJECTPOINT + 328
"""The TLS signature algorithms to advertise during the handshake."""

comptime CURL_IPRESOLVE_WHATEVER: c_int = 0
"""IP resolution: let the library choose."""
comptime CURL_IPRESOLVE_V4: c_int = 1
"""IP resolution: IPv4 only."""
comptime CURL_IPRESOLVE_V6: c_int = 2
"""IP resolution: IPv6 only."""

comptime CURLSSLOPT_ALLOW_BEAST: c_long = 1 << 0
"""Allow BEAST (Browser Exploit Against SSL/TLS) vulnerability."""
comptime CURLSSLOPT_NO_REVOKE: c_long = 1 << 1
"""Do not check certificate revocation."""
comptime CURLSSLOPT_NO_PARTIALCHAIN: c_long = 1 << 2
"""Do not allow partial chain verification."""
comptime CURLSSLOPT_REVOKE_BEST_EFFORT: c_long = 1 << 3
"""Best-effort certificate revocation checking."""
comptime CURLSSLOPT_NATIVE_CA: c_long = 1 << 4
"""Use native CA certificate store."""
comptime CURLSSLOPT_AUTO_CLIENT_CERT: c_long = 1 << 5
"""Automatically select client certificate."""

# These enums are for use with the CURLOPT_HTTP_VERSION option.
# Setting this means we don't care, and that we'd like the library to choose the best possible for us!
comptime CURL_HTTP_VERSION_NONE: c_int = 0
"""Let the library choose the HTTP version."""
comptime CURL_HTTP_VERSION_1_0: c_int = 1
"""Use HTTP/1.0."""
comptime CURL_HTTP_VERSION_1_1: c_int = 2
"""Use HTTP/1.1."""
comptime CURL_HTTP_VERSION_2_0: c_int = 3
"""Use HTTP/2."""
comptime CURL_HTTP_VERSION_2TLS: c_int = 4
"""Use HTTP/2 over TLS without HTTP/1.1 upgrade."""
comptime CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE: c_int = 5
"""Assume HTTP/2 without upgrade."""
comptime CURL_HTTP_VERSION_3: c_int = 30
"""Use HTTP/3."""

comptime CURL_SSLVERSION_DEFAULT: c_long = 0
"""Use default SSL/TLS version."""
comptime CURL_SSLVERSION_TLSv1: c_long = 1
"""Use TLS version 1."""
comptime CURL_SSLVERSION_SSLv2: c_long = 2
"""Use SSL version 2."""
comptime CURL_SSLVERSION_SSLv3: c_long = 3
"""Use SSL version 3."""
comptime CURL_SSLVERSION_TLSv1_0: c_long = 4
"""Use TLS version 1.0."""
comptime CURL_SSLVERSION_TLSv1_1: c_long = 5
"""Use TLS version 1.1."""
comptime CURL_SSLVERSION_TLSv1_2: c_long = 6
"""Use TLS version 1.2."""
comptime CURL_SSLVERSION_TLSv1_3: c_long = 7
"""Use TLS version 1.3."""

comptime CURLOPT_READDATA: CURLoption = CURLOPT_INFILE
"""Alias for CURLOPT_INFILE."""
comptime CURLOPT_WRITEDATA: CURLoption = CURLOPT_FILE
"""Alias for CURLOPT_FILE."""
comptime CURLOPT_HEADERDATA: CURLoption = CURLOPT_WRITEHEADER
"""Alias for CURLOPT_WRITEHEADER."""

comptime curl_TimeCond = c_int
"""Enumeration of time conditions for conditional requests."""
comptime CURL_TIMECOND_NONE: curl_TimeCond = 0
"""No time condition."""
comptime CURL_TIMECOND_IFMODSINCE: curl_TimeCond = 1
"""If-Modified-Since time condition."""
comptime CURL_TIMECOND_IFUNMODSINCE: curl_TimeCond = 2
"""If-Unmodified-Since time condition."""
comptime CURL_TIMECOND_LASTMOD: curl_TimeCond = 3
"""Last-Modified time condition."""

comptime CURLformoption = c_int
"""Enumeration of form options for curl_formadd."""
comptime CURLFORM_NOTHING: CURLformoption = 0
"""No form option (marks end of array)."""
comptime CURLFORM_COPYNAME: CURLformoption = 1
"""Copy form field name."""
comptime CURLFORM_PTRNAME: CURLformoption = 2
"""Pointer to form field name (not copied)."""
comptime CURLFORM_NAMELENGTH: CURLformoption = 3
"""Length of form field name."""
comptime CURLFORM_COPYCONTENTS: CURLformoption = 4
"""Copy form field contents."""
comptime CURLFORM_PTRCONTENTS: CURLformoption = 5
"""Pointer to form field contents (not copied)."""
comptime CURLFORM_CONTENTSLENGTH: CURLformoption = 6
"""Length of form field contents."""
comptime CURLFORM_FILECONTENT: CURLformoption = 7
"""File contents for form field."""
comptime CURLFORM_ARRAY: CURLformoption = 8
"""Form field array."""
comptime CURLFORM_OBSOLETE: CURLformoption = 9
"""Obsolete form option."""
comptime CURLFORM_FILE: CURLformoption = 10
"""File for form field."""
comptime CURLFORM_BUFFER: CURLformoption = 11
"""Buffer for form field."""
comptime CURLFORM_BUFFERPTR: CURLformoption = 12
"""Pointer to form field buffer."""
comptime CURLFORM_BUFFERLENGTH: CURLformoption = 13
"""Length of form field buffer."""
comptime CURLFORM_CONTENTTYPE: CURLformoption = 14
"""Content-Type for form field."""
comptime CURLFORM_CONTENTHEADER: CURLformoption = 15
"""Content headers for form field."""
comptime CURLFORM_FILENAME: CURLformoption = 16
"""Filename for form field."""
comptime CURLFORM_END: CURLformoption = 17
"""End of form options."""
comptime CURLFORM_STREAM: CURLformoption = 19
"""Stream for form field."""

comptime CURLFORMcode = c_int
"""Enumeration of form add result codes."""
comptime CURL_FORMADD_OK: CURLFORMcode = 0
"""Form add succeeded."""
comptime CURL_FORMADD_MEMORY: CURLFORMcode = 1
"""Form add failed due to memory allocation."""
comptime CURL_FORMADD_OPTION_TWICE: CURLFORMcode = 2
"""Form option specified twice."""
comptime CURL_FORMADD_NULL: CURLFORMcode = 3
"""Form field was NULL."""
comptime CURL_FORMADD_UNKNOWN_OPTION: CURLFORMcode = 4
"""Unknown form option."""
comptime CURL_FORMADD_INCOMPLETE: CURLFORMcode = 5
"""Incomplete form option."""
comptime CURL_FORMADD_ILLEGAL_ARRAY: CURLFORMcode = 6
"""Illegal form array."""
comptime CURL_FORMADD_DISABLED: CURLFORMcode = 7
"""Form add is disabled."""

comptime CURL_REDIR_POST_301: c_ulong = 1
"""Redirect POST data on 301 response."""
comptime CURL_REDIR_POST_302: c_ulong = 2
"""Redirect POST data on 302 response."""
comptime CURL_REDIR_POST_303: c_ulong = 4
"""Redirect POST data on 303 response."""
comptime CURL_REDIR_POST_ALL: c_ulong = (CURL_REDIR_POST_301 | CURL_REDIR_POST_302 | CURL_REDIR_POST_303)
"""Redirect POST data on all redirect responses."""


struct curl_forms:
    """Structure for passing form data to curl_formadd function."""

    var option: CURLformoption
    """The form option."""
    var value: ImmutExternalPointer[c_char]
    """The value for the form option."""


comptime curl_formget_callback = def(MutExternalPointer[c_char], ImmutExternalPointer[NoneType], c_size_t) abi(
    "C"
) thin -> c_int
"""Callback function for curl_formget to receive form data as it is serialized."""


struct curl_slist(TrivialRegisterPassable):
    """Singly linked list structure for curl string lists."""

    var data: MutExternalPointer[c_char]
    """Pointer to the data string for this node."""
    var next: MutExternalPointer[curl_slist]
    """Pointer to the next node in the list."""


struct curl_certinfo:
    """Information about SSL certificates returned by CURLINFO_CERTINFO."""

    var num_of_certs: c_int
    """Number of certificates in the certinfo list."""
    var certinfo: MutExternalPointer[MutExternalPointer[curl_slist]]
    """Pointer to an array of pointers to curl_slist structures, each representing a certificate's information."""


comptime curl_sslbackend = c_int
"""Enumeration of available SSL/TLS backends."""
comptime CURLSSLBACKEND_NONE: curl_sslbackend = 0
"""No SSL backend."""
comptime CURLSSLBACKEND_OPENSSL: curl_sslbackend = 1
"""OpenSSL SSL backend."""
comptime CURLSSLBACKEND_GNUTLS: curl_sslbackend = 2
"""GnuTLS SSL backend."""
comptime CURLSSLBACKEND_NSS: curl_sslbackend = 3
"""NSS (Network Security Services) SSL backend."""
comptime CURLSSLBACKEND_QSOSSL: curl_sslbackend = 4
"""QsoSSL SSL backend."""
comptime CURLSSLBACKEND_GSKIT: curl_sslbackend = 5
"""GSKIT SSL backend."""
comptime CURLSSLBACKEND_POLARSSL: curl_sslbackend = 6
"""PolarSSL SSL backend."""
comptime CURLSSLBACKEND_CYASSL: curl_sslbackend = 7
"""CyaSSL SSL backend."""
comptime CURLSSLBACKEND_SCHANNEL: curl_sslbackend = 8
"""Schannel SSL backend."""
comptime CURLSSLBACKEND_DARWINSSL: curl_sslbackend = 9
"""Darwin SSL backend."""


struct curl_tlssessioninfo:
    """Structure to hold TLS session information for a connection."""

    var backend: curl_sslbackend
    """The SSL backend used for the TLS session."""
    var internals: MutExternalPointer[NoneType]
    """Pointer to backend-specific internal data for the TLS session."""


comptime CURLINFO_STRING: CURLINFO = 0x100000
"""String data type mask."""
comptime CURLINFO_LONG: CURLINFO = 0x200000
"""Long integer data type mask."""
comptime CURLINFO_DOUBLE: CURLINFO = 0x300000
"""Double data type mask."""
comptime CURLINFO_SLIST: CURLINFO = 0x400000
"""String list data type mask."""
comptime CURLINFO_PTR: CURLINFO = 0x400000
"""Pointer data type mask (same as SLIST)."""
comptime CURLINFO_SOCKET: CURLINFO = 0x500000
"""Socket data type mask."""
comptime CURLINFO_OFF_T: CURLINFO = 0x600000
"""Offset data type mask."""
comptime CURLINFO_MASK: CURLINFO = 0x0FFFFF
"""Mask for CURLINFO data type bits."""
comptime CURLINFO_TYPEMASK: CURLINFO = 0xF00000
"""Mask for CURLINFO type bits."""

comptime CURLINFO_EFFECTIVE_URL: CURLINFO = CURLINFO_STRING + 1
"""The last used effective URL."""
comptime CURLINFO_RESPONSE_CODE: CURLINFO = CURLINFO_LONG + 2
"""The last received HTTP/FTP response code."""
comptime CURLINFO_TOTAL_TIME: CURLINFO = CURLINFO_DOUBLE + 3
"""The total time in seconds for the previous transfer."""
comptime CURLINFO_NAMELOOKUP_TIME: CURLINFO = CURLINFO_DOUBLE + 4
"""The time in seconds it took to perform the name lookup."""
comptime CURLINFO_CONNECT_TIME: CURLINFO = CURLINFO_DOUBLE + 5
"""The time in seconds it took to establish the connection."""
comptime CURLINFO_PRETRANSFER_TIME: CURLINFO = CURLINFO_DOUBLE + 6
"""The time in seconds from the start until the file transfer is about to begin."""
comptime CURLINFO_SIZE_UPLOAD: CURLINFO = CURLINFO_DOUBLE + 7
"""Deprecated; the number of bytes uploaded."""
comptime CURLINFO_SIZE_DOWNLOAD: CURLINFO = CURLINFO_DOUBLE + 8
"""Deprecated; the number of bytes downloaded."""
comptime CURLINFO_SPEED_DOWNLOAD: CURLINFO = CURLINFO_DOUBLE + 9
"""Deprecated; the average download speed in bytes per second."""
comptime CURLINFO_SPEED_UPLOAD: CURLINFO = CURLINFO_DOUBLE + 10
"""Deprecated; the average upload speed in bytes per second."""
comptime CURLINFO_HEADER_SIZE: CURLINFO = CURLINFO_LONG + 11
"""The total size in bytes of all headers received."""
comptime CURLINFO_REQUEST_SIZE: CURLINFO = CURLINFO_LONG + 12
"""The total size in bytes of the issued request."""
comptime CURLINFO_SSL_VERIFYRESULT: CURLINFO = CURLINFO_LONG + 13
"""The result of the SSL peer certificate verification."""
comptime CURLINFO_FILETIME: CURLINFO = CURLINFO_LONG + 14
"""The remote time of the retrieved document, if known."""
comptime CURLINFO_CONTENT_LENGTH_DOWNLOAD: CURLINFO = CURLINFO_DOUBLE + 15
"""Deprecated; the content length of the download from the `Content-Length` header."""
comptime CURLINFO_CONTENT_LENGTH_UPLOAD: CURLINFO = CURLINFO_DOUBLE + 16
"""Deprecated; the specified size of the upload."""
comptime CURLINFO_STARTTRANSFER_TIME: CURLINFO = CURLINFO_DOUBLE + 17
"""The time in seconds until the first byte is received."""
comptime CURLINFO_CONTENT_TYPE: CURLINFO = CURLINFO_STRING + 18
"""The content type of the downloaded object, from the `Content-Type` header."""
comptime CURLINFO_REDIRECT_TIME: CURLINFO = CURLINFO_DOUBLE + 19
"""The time in seconds spent on all redirection steps."""
comptime CURLINFO_REDIRECT_COUNT: CURLINFO = CURLINFO_LONG + 20
"""The total number of redirects that were followed."""
comptime CURLINFO_PRIVATE: CURLINFO = CURLINFO_STRING + 21
"""The private pointer previously set with `CURLOPT_PRIVATE`."""
comptime CURLINFO_HTTP_CONNECTCODE: CURLINFO = CURLINFO_LONG + 22
"""The last HTTP proxy `CONNECT` response code."""
comptime CURLINFO_HTTPAUTH_AVAIL: CURLINFO = CURLINFO_LONG + 23
"""A bitmask of the HTTP authentication method(s) the server announced as available."""
comptime CURLINFO_PROXYAUTH_AVAIL: CURLINFO = CURLINFO_LONG + 24
"""A bitmask of the HTTP authentication method(s) the proxy announced as available."""
comptime CURLINFO_OS_ERRNO: CURLINFO = CURLINFO_LONG + 25
"""The `errno` value from the last connect failure, if any."""
comptime CURLINFO_NUM_CONNECTS: CURLINFO = CURLINFO_LONG + 26
"""The number of new connections libcurl had to create to achieve the previous transfer."""
comptime CURLINFO_SSL_ENGINES: CURLINFO = CURLINFO_SLIST + 27
"""A linked list of SSL crypto engines supported by libcurl."""
comptime CURLINFO_COOKIELIST: CURLINFO = CURLINFO_SLIST + 28
"""A linked list of all cookies libcurl knows, including expired ones."""
comptime CURLINFO_LASTSOCKET: CURLINFO = CURLINFO_LONG + 29
"""Deprecated; the last socket used by this curl session."""
comptime CURLINFO_FTP_ENTRY_PATH: CURLINFO = CURLINFO_STRING + 30
"""The initial path libcurl ended up in when logging into the remote FTP server."""
comptime CURLINFO_REDIRECT_URL: CURLINFO = CURLINFO_STRING + 31
"""The URL a redirect would take the transfer to, when redirects are not followed."""
comptime CURLINFO_PRIMARY_IP: CURLINFO = CURLINFO_STRING + 32
"""The IP address of the most recent connection."""
comptime CURLINFO_APPCONNECT_TIME: CURLINFO = CURLINFO_DOUBLE + 33
"""The time in seconds it took from the start until the SSL/SSH connect/handshake completed."""
comptime CURLINFO_CERTINFO: CURLINFO = CURLINFO_SLIST + 34
"""A linked list of certificate information from the peer's certificate chain."""
comptime CURLINFO_CONDITION_UNMET: CURLINFO = CURLINFO_LONG + 35
"""Whether a time conditional set with `CURLOPT_TIMECONDITION` was not met."""
comptime CURLINFO_RTSP_SESSION_ID: CURLINFO = CURLINFO_STRING + 36
"""The RTSP session ID, as identified by the server."""
comptime CURLINFO_RTSP_CLIENT_CSEQ: CURLINFO = CURLINFO_LONG + 37
"""The next CSeq number the RTSP client is expected to send."""
comptime CURLINFO_RTSP_SERVER_CSEQ: CURLINFO = CURLINFO_LONG + 38
"""The next CSeq number the RTSP server is expected to send."""
comptime CURLINFO_RTSP_CSEQ_RECV: CURLINFO = CURLINFO_LONG + 39
"""The most recently received RTSP CSeq number."""
comptime CURLINFO_PRIMARY_PORT: CURLINFO = CURLINFO_LONG + 40
"""The destination port of the most recent connection."""
comptime CURLINFO_LOCAL_IP: CURLINFO = CURLINFO_STRING + 41
"""The local (source) IP address of the most recent connection."""
comptime CURLINFO_LOCAL_PORT: CURLINFO = CURLINFO_LONG + 42
"""The local (source) port number of the most recent connection."""
comptime CURLINFO_TLS_SESSION: CURLINFO = CURLINFO_SLIST + 43
"""Deprecated TLS session info; use `CURLINFO_TLS_SSL_PTR` instead."""
comptime CURLINFO_ACTIVESOCKET: CURLINFO = CURLINFO_SOCKET + 44
"""The active socket used by the curl session."""
comptime CURLINFO_TLS_SSL_PTR: CURLINFO = CURLINFO_PTR + 45
"""A pointer to the underlying SSL library's session/connection structure."""
comptime CURLINFO_HTTP_VERSION: CURLINFO = CURLINFO_LONG + 46
"""The HTTP version used in the connection."""
comptime CURLINFO_PROXY_SSL_VERIFYRESULT: CURLINFO = CURLINFO_LONG + 47
"""The result of the HTTPS proxy certificate verification."""
comptime CURLINFO_PROTOCOL: CURLINFO = CURLINFO_LONG + 48  # CURL_DEPRECATED(7.85.0, "Use CURLINFO_SCHEME")
"""Deprecated; use `CURLINFO_SCHEME` instead. The protocol used in the connection."""
comptime CURLINFO_SCHEME: CURLINFO = CURLINFO_STRING + 49
"""The URL scheme used for the most recent connection."""
comptime CURLINFO_TOTAL_TIME_T: CURLINFO = CURLINFO_OFF_T + 50
"""The total time in microseconds for the previous transfer."""
comptime CURLINFO_NAMELOOKUP_TIME_T: CURLINFO = CURLINFO_OFF_T + 51
"""The time in microseconds it took to perform the name lookup."""
comptime CURLINFO_CONNECT_TIME_T: CURLINFO = CURLINFO_OFF_T + 52
"""The time in microseconds it took to establish the connection."""
comptime CURLINFO_PRETRANSFER_TIME_T: CURLINFO = CURLINFO_OFF_T + 53
"""The time in microseconds from the start until the file transfer is about to begin."""
comptime CURLINFO_STARTTRANSFER_TIME_T: CURLINFO = CURLINFO_OFF_T + 54
"""The time in microseconds until the first byte is received."""
comptime CURLINFO_REDIRECT_TIME_T: CURLINFO = CURLINFO_OFF_T + 55
"""The time in microseconds spent on all redirection steps."""
comptime CURLINFO_APPCONNECT_TIME_T: CURLINFO = CURLINFO_OFF_T + 56
"""The time in microseconds it took from the start until the SSL/SSH connect/handshake completed."""
comptime CURLINFO_RETRY_AFTER: CURLINFO = CURLINFO_OFF_T + 57
"""The number of seconds the server suggests waiting before retrying, from the `Retry-After` header."""
comptime CURLINFO_EFFECTIVE_METHOD: CURLINFO = CURLINFO_STRING + 58
"""The last used HTTP request method."""
comptime CURLINFO_PROXY_ERROR: CURLINFO = CURLINFO_LONG + 59
"""The detailed proxy-specific CURLPX error code from the most recent transfer."""
comptime CURLINFO_REFERER: CURLINFO = CURLINFO_STRING + 60
"""The value of the `Referer` header used in the request."""
comptime CURLINFO_CAINFO: CURLINFO = CURLINFO_STRING + 61
"""The default CA certificate file path libcurl uses, as set by `CURLOPT_CAINFO`."""
comptime CURLINFO_CAPATH: CURLINFO = CURLINFO_STRING + 62
"""The default CA certificate directory path libcurl uses, as set by `CURLOPT_CAPATH`."""
comptime CURLINFO_XFER_ID: CURLINFO = CURLINFO_OFF_T + 63
"""The transfer's unique identifier within the multi handle."""
comptime CURLINFO_CONN_ID: CURLINFO = CURLINFO_OFF_T + 64
"""The connection's unique identifier within the multi handle."""
comptime CURLINFO_QUEUE_TIME_T: CURLINFO = CURLINFO_OFF_T + 65
"""The time in microseconds the transfer spent queued before it started."""
comptime CURLINFO_USED_PROXY: CURLINFO = CURLINFO_LONG + 66
"""Whether a proxy was used for the most recent transfer."""
comptime CURLINFO_POSTTRANSFER_TIME_T: CURLINFO = CURLINFO_OFF_T + 67
"""The time in microseconds spent after the transfer completed and before the handle finished."""
comptime CURLINFO_EARLYDATA_SENT_T: CURLINFO = CURLINFO_OFF_T + 68
"""The number of bytes sent as TLS 1.3 early data."""
comptime CURLINFO_HTTPAUTH_USED: CURLINFO = CURLINFO_LONG + 69
"""The HTTP authentication method actually used for the most recent transfer."""
comptime CURLINFO_PROXYAUTH_USED: CURLINFO = CURLINFO_LONG + 70
"""The HTTP authentication method actually used for the proxy in the most recent transfer."""
comptime CURLINFO_SIZE_DELIVERED: CURLINFO = CURLINFO_OFF_T + 71
"""The number of bytes delivered to the application's write callback."""

comptime curl_closepolicy = c_int
"""Enumeration of connection close policies."""
comptime CURLCLOSEPOLICY_NONE: curl_closepolicy = 0
"""No policy specified."""
comptime CURLCLOSEPOLICY_OLDEST: curl_closepolicy = 1
"""Close the oldest connection."""
comptime CURLCLOSEPOLICY_LEAST_RECENTLY_USED: curl_closepolicy = 2
"""Close the least recently used connection."""
comptime CURLCLOSEPOLICY_LEAST_TRAFFIC: curl_closepolicy = 3
"""Close the connection with least traffic."""
comptime CURLCLOSEPOLICY_SLOWEST: curl_closepolicy = 4
"""Close the slowest connection."""
comptime CURLCLOSEPOLICY_CALLBACK: curl_closepolicy = 5
"""Close using callback function."""

comptime CURL_GLOBAL_SSL: c_long = 1 << 0
"""Initialize SSL/TLS."""
comptime CURL_GLOBAL_WIN32: c_long = 1 << 1
"""Initialize Windows socket."""
comptime CURL_GLOBAL_ALL: c_long = CURL_GLOBAL_SSL | CURL_GLOBAL_WIN32
"""Initialize all subsystems."""
comptime CURL_GLOBAL_NOTHING: c_long = 0
"""Initialize nothing."""
comptime CURL_GLOBAL_DEFAULT: c_long = CURL_GLOBAL_ALL
"""Default initialization."""
comptime CURL_GLOBAL_ACK_EINTR: c_long = 1 << 2
"""Acknowledge EINTR signal."""

comptime curl_lock_data = c_int
"""Enumeration of shareable resource types."""
comptime CURL_LOCK_DATA_NONE: curl_lock_data = 0
"""No lock data."""
comptime CURL_LOCK_DATA_SHARE: curl_lock_data = 1
"""Share data lock."""
comptime CURL_LOCK_DATA_COOKIE: curl_lock_data = 2
"""Cookie data lock."""
comptime CURL_LOCK_DATA_DNS: curl_lock_data = 3
"""DNS data lock."""
comptime CURL_LOCK_DATA_SSL_SESSION: curl_lock_data = 4
"""SSL session data lock."""
comptime CURL_LOCK_DATA_CONNECT: curl_lock_data = 5
"""Connection data lock."""

comptime curl_lock_access = c_int
"""Enumeration of lock access types."""
comptime CURL_LOCK_ACCESS_NONE: curl_lock_access = 0
"""No lock access."""
comptime CURL_LOCK_ACCESS_SHARED: curl_lock_access = 1
"""Shared lock access."""
comptime CURL_LOCK_ACCESS_SINGLE: curl_lock_access = 2
"""Single lock access."""

comptime curl_lock_function = def(CURL, curl_lock_data, curl_lock_access, MutExternalPointer[NoneType]) abi(
    "C"
) thin -> NoneType
"""Callback function for locking shared resources."""
comptime curl_unlock_function = def(CURL, curl_lock_data, MutExternalPointer[NoneType]) abi("C") thin -> NoneType
"""Callback function for unlocking shared resources."""

comptime CURLSH = MutExternalPointer[NoneType]
"""Opaque pointer type for CURL share handles."""

comptime CURLSHcode = c_int
"""Enumeration of share handle result codes."""
comptime CURLSHE_OK: CURLSHcode = 0
"""Share operation succeeded."""
comptime CURLSHE_BAD_OPTION: CURLSHcode = 1
"""Invalid share option."""
comptime CURLSHE_IN_USE: CURLSHcode = 2
"""Share handle is already in use."""
comptime CURLSHE_INVALID: CURLSHcode = 3
"""Invalid share handle."""
comptime CURLSHE_NOMEM: CURLSHcode = 4
"""Out of memory."""
comptime CURLSHE_NOT_BUILT_IN: CURLSHcode = 5
"""Feature not built in."""

comptime CURLSHoption = c_int
"""Enumeration of share handle options."""
comptime CURLSHOPT_NONE: CURLSHoption = 0
"""No share option."""
comptime CURLSHOPT_SHARE: CURLSHoption = 1
"""Share resource."""
comptime CURLSHOPT_UNSHARE: CURLSHoption = 2
"""Unshare resource."""
comptime CURLSHOPT_LOCKFUNC: CURLSHoption = 3
"""Lock function callback."""
comptime CURLSHOPT_UNLOCKFUNC: CURLSHoption = 4
"""Unlock function callback."""
comptime CURLSHOPT_USERDATA: CURLSHoption = 5
"""User data for share callbacks."""

comptime CURLVERSION_FIRST: CURLversion = 0
"""First version of version info structure."""
comptime CURLVERSION_SECOND: CURLversion = 1
"""Second version of version info structure."""
comptime CURLVERSION_THIRD: CURLversion = 2
"""Third version of version info structure."""
comptime CURLVERSION_FOURTH: CURLversion = 3
"""Fourth version of version info structure."""
comptime CURLVERSION_FIFTH: CURLversion = 4
"""Fifth version of version info structure."""
comptime CURLVERSION_SIXTH: CURLversion = 5
"""Sixth version of version info structure."""
comptime CURLVERSION_SEVENTH: CURLversion = 6
"""Seventh version of version info structure."""
comptime CURLVERSION_EIGHTH: CURLversion = 7
"""Eighth version of version info structure."""
comptime CURLVERSION_NINTH: CURLversion = 8
"""Ninth version of version info structure."""
comptime CURLVERSION_TENTH: CURLversion = 9
"""Tenth version of version info structure."""
comptime CURLVERSION_ELEVENTH: CURLversion = 10
"""Eleventh version of version info structure."""
comptime CURLVERSION_TWELFTH: CURLversion = 11
"""Twelfth version of version info structure."""
comptime CURLVERSION_NOW: CURLversion = CURLVERSION_TWELFTH
"""Current version of version info structure."""


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
"""IPv6 support."""
comptime CURL_VERSION_KERBEROS4: c_int = 1 << 1
"""Kerberos 4 support."""
comptime CURL_VERSION_SSL: c_int = 1 << 2
"""SSL/TLS support."""
comptime CURL_VERSION_LIBZ: c_int = 1 << 3
"""Libz compression support."""
comptime CURL_VERSION_NTLM: c_int = 1 << 4
"""NTLM authentication support."""
comptime CURL_VERSION_GSSNEGOTIATE: c_int = 1 << 5
"""GSS-Negotiate authentication support."""
comptime CURL_VERSION_DEBUG: c_int = 1 << 6
"""Debug build."""
comptime CURL_VERSION_ASYNCHDNS: c_int = 1 << 7
"""Asynchronous DNS resolution."""
comptime CURL_VERSION_SPNEGO: c_int = 1 << 8
"""SPNEGO authentication support."""
comptime CURL_VERSION_LARGEFILE: c_int = 1 << 9
"""Large file support."""
comptime CURL_VERSION_IDN: c_int = 1 << 10
"""Internationalized Domain Names support."""
comptime CURL_VERSION_SSPI: c_int = 1 << 11
"""SSPI support."""
comptime CURL_VERSION_CONV: c_int = 1 << 12
"""Character conversion support."""
comptime CURL_VERSION_CURLDEBUG: c_int = 1 << 13
"""Curl debug build."""
comptime CURL_VERSION_TLSAUTH_SRP: c_int = 1 << 14
"""TLS-SRP authentication support."""
comptime CURL_VERSION_NTLM_WB: c_int = 1 << 15
"""NTLM with WinBind support."""
comptime CURL_VERSION_HTTP2: c_int = 1 << 16
"""HTTP/2 support."""
comptime CURL_VERSION_UNIX_SOCKETS: c_int = 1 << 19
"""Unix domain socket support."""
comptime CURL_VERSION_HTTPS_PROXY: c_int = 1 << 21
"""HTTPS proxy support."""
comptime CURL_VERSION_BROTLI: c_int = 1 << 23
"""Brotli compression support."""
comptime CURL_VERSION_ALTSVC: c_int = 1 << 24
"""Alt-Svc support."""
comptime CURL_VERSION_HTTP3: c_int = 1 << 25
"""HTTP/3 support."""
comptime CURL_VERSION_ZSTD: c_int = 1 << 26
"""Zstd compression support."""
comptime CURL_VERSION_UNICODE: c_int = 1 << 27
"""Unicode support."""
comptime CURL_VERSION_HSTS: c_int = 1 << 28
"""HSTS support."""
comptime CURL_VERSION_GSASL: c_int = 1 << 29
"""GSASL support."""

comptime CURLPAUSE_RECV: c_int = 1 << 0
"""Pause receiving data."""
comptime CURLPAUSE_RECV_CONT: c_int = 0
"""Continue receiving data."""
comptime CURLPAUSE_SEND: c_int = 1 << 2
"""Pause sending data."""
comptime CURLPAUSE_SEND_CONT: c_int = 0
"""Continue sending data."""

comptime CURLM = MutExternalPointer[NoneType]
"""Opaque pointer type for CURL multi handles."""

comptime CURLMcode = c_int
"""Enumeration of multi interface result codes."""
comptime CURLM_CALL_MULTI_PERFORM: CURLMcode = -1
"""Call curl_multi_perform() again."""
comptime CURLM_OK: CURLMcode = 0
"""Multi operation succeeded."""
comptime CURLM_BAD_HANDLE: CURLMcode = 1
"""Invalid multi handle."""
comptime CURLM_BAD_EASY_HANDLE: CURLMcode = 2
"""Invalid easy handle."""
comptime CURLM_OUT_OF_MEMORY: CURLMcode = 3
"""Out of memory."""
comptime CURLM_INTERNAL_ERROR: CURLMcode = 4
"""Internal error."""
comptime CURLM_BAD_SOCKET: CURLMcode = 5
"""Invalid socket."""
comptime CURLM_UNKNOWN_OPTION: CURLMcode = 6
"""Unknown multi option."""
comptime CURLM_ADDED_ALREADY: CURLMcode = 7
"""Handle already added."""

comptime CURLMSG = c_int
"""Enumeration of multi interface message types."""
comptime CURLMSG_NONE: CURLMSG = 0
"""No message."""
comptime CURLMSG_DONE: CURLMSG = 1
"""Transfer completed."""


struct CURLMsg:
    """Message structure used in multi interface to report completed transfers."""

    var msg: CURLMSG
    """The message type, currently only CURLMSG_DONE is used."""
    var easy_handle: MutExternalPointer[NoneType]
    """Pointer to the easy handle that completed the transfer."""
    var data: MutExternalPointer[NoneType]
    """Pointer to private data associated with the transfer, set by the application when the handle was added to the multi handle."""


comptime CURL_WAIT_POLLIN: c_short = 0x1
"""Wait for input readiness."""
comptime CURL_WAIT_POLLPRI: c_short = 0x2
"""Wait for high priority input."""
comptime CURL_WAIT_POLLOUT: c_short = 0x4
"""Wait for output readiness."""


struct curl_waitfd:
    """Structure used to specify a file descriptor and the events to wait for in the multi interface."""

    var fd: curl_socket_t
    """The file descriptor to wait on."""
    var events: c_short
    """Bitmask of events to wait for, using CURL_WAIT_POLLIN, CURL_WAIT_POLLPRI, and/or CURL_WAIT_POLLOUT."""
    var revents: c_short
    """Bitmask of events that occurred, set by the library when the wait is complete."""


comptime CURL_POLL_NONE: c_int = 0
"""No poll event."""
comptime CURL_POLL_IN: c_int = 1
"""Poll for input."""
comptime CURL_POLL_OUT: c_int = 2
"""Poll for output."""
comptime CURL_POLL_INOUT: c_int = 3
"""Poll for input and output."""
comptime CURL_POLL_REMOVE: c_int = 4
"""Remove socket from polling."""
comptime CURL_CSELECT_IN: c_int = 1
"""Socket selected for reading."""
comptime CURL_CSELECT_OUT: c_int = 2
"""Socket selected for writing."""
comptime CURL_CSELECT_ERR: c_int = 4
"""Socket has an error condition."""
comptime CURL_SOCKET_TIMEOUT: curl_socket_t = CURL_SOCKET_BAD
"""Socket timeout value."""

comptime curl_socket_callback = def(
    CURL, curl_socket_t, c_int, MutExternalPointer[NoneType], MutExternalPointer[NoneType]
) abi("C") thin -> c_int
"""Callback function for socket event notifications in the multi interface."""
comptime curl_multi_timer_callback = def(CURLM, c_long, MutExternalPointer[NoneType]) abi("C") thin -> c_int
"""Callback function for timer events in the multi interface."""

comptime CURLMoption = c_int
"""Enumeration of multi interface options."""
comptime CURLMOPT_SOCKETFUNCTION: CURLMoption = CURLOPTTYPE_FUNCTIONPOINT + 1
"""Socket callback function."""
comptime CURLMOPT_SOCKETDATA: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 2
"""Data for socket callback."""
comptime CURLMOPT_PIPELINING: CURLMoption = CURLOPTTYPE_LONG + 3
"""Pipelining mode."""
comptime CURLMOPT_TIMERFUNCTION: CURLMoption = CURLOPTTYPE_FUNCTIONPOINT + 4
"""Timer callback function."""
comptime CURLMOPT_TIMERDATA: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 5
"""Data for timer callback."""
comptime CURLMOPT_MAXCONNECTS: CURLMoption = CURLOPTTYPE_LONG + 6
"""Maximum number of connections."""
comptime CURLMOPT_MAX_HOST_CONNECTIONS: CURLMoption = CURLOPTTYPE_LONG + 7
"""Maximum connections per host."""
comptime CURLMOPT_MAX_PIPELINE_LENGTH: CURLMoption = CURLOPTTYPE_LONG + 8
"""Maximum pipeline length."""
comptime CURLMOPT_CONTENT_LENGTH_PENALTY_SIZE: CURLMoption = CURLOPTTYPE_OFF_T + 9
"""Content length penalty size."""
comptime CURLMOPT_CHUNK_LENGTH_PENALTY_SIZE: CURLMoption = CURLOPTTYPE_OFF_T + 10
"""Chunk length penalty size."""
comptime CURLMOPT_PIPELINING_SITE_BL: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 11
"""Pipelining site blacklist."""
comptime CURLMOPT_PIPELINING_SERVER_BL: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 12
"""Pipelining server blacklist."""
comptime CURLMOPT_MAX_TOTAL_CONNECTIONS: CURLMoption = CURLOPTTYPE_LONG + 13
"""Maximum total connections."""
comptime CURLMOPT_PUSHFUNCTION: CURLMoption = CURLOPTTYPE_FUNCTIONPOINT + 14
"""Push callback function."""
comptime CURLMOPT_PUSHDATA: CURLMoption = CURLOPTTYPE_OBJECTPOINT + 15
"""Data for push callback."""
comptime CURLMOPT_MAX_CONCURRENT_STREAMS: CURLMoption = CURLOPTTYPE_LONG + 16
"""Maximum concurrent streams."""

# These enums are for use with the CURLMOPT_PIPELINING option.
comptime CURLPIPE_NOTHING: c_long = 0
"""No pipelining."""
comptime CURLPIPE_HTTP1: c_long = 1
"""HTTP/1 pipelining."""
comptime CURLPIPE_MULTIPLEX: c_long = 2
"""HTTP/2 multiplexing."""

comptime CURL_ERROR_SIZE: UInt = 256
"""Size of error message buffer."""

comptime curl_opensocket_callback = def(CURL, curlsocktype, MutExternalPointer[curl_sockaddr]) abi(
    "C"
) thin -> curl_socket_t
"""Callback function for opening sockets."""
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


struct curl_sockaddr:
    """Structure representing a socket address for CURLOPT_OPENSOCKETFUNCTION."""

    var family: c_int
    """Address family."""
    var socktype: c_int
    """Socket type."""
    var protocol: c_int
    """Protocol."""
    var addrlen: c_uint
    """Length of the address in bytes. This was a `socklen_t` type before 7.18.0 but it turned really ugly and painful on the systems that lack this type."""
    var addr: sockaddr
    """The actual address. The size of this field is determined by the `addrlen` field."""


struct curl_header:
    """Struct representing a single header in the CURLH API."""

    var name: MutExternalPointer[c_char]
    """Pointer to the header name string."""
    var value: MutExternalPointer[c_char]
    """Pointer to the header value string."""
    var amount: c_size_t
    """Amount of data in the header."""
    var index: c_size_t
    """Index of the header."""
    var origin: c_uint
    """Origin of the header."""
    var anchor: MutExternalPointer[NoneType]
    """Pointer to the anchor."""
