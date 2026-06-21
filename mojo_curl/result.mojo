"""CURL result code wrapper for error handling."""

from std.ffi import c_int
from mojo_curl.c.types import (
    CURLE_OK,
    CURLE_UNSUPPORTED_PROTOCOL,
    CURLE_FAILED_INIT,
    CURLE_URL_MALFORMAT,
    CURLE_NOT_BUILT_IN,
    CURLE_COULDNT_RESOLVE_PROXY,
    CURLE_COULDNT_RESOLVE_HOST,
    CURLE_COULDNT_CONNECT,
    CURLE_FTP_WEIRD_SERVER_REPLY,
    CURLE_REMOTE_ACCESS_DENIED,
    CURLE_FTP_ACCEPT_FAILED,
    CURLE_FTP_WEIRD_PASS_REPLY,
    CURLE_FTP_ACCEPT_TIMEOUT,
    CURLE_FTP_WEIRD_PASV_REPLY,
    CURLE_FTP_WEIRD_227_FORMAT,
    CURLE_FTP_CANT_GET_HOST,
    CURLE_HTTP2,
    CURLE_FTP_COULDNT_SET_TYPE,
    CURLE_PARTIAL_FILE,
    CURLE_FTP_COULDNT_RETR_FILE,
    CURLE_QUOTE_ERROR,
    CURLE_HTTP_RETURNED_ERROR,
    CURLE_WRITE_ERROR,
    CURLE_UPLOAD_FAILED,
    CURLE_READ_ERROR,
    CURLE_OUT_OF_MEMORY,
    CURLE_OPERATION_TIMEDOUT,
    CURLE_FTP_PORT_FAILED,
    CURLE_FTP_COULDNT_USE_REST,
    CURLE_RANGE_ERROR,
    CURLE_HTTP_POST_ERROR,
    CURLE_SSL_CONNECT_ERROR,
    CURLE_BAD_DOWNLOAD_RESUME,
    CURLE_FILE_COULDNT_READ_FILE,
    CURLE_LDAP_CANNOT_BIND,
    CURLE_LDAP_SEARCH_FAILED,
    CURLE_FUNCTION_NOT_FOUND,
    CURLE_ABORTED_BY_CALLBACK,
    CURLE_BAD_FUNCTION_ARGUMENT,
    CURLE_INTERFACE_FAILED,
    CURLE_TOO_MANY_REDIRECTS,
    CURLE_UNKNOWN_OPTION,
    CURLE_GOT_NOTHING,
    CURLE_SSL_ENGINE_NOTFOUND,
    CURLE_SSL_ENGINE_SETFAILED,
    CURLE_SEND_ERROR,
    CURLE_RECV_ERROR,
    CURLE_SSL_CERTPROBLEM,
    CURLE_SSL_CIPHER,
    CURLE_PEER_FAILED_VERIFICATION,
    CURLE_BAD_CONTENT_ENCODING,
    CURLE_FILESIZE_EXCEEDED,
    CURLE_USE_SSL_FAILED,
    CURLE_SEND_FAIL_REWIND,
    CURLE_SSL_ENGINE_INITFAILED,
    CURLE_LOGIN_DENIED,
    CURLE_TFTP_NOTFOUND,
    CURLE_TFTP_PERM,
    CURLE_REMOTE_DISK_FULL,
    CURLE_TFTP_ILLEGAL,
    CURLE_TFTP_UNKNOWNID,
    CURLE_REMOTE_FILE_EXISTS,
    CURLE_TFTP_NOSUCHUSER,
    CURLE_SSL_CACERT_BADFILE,
    CURLE_REMOTE_FILE_NOT_FOUND,
    CURLE_SSH,
    CURLE_SSL_SHUTDOWN_FAILED,
    CURLE_AGAIN,
    CURLE_SSL_CRL_BADFILE,
    CURLE_SSL_ISSUER_ERROR,
    CURLE_FTP_PRET_FAILED,
    CURLE_RTSP_CSEQ_ERROR,
    CURLE_RTSP_SESSION_ERROR,
    CURLE_FTP_BAD_FILE_LIST,
    CURLE_CHUNK_FAILED,
    CURLE_NO_CONNECTION_AVAILABLE,
    CURLE_SSL_PINNEDPUBKEYNOTMATCH,
    CURLE_SSL_INVALIDCERTSTATUS,
    CURLE_HTTP2_STREAM,
    CURLE_RECURSIVE_API_CALL,
)


