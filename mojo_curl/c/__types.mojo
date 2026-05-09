from std.ffi import c_char, c_int, c_long, c_size_t, c_uint
from mojo_curl.c.network import sockaddr

comptime ImmutExternalPointer = ImmutUnsafePointer[origin=ImmutExternalOrigin, ...]
comptime MutExternalPointer = MutUnsafePointer[origin=MutExternalOrigin, ...]

# Type aliases for curl
comptime CURL = MutExternalPointer[NoneType]
"""Opaque pointer type for CURL easy handles."""

struct curl_slist(TrivialRegisterPassable):
    """Singly linked list structure for curl string lists."""

    var data: MutExternalPointer[c_char]
    """Pointer to the data string for this node."""
    var next: MutExternalPointer[curl_slist]
    """Pointer to the next node in the list."""


comptime curl_socket_t = c_int
"""Type alias for curl socket type. Note that on some platforms this may be defined as an unsigned type, but we use c_int for simplicity and compatibility."""
comptime CURL_SOCKET_BAD = -1
"""Constant representing an invalid socket in curl."""
comptime curl_off_t = c_long
"""Type alias for curl offset type, used for file sizes and offsets."""
comptime time_t = Int64
"""Type alias for time type used in curl, typically representing seconds since the Unix epoch."""

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


# Flag bits for curl_blob struct
comptime CURL_BLOB_COPY = 1
"""Flag indicating that curl should copy the data from the blob. This is the default behavior if no flags are set."""
comptime CURL_BLOB_NOCOPY = 0
"""Flag indicating that curl should use the data from the blob directly without copying. The caller must ensure that the data remains valid for the duration of the curl operation."""



comptime CURL_IPRESOLVE_WHATEVER: c_int = 0
comptime CURL_IPRESOLVE_V4: c_int = 1
comptime CURL_IPRESOLVE_V6: c_int = 2

comptime CURLSSLOPT_ALLOW_BEAST: c_long = 1 << 0
comptime CURLSSLOPT_NO_REVOKE: c_long = 1 << 1
comptime CURLSSLOPT_NO_PARTIALCHAIN: c_long = 1 << 2
comptime CURLSSLOPT_REVOKE_BEST_EFFORT: c_long = 1 << 3
comptime CURLSSLOPT_NATIVE_CA: c_long = 1 << 4
comptime CURLSSLOPT_AUTO_CLIENT_CERT: c_long = 1 << 5


# HTTP version options
@fieldwise_init
struct HTTPVersion(Copyable, TrivialRegisterPassable):
    """CURL HTTP version options for setting HTTP versions."""

    var value: c_int
    comptime NONE = Self(0)
    comptime V1_0 = Self(1)
    comptime V1_1 = Self(2)
    comptime V2_0 = Self(3)
    comptime V2_TLS = Self(4)
    comptime V2_PRIOR_KNOWLEDGE = Self(5)
    comptime V3 = Self(30)


# SSL version options
@fieldwise_init
struct SSLVersion(Copyable, TrivialRegisterPassable):
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
    def __init__(out self, value: Int):
        self.value = c_int(value)


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


comptime curl_ssl_backend = c_int
comptime CURLSSLBACKEND_NONE: curl_ssl_backend = 0
comptime CURLSSLBACKEND_OPENSSL: curl_ssl_backend = 1
comptime CURLSSLBACKEND_AWSLC: curl_ssl_backend = 1
comptime CURLSSLBACKEND_BORINGSSL: curl_ssl_backend = 1
comptime CURLSSLBACKEND_LIBRESSL: curl_ssl_backend = 1
comptime CURLSSLBACKEND_GNUTLS: curl_ssl_backend = 2
comptime CURLSSLBACKEND_NSS: curl_ssl_backend = 3
comptime CURLSSLBACKEND_GSKIT: curl_ssl_backend = 5
comptime CURLSSLBACKEND_POLARSSL: curl_ssl_backend = 6
comptime CURLSSLBACKEND_WOLFSSL: curl_ssl_backend = 7
comptime CURLSSLBACKEND_CYASSL: curl_ssl_backend = 7
comptime CURLSSLBACKEND_SCHANNEL: curl_ssl_backend = 8
comptime CURLSSLBACKEND_SECURETRANSPORT: curl_ssl_backend = 9
comptime CURLSSLBACKEND_DARWINSSL: curl_ssl_backend = 9
comptime CURLSSLBACKEND_AXTLS: curl_ssl_backend = 10
comptime CURLSSLBACKEND_MBEDTLS: curl_ssl_backend = 11
comptime CURLSSLBACKEND_MESALINK: curl_ssl_backend = 12
comptime CURLSSLBACKEND_BEARSSL: curl_ssl_backend = 13
comptime CURLSSLBACKEND_RUSTLS: curl_ssl_backend = 14


