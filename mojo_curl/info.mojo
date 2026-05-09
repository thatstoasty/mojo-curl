from std.ffi import c_int
from mojo_curl.c.types import (
    CURLINFO_EFFECTIVE_URL,
    CURLINFO_RESPONSE_CODE,
    CURLINFO_TOTAL_TIME,
    CURLINFO_NAMELOOKUP_TIME,
    CURLINFO_CONNECT_TIME,
    CURLINFO_PRETRANSFER_TIME,
    CURLINFO_SIZE_UPLOAD,
    CURLINFO_SIZE_DOWNLOAD,
    CURLINFO_SPEED_DOWNLOAD,
    CURLINFO_SPEED_UPLOAD,
    CURLINFO_HEADER_SIZE,
    CURLINFO_REQUEST_SIZE,
    CURLINFO_SSL_VERIFYRESULT,
    CURLINFO_FILETIME,
    CURLINFO_CONTENT_LENGTH_DOWNLOAD,
    CURLINFO_CONTENT_LENGTH_UPLOAD,
    CURLINFO_STARTTRANSFER_TIME,
    CURLINFO_CONTENT_TYPE,
    CURLINFO_REDIRECT_TIME,
    CURLINFO_REDIRECT_COUNT,
    CURLINFO_PRIVATE,
    CURLINFO_HTTP_CONNECTCODE,
    CURLINFO_HTTPAUTH_AVAIL,
    CURLINFO_PROXYAUTH_AVAIL,
    CURLINFO_OS_ERRNO,
    CURLINFO_NUM_CONNECTS,
    CURLINFO_SSL_ENGINES,
    CURLINFO_COOKIELIST,
    CURLINFO_FTP_ENTRY_PATH,
    CURLINFO_REDIRECT_URL,
    CURLINFO_PRIMARY_IP,
    CURLINFO_APPCONNECT_TIME,
    CURLINFO_CERTINFO,
    CURLINFO_CONDITION_UNMET,
    CURLINFO_RTSP_SESSION_ID,
    CURLINFO_RTSP_CLIENT_CSEQ,
    CURLINFO_RTSP_SERVER_CSEQ,
    CURLINFO_RTSP_CSEQ_RECV,
    CURLINFO_PRIMARY_PORT,
    CURLINFO_LOCAL_IP,
    CURLINFO_LOCAL_PORT,
    CURLINFO_ACTIVESOCKET,
    CURLINFO_TLS_SSL_PTR,
    CURLINFO_HTTP_VERSION,
    CURLINFO_PROXY_SSL_VERIFYRESULT,
    CURLINFO_SCHEME,
    CURLINFO_TOTAL_TIME_T,
    CURLINFO_NAMELOOKUP_TIME_T,
    CURLINFO_CONNECT_TIME_T,
    CURLINFO_PRETRANSFER_TIME_T,
    CURLINFO_STARTTRANSFER_TIME_T,
    CURLINFO_REDIRECT_TIME_T,
    CURLINFO_APPCONNECT_TIME_T,
    CURLINFO_RETRY_AFTER,
    CURLINFO_EFFECTIVE_METHOD,
    CURLINFO_PROXY_ERROR,
    CURLINFO_REFERER,
    CURLINFO_CAINFO,
    CURLINFO_CAPATH,
    CURLINFO_XFER_ID,
    CURLINFO_CONN_ID,
    CURLINFO_QUEUE_TIME_T,
    CURLINFO_USED_PROXY,
    CURLINFO_POSTTRANSFER_TIME_T,
    CURLINFO_EARLYDATA_SENT_T,
    CURLINFO_HTTPAUTH_USED,
    CURLINFO_PROXYAUTH_USED,
)