struct Result(Equatable, TrivialRegisterPassable, Writable):
    """CURLcode result codes."""

    var value: c_int
    """Internal enum value."""
    comptime OK: Self = CURLE_OK
    """Operation completed successfully."""
    comptime UNSUPPORTED_PROTOCOL: Self = CURLE_UNSUPPORTED_PROTOCOL
    """The URL scheme is not supported."""
    comptime FAILED_INIT: Self = CURLE_FAILED_INIT
    """Failed to initialize the CURL library."""
    comptime URL_MALFORMAT: Self = CURLE_URL_MALFORMAT
    """The URL format is invalid."""
    comptime NOT_BUILT_IN: Self = CURLE_NOT_BUILT_IN
    """A feature or protocol is not built in."""
    comptime COULDNT_RESOLVE_PROXY: Self = CURLE_COULDNT_RESOLVE_PROXY
    """Failed to resolve the proxy hostname."""
    comptime COULDNT_RESOLVE_HOST: Self = CURLE_COULDNT_RESOLVE_HOST
    """Failed to resolve the remote hostname."""
    comptime COULDNT_CONNECT: Self = CURLE_COULDNT_CONNECT
    """Failed to connect to the remote host."""
    comptime FTP_WEIRD_SERVER_REPLY: Self = CURLE_FTP_WEIRD_SERVER_REPLY
    """Received an unexpected FTP server response."""
    comptime REMOTE_ACCESS_DENIED: Self = CURLE_REMOTE_ACCESS_DENIED
    """Access to the remote resource was denied."""
    comptime FTP_ACCEPT_FAILED: Self = CURLE_FTP_ACCEPT_FAILED
    """FTP ACCEPT command failed."""
    comptime FTP_WEIRD_PASS_REPLY: Self = CURLE_FTP_WEIRD_PASS_REPLY
    """Received an unexpected FTP PASS reply."""
    comptime FTP_ACCEPT_TIMEOUT: Self = CURLE_FTP_ACCEPT_TIMEOUT
    """FTP ACCEPT command timed out."""
    comptime FTP_WEIRD_PASV_REPLY: Self = CURLE_FTP_WEIRD_PASV_REPLY
    """Received an unexpected FTP PASV reply."""
    comptime FTP_WEIRD_227_FORMAT: Self = CURLE_FTP_WEIRD_227_FORMAT
    """FTP 227 response format is invalid."""
    comptime FTP_CANT_GET_HOST: Self = CURLE_FTP_CANT_GET_HOST
    """Failed to determine the FTP host."""
    comptime HTTP2: Self = CURLE_HTTP2
    """An HTTP/2 error occurred."""
    comptime FTP_COULDNT_SET_TYPE: Self = CURLE_FTP_COULDNT_SET_TYPE
    """Failed to set the FTP transfer type."""
    comptime PARTIAL_FILE: Self = CURLE_PARTIAL_FILE
    """The remote file is incomplete or was only partially downloaded."""
    comptime FTP_COULDNT_RETR_FILE: Self = CURLE_FTP_COULDNT_RETR_FILE
    """Failed to retrieve the FTP file."""
    comptime QUOTE_ERROR: Self = CURLE_QUOTE_ERROR
    """An error occurred with a quote command."""
    comptime HTTP_RETURNED_ERROR: Self = CURLE_HTTP_RETURNED_ERROR
    """An HTTP error response code was received."""
    comptime WRITE_ERROR: Self = CURLE_WRITE_ERROR
    """An error occurred while writing received data."""
    comptime UPLOAD_FAILED: Self = CURLE_UPLOAD_FAILED
    """The file upload failed."""
    comptime READ_ERROR: Self = CURLE_READ_ERROR
    """Failed to read a local file for uploading."""
    comptime OUT_OF_MEMORY: Self = CURLE_OUT_OF_MEMORY
    """Out of memory."""
    comptime OPERATION_TIMEDOUT: Self = CURLE_OPERATION_TIMEDOUT
    """The operation timeout was reached."""
    comptime FTP_PORT_FAILED: Self = CURLE_FTP_PORT_FAILED
    """FTP PORT command failed."""
    comptime FTP_COULDNT_USE_REST: Self = CURLE_FTP_COULDNT_USE_REST
    """The FTP REST command failed."""
    comptime RANGE_ERROR: Self = CURLE_RANGE_ERROR
    """An error occurred with the range request."""
    comptime HTTP_POST_ERROR: Self = CURLE_HTTP_POST_ERROR
    """An error occurred in an HTTP POST operation."""
    comptime SSL_CONNECT_ERROR: Self = CURLE_SSL_CONNECT_ERROR
    """Failed to establish an SSL connection."""
    comptime BAD_DOWNLOAD_RESUME: Self = CURLE_BAD_DOWNLOAD_RESUME
    """The download could not be resumed."""
    comptime FILE_COULDNT_READ_FILE: Self = CURLE_FILE_COULDNT_READ_FILE
    """Could not read the file:// resource."""
    comptime LDAP_CANNOT_BIND: Self = CURLE_LDAP_CANNOT_BIND
    """Failed to bind to the LDAP server."""
    comptime LDAP_SEARCH_FAILED: Self = CURLE_LDAP_SEARCH_FAILED
    """The LDAP search failed."""
    comptime FUNCTION_NOT_FOUND: Self = CURLE_FUNCTION_NOT_FOUND
    """A required function was not found in a library."""
    comptime ABORTED_BY_CALLBACK: Self = CURLE_ABORTED_BY_CALLBACK
    """The operation was aborted by a callback."""
    comptime BAD_FUNCTION_ARGUMENT: Self = CURLE_BAD_FUNCTION_ARGUMENT
    """An invalid argument was passed to a function."""
    comptime INTERFACE_FAILED: Self = CURLE_INTERFACE_FAILED
    """Failed to use the specified network interface."""
    comptime TOO_MANY_REDIRECTS: Self = CURLE_TOO_MANY_REDIRECTS
    """Too many redirects were encountered."""
    comptime UNKNOWN_OPTION: Self = CURLE_UNKNOWN_OPTION
    """An unknown CURL option was specified."""
    comptime GOT_NOTHING: Self = CURLE_GOT_NOTHING
    """Server returned nothing, and no reply was received."""
    comptime SSL_ENGINE_NOTFOUND: Self = CURLE_SSL_ENGINE_NOTFOUND
    """The specified SSL engine was not found."""
    comptime SSL_ENGINE_SETFAILED: Self = CURLE_SSL_ENGINE_SETFAILED
    """Failed to set the SSL engine."""
    comptime SEND_ERROR: Self = CURLE_SEND_ERROR
    """An error occurred while sending data."""
    comptime RECV_ERROR: Self = CURLE_RECV_ERROR
    """An error occurred while receiving data."""
    comptime SSL_CERT_PROBLEM: Self = CURLE_SSL_CERTPROBLEM
    """A problem occurred with the SSL certificate."""
    comptime SSL_CIPHER: Self = CURLE_SSL_CIPHER
    """Could not use the specified SSL cipher."""
    comptime PEER_FAILED_VERIFICATION: Self = CURLE_PEER_FAILED_VERIFICATION
    """The peer verification failed."""
    comptime BAD_CONTENT_ENCODING: Self = CURLE_BAD_CONTENT_ENCODING
    """Received an unknown or unsupported Content-Encoding."""
    comptime FILESIZE_EXCEEDED: Self = CURLE_FILESIZE_EXCEEDED
    """The file size limit was exceeded."""
    comptime USE_SSL_FAILED: Self = CURLE_USE_SSL_FAILED
    """Failed to use SSL."""
    comptime SEND_FAIL_REWIND: Self = CURLE_SEND_FAIL_REWIND
    """Failed to rewind the data stream."""
    comptime SSL_ENGINE_INITFAILED: Self = CURLE_SSL_ENGINE_INITFAILED
    """Failed to initialize the SSL engine."""
    comptime LOGIN_DENIED: Self = CURLE_LOGIN_DENIED
    """The login was denied."""
    comptime TFTP_NOTFOUND: Self = CURLE_TFTP_NOTFOUND
    """TFTP file not found."""
    comptime TFTP_PERM: Self = CURLE_TFTP_PERM
    """TFTP permission denied."""
    comptime REMOTE_DISK_FULL: Self = CURLE_REMOTE_DISK_FULL
    """The remote disk is full."""
    comptime TFTP_ILLEGAL: Self = CURLE_TFTP_ILLEGAL
    """TFTP illegal operation."""
    comptime TFTP_UNKNOWN_ID: Self = CURLE_TFTP_UNKNOWNID
    """TFTP unknown transfer ID."""
    comptime REMOTE_FILE_EXISTS: Self = CURLE_REMOTE_FILE_EXISTS
    """The remote file already exists."""
    comptime TFTP_NO_SUCH_USER: Self = CURLE_TFTP_NOSUCHUSER
    """TFTP no such user."""
    comptime SSL_CACERT_BAD_FILE: Self = CURLE_SSL_CACERT_BADFILE
    """The CA certificate file is invalid."""
    comptime REMOTE_FILE_NOT_FOUND: Self = CURLE_REMOTE_FILE_NOT_FOUND
    """The remote file was not found."""
    comptime SSH: Self = CURLE_SSH
    """An error occurred during SSH operation."""
    comptime SSL_SHUTDOWN_FAILED: Self = CURLE_SSL_SHUTDOWN_FAILED
    """Failed to shut down the SSL connection."""
    comptime AGAIN: Self = CURLE_AGAIN
    """A temporary error occurred; try again."""
    comptime SSL_CRL_BADFILE: Self = CURLE_SSL_CRL_BADFILE
    """The CRL file is invalid."""
    comptime SSL_ISSUER_ERROR: Self = CURLE_SSL_ISSUER_ERROR
    """The SSL issuer certificate verification failed."""
    comptime FTP_PRET_FAILED: Self = CURLE_FTP_PRET_FAILED
    """FTP PRET command failed."""
    comptime RTSP_CSEQ_ERROR: Self = CURLE_RTSP_CSEQ_ERROR
    """RTSP CSeq number mismatch."""
    comptime RTSP_SESSION_ERROR: Self = CURLE_RTSP_SESSION_ERROR
    """RTSP session error."""
    comptime FTP_BAD_FILE_LIST: Self = CURLE_FTP_BAD_FILE_LIST
    """The FTP file list is invalid."""
    comptime CHUNK_FAILED: Self = CURLE_CHUNK_FAILED
    """Chunk callback error."""
    comptime NO_CONNECTION_AVAILABLE: Self = CURLE_NO_CONNECTION_AVAILABLE
    """No connection is available."""
    comptime SSL_PINNED_PUBKEY_NOT_MATCH: Self = CURLE_SSL_PINNEDPUBKEYNOTMATCH
    """The pinned public key does not match."""
    comptime SSL_INVALID_CERT_STATUS: Self = CURLE_SSL_INVALIDCERTSTATUS
    """The SSL certificate status is invalid."""
    comptime HTTP2_STREAM: Self = CURLE_HTTP2_STREAM
    """An HTTP/2 stream error occurred."""
    comptime RECURSIVE_API_CALL: Self = CURLE_RECURSIVE_API_CALL
    """A recursive API call was detected."""

    @implicit
    def __init__(out self, value: Int):
        """Implicit conversion from Int to Result.

        Args:
            value: The integer value to convert to Result.
        """
        self.value = c_int(value)

    @implicit
    def __init__(out self, value: Int32):
        """Implicit conversion from Int32 to Result.

        Args:
            value: The integer value to convert to Result.
        """
        self.value = value