comptime CURLFOLLOW_ALL: c_long = 1
"""Bits for the FOLLOWLOCATION option."""
comptime CURLFOLLOW_OBEYCODE: c_long = 2
"""Do not use the custom method in the follow-up request if the HTTP code instructs so (301, 302, 303)."""
comptime CURLFOLLOW_FIRSTONLY: c_long = 3
"""Only use the custom method in the first request, always reset in the next."""

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

comptime CURL_PROGRESSFUNC_CONTINUE = 0x10000001
"""This is a return code for the progress callback that, when returned,
signals libcurl to continue executing the default progress function."""

comptime ProgressCallbackFn = def(ImmutExternalPointer[NoneType], Float64, Float64, Float64, Float64) abi("C") thin -> c_int
"""This is the prototype for the progress callback function used by curl. It was deprecated in favor of `TransferInfoCallbackFn` but is still supported for backward compatibility."""

comptime TransferInfoCallbackFn = def(
    ImmutExternalPointer[NoneType], curl_off_t, curl_off_t, curl_off_t, curl_off_t
) abi("C") thin -> c_int
"""This is the XFERINFOFUNCTION callback prototype. It was introduced 
in 7.32.0, avoids the use of floating point numbers and provides more
detailed information."""

comptime CURL_MAX_READ_SIZE = (10 * 1024 * 1024)
"""The maximum receive buffer size configurable via BUFFERSIZE."""

comptime CURL_MAX_WRITE_SIZE = 16384
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
"""This is a return code for the write callback that, when returned,
will signal libcurl to pause receiving on the current transfer."""

comptime CURL_WRITEFUNC_ERROR = 0xFFFFFFFF
"""This is a return code for the write callback that, when returned,
will signal an error from the callback."""

comptime WriteCallbackFn = def(MutExternalPointer[c_char], c_size_t, c_size_t, MutExternalPointer[NoneType]) abi("C") thin -> c_size_t
"""This is the prototype for the write callback function used by curl. It matches the `CURLOPT_WRITEFUNCTION` prototype and can also be used where a generic read/write signature is needed."""

comptime ResolverStartCallbackFn = def(MutExternalPointer[NoneType], MutExternalPointer[NoneType], MutExternalPointer[NoneType]) abi("C") thin -> c_int
"""This callback will be called when a new resolver request is made."""

comptime curlfiletype = c_int
"""Enumeration of file types used in curl_fileinfo struct."""
comptime CURLFILETYPE_FILE = 0
"""Regular file."""
comptime CURLFILETYPE_DIRECTORY = 1
"""Directory."""
comptime CURLFILETYPE_SYMLINK = 2
"""Symbolic link."""
comptime CURLFILETYPE_DEVICE_BLOCK = 3
"""Block device."""
comptime CURLFILETYPE_DEVICE_CHAR = 4
"""Character device."""
comptime CURLFILETYPE_NAMEDPIPE = 5
"""Named pipe (FIFO)."""
comptime CURLFILETYPE_SOCKET = 6
"""Socket."""
comptime CURLFILETYPE_DOOR = 7
"""Door (only on Sun Solaris)."""
comptime CURLFILETYPE_UNKNOWN = 8
"""Unknown file type. Should never occur."""