@fieldwise_init
struct Info(Copyable, TrivialRegisterPassable):
    """CURLINFO options for retrieving information from a CURL handle."""

    var value: c_int
    """Internal enum value."""

    comptime EFFECTIVE_URL = CURLINFO_EFFECTIVE_URL
    """[CURLINFO_EFFECTIVE_URL] Get the last used effective URL."""
    comptime RESPONSE_CODE = CURLINFO_RESPONSE_CODE
    """[CURLINFO_RESPONSE_CODE] Get the last received response code."""
    comptime TOTAL_TIME = CURLINFO_TOTAL_TIME
    """[CURLINFO_TOTAL_TIME] Get total time of previous transfer."""
    comptime NAME_LOOKUP_TIME = CURLINFO_NAMELOOKUP_TIME
    """[CURLINFO_NAMELOOKUP_TIME] Get time from start until name resolving completed."""
    comptime CONNECT_TIME = CURLINFO_CONNECT_TIME
    """[CURLINFO_CONNECT_TIME] Get time from start until connect to remote host completed."""
    comptime PRE_TRANSFER_TIME = CURLINFO_PRETRANSFER_TIME
    """[CURLINFO_PRETRANSFER_TIME] Get time from start until file transfer is just about to begin."""
    comptime SIZE_UPLOAD = CURLINFO_SIZE_UPLOAD
    """[CURLINFO_SIZE_UPLOAD] Get number of bytes uploaded."""
    comptime SIZE_DOWNLOAD = CURLINFO_SIZE_DOWNLOAD
    """[CURLINFO_SIZE_DOWNLOAD] Get number of bytes downloaded."""
    comptime SPEED_DOWNLOAD = CURLINFO_SPEED_DOWNLOAD
    """[CURLINFO_SPEED_DOWNLOAD] Get average download speed in number of bytes per second."""
    comptime SPEED_UPLOAD = CURLINFO_SPEED_UPLOAD
    """[CURLINFO_SPEED_UPLOAD] Get average upload speed in number of bytes per second."""
    comptime HEADER_SIZE = CURLINFO_HEADER_SIZE
    """[CURLINFO_HEADER_SIZE] Get number of bytes of all headers received."""
    comptime REQUEST_SIZE = CURLINFO_REQUEST_SIZE
    """[CURLINFO_REQUEST_SIZE] Get number of bytes sent in the issued HTTP requests."""
    comptime SSL_VERIFY_RESULT = CURLINFO_SSL_VERIFYRESULT
    """[CURLINFO_SSL_VERIFY_RESULT] Get certificate verification result."""
    comptime FILE_TIME = CURLINFO_FILETIME
    """[CURLINFO_FILE_TIME] Get remote time of the retrieved document."""
    comptime CONTENT_LENGTH_DOWNLOAD_T = CURLINFO_CONTENT_LENGTH_DOWNLOAD
    """[CURLINFO_CONTENT_LENGTH_DOWNLOAD_T] Get content length from the Content-Length header."""
    comptime CONTENT_LENGTH_UPLOAD_T = CURLINFO_CONTENT_LENGTH_UPLOAD
    """[CURLINFO_CONTENT_LENGTH_UPLOAD_T] Get upload size."""
    comptime START_TRANSFER_TIME = CURLINFO_STARTTRANSFER_TIME
    """[CURLINFO_STARTTRANSFER_TIME] Get time from start until first byte is received by libmojo_curl."""
    comptime CONTENT_TYPE = CURLINFO_CONTENT_TYPE
    """[CURLINFO_CONTENT_TYPE] Get content type from the Content-Type: header."""
    comptime REDIRECT_TIME = CURLINFO_REDIRECT_TIME
    """[CURLINFO_REDIRECT_TIME] Get time for all redirection steps before final transaction started."""
    comptime REDIRECT_COUNT = CURLINFO_REDIRECT_COUNT
    """[CURLINFO_REDIRECT_COUNT] Get total number of redirects that were followed."""
    comptime PRIVATE = CURLINFO_PRIVATE
    """[CURLINFO_PRIVATE] Get user's private data pointer."""
    comptime HTTP_CONNECT_CODE = CURLINFO_HTTP_CONNECTCODE
    """[CURLINFO_HTTP_CONNECTCODE] Get last proxy CONNECT response code."""
    comptime HTTP_AUTH_AVAIL = CURLINFO_HTTPAUTH_AVAIL
    """[CURLINFO_HTTPAUTH_AVAIL] Get available HTTP authentication methods."""
    comptime PROXY_AUTH_AVAIL = CURLINFO_PROXYAUTH_AVAIL
    """[CURLINFO_PROXYAUTH_AVAIL] Get available HTTP proxy authentication methods."""
    comptime OS_ERRNO = CURLINFO_OS_ERRNO
    """[CURLINFO_OS_ERRNO] Get the errno from the last failure to connect."""
    comptime NUM_CONNECTS = CURLINFO_NUM_CONNECTS
    """[CURLINFO_NUM_CONNECTS] Get number of new successful connections used for previous transfer."""
    comptime SSL_ENGINES = CURLINFO_SSL_ENGINES
    """[CURLINFO_SSL_ENGINES] Get a list of OpenSSL crypto engines."""
    comptime COOKIE_LIST = CURLINFO_COOKIELIST
    """[CURLINFO_COOKIELIST] Get list of all known cookies."""
    comptime FTP_ENTRY_PATH = CURLINFO_FTP_ENTRY_PATH
    """[CURLINFO_FTP_ENTRY_PATH] Get the entry path after logging in to an FTP server."""
    comptime REDIRECT_URL = CURLINFO_REDIRECT_URL
    """[CURLINFO_REDIRECT_URL] Get URL a redirect would take you to, had you enabled redirects."""
    comptime PRIMARY_IP = CURLINFO_PRIMARY_IP
    """[CURLINFO_PRIMARY_IP] Get destination IP address of the last connection."""
    comptime APP_CONNECT_TIME = CURLINFO_APPCONNECT_TIME
    """[CURLINFO_APPCONNECT_TIME] Get time from start until SSL connect/handshake completed."""
    comptime CERTINFO = CURLINFO_CERTINFO
    """[CURLINFO_CERTINFO] Get certificate chain."""
    comptime CONDITION_UNMET = CURLINFO_CONDITION_UNMET
    """[CURLINFO_CONDITION_UNMET] Get whether or not a time conditional was met or 304 HTTP response."""
    comptime RTSP_SESSION_ID = CURLINFO_RTSP_SESSION_ID
    """[CURLINFO_RTSP_SESSION_ID] Get RTSP session ID."""
    comptime RTSP_CLIENT_CSEQ = CURLINFO_RTSP_CLIENT_CSEQ
    """[CURLINFO_RTSP_CLIENT_CSEQ] Get the RTSP client CSeq that is expected next."""
    comptime RTSP_SERVER_CSEQ = CURLINFO_RTSP_SERVER_CSEQ
    """[CURLINFO_RTSP_SERVER_CSEQ] Get the RTSP server CSeq that is expected next."""
    comptime RTSP_CSEQ_RECV = CURLINFO_RTSP_CSEQ_RECV
    """[CURLINFO_RTSP_CSEQ_RECV] Get RTSP CSeq last received."""
    comptime PRIMARY_PORT = CURLINFO_PRIMARY_PORT
    """[CURLINFO_PRIMARY_PORT] Get destination port of the last connection."""
    comptime LOCAL_IP = CURLINFO_LOCAL_IP
    """[CURLINFO_LOCAL_IP] Get source IP address of the last connection."""
    comptime LOCAL_PORT = CURLINFO_LOCAL_PORT
    """[CURLINFO_LOCAL_PORT] Get source port number of the last connection."""
    comptime ACTIVE_SOCKET = CURLINFO_ACTIVESOCKET
    """[CURLINFO_ACTIVESOCKET] Get the session's active socket."""
    comptime TLS_SSL_PTR = CURLINFO_TLS_SSL_PTR
    """[CURLINFO_TLS_SSL_PTR] Get TLS session info that can be used for further processing."""
    comptime HTTP_VERSION = CURLINFO_HTTP_VERSION
    """[CURLINFO_HTTP_VERSION] Get the http version used in the connection."""
    comptime PROXY_SSL_VERIFY_RESULT = CURLINFO_PROXY_SSL_VERIFYRESULT
    """[CURLINFO_PROXY_SSL_VERIFYRESULT] Get proxy certificate verification result."""
    comptime SCHEME = CURLINFO_SCHEME
    """[CURLINFO_SCHEME] Get the scheme used for the connection."""
    comptime TOTAL_TIME_T = CURLINFO_TOTAL_TIME_T
    """[CURLINFO_TOTAL_TIME_T] Get total time of previous transfer in microseconds."""
    comptime NAMELOOKUP_TIME_T = CURLINFO_NAMELOOKUP_TIME_T
    """[CURLINFO_NAMELOOKUP_TIME_T] Get time from start until name resolving completed in microseconds."""
    comptime CONNECT_TIME_T = CURLINFO_CONNECT_TIME_T
    """[CURLINFO_CONNECT_TIME_T] Get time from start until connect to remote host completed in microseconds."""
    comptime PRETRANSFER_TIME_T = CURLINFO_PRETRANSFER_TIME_T
    """[CURLINFO_PRETRANSFER_TIME_T] Get time from start until file transfer is just about to begin in microseconds."""
    comptime STARTTRANSFER_TIME_T = CURLINFO_STARTTRANSFER_TIME_T
    """[CURLINFO_STARTTRANSFER_TIME_T] Get time from start until first byte is received by libcurl in microseconds."""
    comptime REDIRECT_TIME_T = CURLINFO_REDIRECT_TIME_T
    """[CURLINFO_REDIRECT_TIME_T] Get time for all redirection steps before final transaction started in microseconds."""
    comptime APP_CONNECT_TIME_T = CURLINFO_APPCONNECT_TIME_T
    """[CURLINFO_APPCONNECT_TIME_T] Get time from start until SSL connect/handshake completed in microseconds."""
    comptime RETRY_AFTER = CURLINFO_RETRY_AFTER
    """[CURLINFO_RETRY_AFTER] Get the value from the Retry-After header."""
    comptime EFFECTIVE_METHOD = CURLINFO_EFFECTIVE_METHOD
    """[CURLINFO_EFFECTIVE_METHOD] Get last used HTTP method."""
    comptime PROXY_ERROR = CURLINFO_PROXY_ERROR
    """[CURLINFO_PROXY_ERROR] Get detailed proxy error."""
    comptime REFERER = CURLINFO_REFERER
    """[CURLINFO_REFERER] Get referrer header."""
    comptime CA_INFO = CURLINFO_CAINFO
    """[CURLINFO_CAINFO] Get the default value for CURLOPT_CAINFO."""
    comptime CA_PATH = CURLINFO_CAPATH
    """[CURLINFO_CAPATH] Get the default value for CURLOPT_CAPATH."""
    comptime XFER_ID = CURLINFO_XFER_ID
    """[CURLINFO_XFER_ID] Get the ID of the transfer."""
    comptime CONN_ID = CURLINFO_CONN_ID
    """[CURLINFO_CONN_ID] Get the ID of the last connection used by the transfer."""
    comptime QUEUE_TIME_T = CURLINFO_QUEUE_TIME_T
    """[CURLINFO_QUEUE_TIME_T] Get the time the transfer was held in a waiting queue before it could start in microseconds."""
    comptime USED_PROXY = CURLINFO_USED_PROXY
    """[CURLINFO_USED_PROXY] Get whether the proxy was used."""
    comptime POST_TRANSFER_TIME_T = CURLINFO_POSTTRANSFER_TIME_T
    """[CURLINFO_POSTTRANSFER_TIME_T] Get the time from start until the last byte is sent by libcurl in microseconds."""
    comptime EARLY_DATA_SENT_T = CURLINFO_EARLYDATA_SENT_T
    """[CURLINFO_EARLYDATA_SENT_T] Get amount of TLS early data sent in number of bytes."""
    comptime HTTP_AUTH_USED = CURLINFO_HTTPAUTH_USED
    """[CURLINFO_HTTPAUTH_USED] Get used HTTP authentication method."""
    comptime PROXY_AUTH_USED = CURLINFO_PROXYAUTH_USED
    """[CURLINFO_PROXYAUTH_USED] Get used HTTP proxy authentication methods."""