comptime CURLFINFOFLAG_KNOWN_FILENAME = (1 << 0)
"""Indicates that the filename field of curl_fileinfo struct is valid."""
comptime CURLFINFOFLAG_KNOWN_FILETYPE = (1 << 1)
"""Indicates that the filetype field of curl_fileinfo struct is valid."""
comptime CURLFINFOFLAG_KNOWN_TIME = (1 << 2)
"""Indicates that the time field of curl_fileinfo struct is valid."""
comptime CURLFINFOFLAG_KNOWN_PERM = (1 << 3)
"""Indicates that the perm field of curl_fileinfo struct is valid."""
comptime CURLFINFOFLAG_KNOWN_UID = (1 << 4)
"""Indicates that the uid field of curl_fileinfo struct is valid."""
comptime CURLFINFOFLAG_KNOWN_GID = (1 << 5)
"""Indicates that the gid field of curl_fileinfo struct is valid."""
comptime CURLFINFOFLAG_KNOWN_SIZE = (1 << 6)
"""Indicates that the size field of curl_fileinfo struct is valid."""
comptime CURLFINFOFLAG_KNOWN_HLINKCOUNT = (1 << 7)
"""Indicates that the hardlinks field of curl_fileinfo struct is valid."""


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

# return codes for CURLOPT_CHUNK_BGN_FUNCTION
comptime CURL_CHUNK_BGN_FUNC_OK = 0
"""Indicates that the chunk processing should continue."""
comptime CURL_CHUNK_BGN_FUNC_FAIL = 1
"""Indicates that the chunk processing should be aborted and the transfer should end with an error."""
comptime CURL_CHUNK_BGN_FUNC_SKIP = 2
"""Skip this chunk over. Note that if this is returned, then the CHUNK_END_FUNCTION callback will not be called for this chunk."""

comptime ChunkBgnCallbackFn = def(ImmutExternalPointer[NoneType], MutExternalPointer[NoneType], c_int) abi("C") thin -> c_long
"""If splitting of data transfer is enabled, this callback is called before
download of an individual chunk started. Note that parameter "remains" works
only for FTP wildcard downloading (for now), otherwise is not used."""

# Return codes for CURLOPT_CHUNK_END_FUNCTION
comptime CURL_CHUNK_END_FUNC_OK = 0
"""Indicates that the chunk processing should continue."""
comptime CURL_CHUNK_END_FUNC_FAIL = 1
"""Indicates that the chunk processing should be aborted and the transfer should end with an error."""

comptime ChunkEndCallbackFn = def(MutExternalPointer[NoneType]) abi("C") thin -> c_long
"""If splitting of data transfer is enabled this callback is called after
download of an individual chunk finished.
Note! After this callback was set then it have to be called FOR ALL chunks.
Even if downloading of this chunk was skipped in CHUNK_BGN_FUNC.
This is the reason why we do not need "transfer_info" parameter in this
callback and we are not interested in "remains" parameter too."""

# Return codes for FNMATCHFUNCTION
comptime CURL_FNMATCHFUNC_MATCH = 0
"""String corresponds to the pattern."""
comptime CURL_FNMATCHFUNC_NOMATCH = 1
"""Pattern does not match the string."""
comptime CURL_FNMATCHFUNC_FAIL = 2
"""An error occurred."""

comptime FNMatchCallbackFn = def(MutExternalPointer[NoneType], ImmutExternalPointer[c_char], ImmutExternalPointer[c_char]) abi("C") thin -> c_int
"""Callback type for wildcard downloading pattern matching. If the
string matches the pattern, return CURL_FNMATCHFUNC_MATCH value, etc."""

comptime CURL_SEEKFUNC_OK = 0
"""This is a return code for the seek callback that, when returned, will signal
libcurl that the callback successfully seeked to the requested position."""
comptime CURL_SEEKFUNC_FAIL = 1
"""This is a return code for the seek callback that, when returned, will signal
libcurl that the callback failed to seek to the requested position."""
comptime CURL_SEEKFUNC_CANTSEEK = 2
"""This is a return code for the seek callback that, when returned, will signal
libcurl that seeking cannot be done, so libcurl might try other means instead."""

comptime SeekCallbackFn = def(MutExternalPointer[NoneType], curl_off_t, c_int) abi("C") thin -> c_int
"""This callback will be called when libcurl needs to seek in the input stream."""

comptime CURL_READFUNC_ABORT = 0x10000000
"""This is a return code for the read callback that, when returned,
will signal libcurl to abort the current transfer."""
comptime CURL_READFUNC_PAUSE = 0x10000001
"""This is a return code for the read callback that, when returned,
will signal libcurl to pause sending data on the current transfer."""

comptime CURL_TRAILERFUNC_OK = 0
"""Return code for when the trailing headers' callback has terminated without any errors."""
comptime CURL_TRAILERFUNC_ABORT = 1
"""Return code for when there was an error in the trailing header's list and we want to abort the request."""

comptime ReadCallbackFn = def(MutExternalPointer[c_char], c_size_t, c_size_t, MutExternalPointer[NoneType]) abi("C") thin -> c_size_t
"""This is the prototype for the read callback function used by curl. It matches the `CURLOPT_READFUNCTION` prototype, where the first argument is a writable buffer that the callback must fill."""
comptime TrailerCallbackFn = def(MutExternalPointer[MutExternalPointer[curl_slist]], MutExternalPointer[NoneType]) abi("C") thin -> c_int
"""This is the prototype for the trailing headers callback function used by curl. It matches the `CURLOPT_TRAILERFUNCTION` prototype, where the first argument is a pointer to a pointer to a curl_slist that the callback must fill with the trailing headers."""

comptime curlsocktype = c_int
"""Enumeration of socket types used in `CURLOPT_OPENSOCKETFUNCTION` callback."""
comptime CURLSOCKTYPE_IPCXN: curlsocktype = 0
"""Socket created for a specific IP connection."""
comptime CURLSOCKTYPE_ACCEPT: curlsocktype = 1
"""Socket created by accept() call."""
comptime CURLSOCKTYPE_LAST: curlsocktype = 2
"""Never use."""

# The return code from the sockopt_callback can signal information back to libcurl
comptime CURL_SOCKOPT_OK = 0
"""Indicates that the socket options were set successfully and libcurl can continue as usual."""
comptime CURL_SOCKOPT_ERROR = 1
"""Indicates that there was an error setting the socket options and libcurl should abort the current transfer. libcurl will return `CURLE_ABORTED_BY_CALLBACK`."""
comptime CURL_SOCKOPT_ALREADY_CONNECTED = 2
"""Indicates that the socket is already connected."""

comptime SockOptCallbackFn = def(MutExternalPointer[NoneType], curl_socket_t, curlsocktype) abi("C") thin -> c_int
"""This callback will be called immediately after a socket is created by libcurl, and allows the application to set custom options on the socket. The callback should return CURL_SOCKOPT_OK if the options were set successfully, CURL_SOCKOPT_ERROR if there was an error and the transfer should be aborted, or CURL_SOCKOPT_ALREADY_CONNECTED if the socket is already connected."""

struct curl_sockaddr():
    var family: c_int
    var socktype: c_int
    var protocol: c_int
    var addrlen: c_uint
    """Length of the address in bytes. This was a `socklen_t` type before 7.18.0 but it turned really ugly and painful on the systems that lack this type."""
    var addr: sockaddr
    """The actual address. The size of this field is determined by the `addrlen` field."""

comptime OpenSocketCallbackFn = def(MutExternalPointer[NoneType], curlsocktype, MutExternalPointer[curl_sockaddr]) abi("C") thin -> curl_socket_t
"""This callback will be called when libcurl needs to open a socket. The application can create the socket itself and return it, or return `CURL_SOCKET_BAD` to let libcurl open the socket as usual."""
comptime CloseSocketCallbackFn = def(MutExternalPointer[NoneType], curl_socket_t) abi("C") thin -> c_int
"""This callback will be called when libcurl needs to close a socket. The application can close the socket itself and return 0, or return a non-zero value to let libcurl close the socket as usual."""
comptime curlioerr = c_int
"""Enumeration of return codes for the `CURLOPT_IOCTLFUNCTION` callback."""
comptime CURLIOE_OK: curlioerr = 0
"""Indicates that the I/O operation was successful."""
comptime CURLIOE_UNKNOWNCMD: curlioerr = 1
"""Indicates that the command was unknown to the callback."""
comptime CURLIOE_FAILRESTART: curlioerr = 2
"""Indicates that the callback failed to restart the read."""
comptime CURLIOE_LAST: curlioerr = 3
"""Marker for the last valid curlioerr value. Never use."""

comptime curliocmd = c_int
"""Enumeration of commands for the `CURLOPT_IOCTLFUNCTION` callback."""
comptime CURLIOCMD_NOP: curliocmd = 0
"""No operation. This command is used when libcurl wants to check if the callback is still alive."""
comptime CURLIOCMD_RESTARTREAD: curliocmd = 1
"""Restart the read stream from the beginning. This command is used when libcurl needs to restart the read stream, for example when a retry is needed after a failed upload."""
comptime CURLIOCMD_LAST: curliocmd = 2
"""Marker for the last valid curliocmd value. Never use."""

comptime IOCtlCallbackFn = def(CURL, curliocmd, MutExternalPointer[NoneType]) abi("C") thin -> curlioerr
"""This is the prototype for the ioctl callback function used by curl. It matches the `CURLOPT_IOCTLFUNCTION` prototype, where the `cmd` parameter is one of the `curliocmd` values and the return value should be one of the `curlioerr` values."""


# The following typedef's are signatures of malloc, free, realloc, strdup and calloc respectively.
# Function pointers of these types can be passed to the
# curl_global_init_mem() function to set user defined memory management
# callback routines.
comptime MallocCallbackFn = def(size: c_size_t) abi("C") thin -> MutExternalPointer[NoneType]
comptime FreeCallbackFn = def(ptr: MutExternalPointer[NoneType]) abi("C") thin -> None
comptime ReallocCallbackFn = def(ptr: MutExternalPointer[NoneType], size: c_size_t) abi("C") thin -> MutExternalPointer[NoneType]
comptime StrdupCallbackFn = def(str: ImmutExternalPointer[c_char]) abi("C") thin -> MutExternalPointer[c_char]
comptime CallocCallbackFn = def(nmemb: c_size_t, size: c_size_t) abi("C") thin -> MutExternalPointer[NoneType]

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
comptime CURLINFO_END: curl_infotype = 7
"""Marker for the last valid curl_infotype value. Never use."""

comptime DebugCallbackFn = def(CURL, c_int, MutExternalPointer[c_char], c_size_t, MutExternalPointer[NoneType]) abi("C") thin -> c_int
"""This is the prototype for the debug callback function used by curl. It is used for `CURLOPT_DEBUGFUNCTION`."""
comptime PreReqCallbackFn = def(MutExternalPointer[NoneType], MutExternalPointer[c_char], MutExternalPointer[c_char], c_int, c_int) abi("C") thin -> c_int
"""This is the `CURLOPT_PREREQFUNCTION` callback prototype."""

comptime CURL_PREREQFUNC_OK = 0
"""Return code for when the pre-request callback has terminated without any errors."""
comptime CURL_PREREQFUNC_ABORT = 1
"""Return code for when there was an error in the pre-request callback and we want to abort the request."""

comptime CURL_GLOBAL_SSL = (1 << 0)
comptime CURL_GLOBAL_WIN32 = (1 << 1)
comptime CURL_GLOBAL_ALL = (CURL_GLOBAL_SSL | CURL_GLOBAL_WIN32)
comptime CURL_GLOBAL_NOTHING = 0
comptime CURL_GLOBAL_DEFAULT = CURL_GLOBAL_ALL
comptime CURL_GLOBAL_ACK_EINTR = (1 << 2)
