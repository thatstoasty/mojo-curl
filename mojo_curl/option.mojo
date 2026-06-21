"""CURL option wrapper for setting options on CURL easy handles."""

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
    CURLOPT_DNS_USE_GLOBAL_CACHE,
    CURLOPT_DNS_CACHE_TIMEOUT,
    CURLOPT_PREQUOTE,
    CURLOPT_DEBUGFUNCTION,
    CURLOPT_DEBUGDATA,
    CURLOPT_COOKIESESSION,
    CURLOPT_CAPATH,
    CURLOPT_BUFFERSIZE,
    CURLOPT_NOSIGNAL,
    CURLOPT_SHARE,
    CURLOPT_PROXYTYPE,
    CURLOPT_ACCEPT_ENCODING,
    CURLOPT_PRIVATE,
    CURLOPT_HTTP200ALIASES,
    CURLOPT_UNRESTRICTED_AUTH,
    CURLOPT_FTP_USE_EPRT,
    CURLOPT_HTTPAUTH,
    CURLOPT_SSL_CTX_FUNCTION,
    CURLOPT_SSL_CTX_DATA,
    CURLOPT_FTP_CREATE_MISSING_DIRS,
    CURLOPT_PROXYAUTH,
    CURLOPT_FTP_RESPONSE_TIMEOUT,
    CURLOPT_IPRESOLVE,
    CURLOPT_MAXFILESIZE,
    CURLOPT_INFILESIZE_LARGE,
    CURLOPT_RESUME_FROM_LARGE,
    CURLOPT_MAXFILESIZE_LARGE,
    CURLOPT_NETRC_FILE,
    CURLOPT_USE_SSL,
    CURLOPT_POSTFIELDSIZE_LARGE,
    CURLOPT_TCP_NODELAY,
    CURLOPT_FTPSSLAUTH,
    CURLOPT_IOCTLFUNCTION,
    CURLOPT_IOCTLDATA,
    CURLOPT_FTP_ACCOUNT,
    CURLOPT_COOKIELIST,
    CURLOPT_IGNORE_CONTENT_LENGTH,
    CURLOPT_FTP_SKIP_PASV_IP,
    CURLOPT_FTP_FILEMETHOD,
    CURLOPT_LOCALPORT,
    CURLOPT_LOCALPORTRANGE,
    CURLOPT_CONNECT_ONLY,
    CURLOPT_CONV_FROM_NETWORK_FUNCTION,
    CURLOPT_CONV_TO_NETWORK_FUNCTION,
    CURLOPT_CONV_FROM_UTF8_FUNCTION,
    CURLOPT_MAX_SEND_SPEED_LARGE,
    CURLOPT_MAX_RECV_SPEED_LARGE,
    CURLOPT_FTP_ALTERNATIVE_TO_USER,
    CURLOPT_SOCKOPTFUNCTION,
    CURLOPT_SOCKOPTDATA,
    CURLOPT_SSL_SESSIONID_CACHE,
    CURLOPT_SSH_AUTH_TYPES,
    CURLOPT_SSH_PUBLIC_KEYFILE,
    CURLOPT_SSH_PRIVATE_KEYFILE,
    CURLOPT_FTP_SSL_CCC,
    CURLOPT_TIMEOUT_MS,
    CURLOPT_CONNECTTIMEOUT_MS,
    CURLOPT_HTTP_TRANSFER_DECODING,
    CURLOPT_HTTP_CONTENT_DECODING,
    CURLOPT_NEW_FILE_PERMS,
    CURLOPT_NEW_DIRECTORY_PERMS,
    CURLOPT_POSTREDIR,
    CURLOPT_SSH_HOST_PUBLIC_KEY_MD5,
    CURLOPT_OPENSOCKETFUNCTION,
    CURLOPT_OPENSOCKETDATA,
    CURLOPT_COPYPOSTFIELDS,
    CURLOPT_PROXY_TRANSFER_MODE,
    CURLOPT_SEEKFUNCTION,
    CURLOPT_SEEKDATA,
    CURLOPT_CRLFILE,
    CURLOPT_ISSUERCERT,
    CURLOPT_ADDRESS_SCOPE,
    CURLOPT_CERTINFO,
    CURLOPT_USERNAME,
    CURLOPT_PASSWORD,
    CURLOPT_PROXYUSERNAME,
    CURLOPT_PROXYPASSWORD,
    CURLOPT_NOPROXY,
    CURLOPT_TFTP_BLKSIZE,
    CURLOPT_SOCKS5_GSSAPI_SERVICE,
    CURLOPT_SOCKS5_GSSAPI_NEC,
    CURLOPT_PROTOCOLS,
    CURLOPT_REDIR_PROTOCOLS,
    CURLOPT_SSH_KNOWNHOSTS,
    CURLOPT_SSH_KEYFUNCTION,
    CURLOPT_SSH_KEYDATA,
    CURLOPT_MAIL_FROM,
    CURLOPT_MAIL_RCPT,
    CURLOPT_FTP_USE_PRET,
    CURLOPT_RTSP_REQUEST,
    CURLOPT_RTSP_SESSION_ID,
    CURLOPT_RTSP_STREAM_URI,
    CURLOPT_RTSP_TRANSPORT,
    CURLOPT_RTSP_CLIENT_CSEQ,
    CURLOPT_RTSP_SERVER_CSEQ,
    CURLOPT_INTERLEAVEDATA,
    CURLOPT_INTERLEAVEFUNCTION,
    CURLOPT_WILDCARDMATCH,
    CURLOPT_CHUNK_BGN_FUNCTION,
    CURLOPT_CHUNK_END_FUNCTION,
    CURLOPT_FNMATCH_FUNCTION,
    CURLOPT_CHUNK_DATA,
    CURLOPT_FNMATCH_DATA,
    CURLOPT_RESOLVE,
    CURLOPT_TLSAUTH_USERNAME,
    CURLOPT_TLSAUTH_PASSWORD,
    CURLOPT_TLSAUTH_TYPE,
    CURLOPT_TRANSFER_ENCODING,
    CURLOPT_CLOSESOCKETFUNCTION,
    CURLOPT_CLOSESOCKETDATA,
    CURLOPT_GSSAPI_DELEGATION,
    CURLOPT_DNS_SERVERS,
    CURLOPT_TCP_KEEPALIVE,
    CURLOPT_TCP_KEEPIDLE,
    CURLOPT_TCP_KEEPINTVL,
    CURLOPT_SSL_OPTIONS,
    CURLOPT_EXPECT_100_TIMEOUT_MS,
    CURLOPT_PINNEDPUBLICKEY,
    CURLOPT_UNIX_SOCKET_PATH,
    CURLOPT_PATH_AS_IS,
    CURLOPT_PIPEWAIT,
    CURLOPT_CONNECT_TO,
    CURLOPT_PROXY_CAINFO,
    CURLOPT_PROXY_CAPATH,
    CURLOPT_PROXY_SSL_VERIFYPEER,
    CURLOPT_PROXY_SSL_VERIFYHOST,
    CURLOPT_PROXY_SSLVERSION,
    CURLOPT_PROXY_SSLCERT,
    CURLOPT_PROXY_SSLCERTTYPE,
    CURLOPT_PROXY_SSLKEY,
    CURLOPT_PROXY_SSLKEYTYPE,
    CURLOPT_PROXY_KEYPASSWD,
    CURLOPT_PROXY_SSL_CIPHER_LIST,
    CURLOPT_PROXY_CRLFILE,
    CURLOPT_PROXY_SSL_OPTIONS,
    CURLOPT_ABSTRACT_UNIX_SOCKET,
    CURLOPT_DOH_URL,
    CURLOPT_UPLOAD_BUFFERSIZE,
    CURLOPT_HTTP09_ALLOWED,
    CURLOPT_MAXAGE_CONN,
    CURLOPT_SSLCERT_BLOB,
    CURLOPT_SSLKEY_BLOB,
    CURLOPT_PROXY_SSLCERT_BLOB,
    CURLOPT_PROXY_SSLKEY_BLOB,
    CURLOPT_ISSUERCERT_BLOB,
    CURLOPT_PROXY_ISSUERCERT,
    CURLOPT_PROXY_ISSUERCERT_BLOB,
    CURLOPT_AWS_SIGV4,
    CURLOPT_DOH_SSL_VERIFYPEER,
    CURLOPT_DOH_SSL_VERIFYHOST,
    CURLOPT_DOH_SSL_VERIFYSTATUS,
    CURLOPT_CAINFO_BLOB,
    CURLOPT_PROXY_CAINFO_BLOB,
    CURLOPT_SSH_HOST_PUBLIC_KEY_SHA256,
    CURLOPT_PREREQ_FUNCTION,
    CURLOPT_PREREQ_DATA,
    CURLOPT_MAX_LIFETIME_CONN,
    CURLOPT_MIME_OPTIONS,
    CURLOPT_SSH_HOST_KEY_FUNCTION,
    CURLOPT_SSH_HOST_KEY_DATA,
    CURLOPT_PROTOCOLS_STR,
    CURLOPT_REDIR_PROTOCOLS_STR,
    CURLOPT_WS_OPTIONS,
    CURLOPT_CA_CACHE_TIMEOUT,
    CURLOPT_QUICK_EXIT,
    CURLOPT_HAPROXY_CLIENT_IP,
    CURLOPT_SERVER_RESPONSE_TIMEOUT_MS,
    CURLOPT_ECH,
    CURLOPT_TCP_KEEPCNT,
    CURLOPT_UPLOAD_FLAGS,
    CURLOPT_SSL_SIGNATURE_ALGORITHMS,
)


struct Option(TrivialRegisterPassable):
    """CURLoption values for setting options on CURL easy handles."""

    var value: c_int
    """Internal enum value."""

    comptime WRITE_DATA: Self = CURLOPT_FILE
    """The data pointer to pass to the write callback function."""
    comptime FILE: Self = CURLOPT_FILE
    """The data pointer to pass to the write callback function."""
    comptime URL: Self = CURLOPT_URL
    """The URL to fetch."""
    comptime PORT: Self = CURLOPT_PORT
    """The port number to connect to."""
    comptime PROXY: Self = CURLOPT_PROXY
    """The proxy to use for the request."""
    comptime USER_PWD: Self = CURLOPT_USERPWD
    """The user credentials for authentication."""
    comptime PROXY_USER_PWD: Self = CURLOPT_PROXYUSERPWD
    """The proxy user credentials for authentication."""
    comptime RANGE: Self = CURLOPT_RANGE
    """The range of data to fetch."""
    comptime IN_FILE: Self = CURLOPT_INFILE
    """The file to read data from."""
    comptime READ_DATA: Self = CURLOPT_INFILE
    """The data pointer to pass to the read callback function."""
    comptime ERROR_BUFFER: Self = CURLOPT_ERRORBUFFER
    """The buffer to store error messages."""
    comptime WRITE_FUNCTION: Self = CURLOPT_WRITEFUNCTION
    """The callback function for writing data."""
    comptime READ_FUNCTION: Self = CURLOPT_READFUNCTION
    """The callback function for reading data."""
    comptime TIMEOUT: Self = CURLOPT_TIMEOUT
    """The maximum time in seconds to allow the transfer to take."""
    comptime IN_FILE_SIZE: Self = CURLOPT_INFILESIZE
    """The size of the input file."""
    comptime POST_FIELDS: Self = CURLOPT_POSTFIELDS
    """The data to send in a POST request."""
    comptime REFERER: Self = CURLOPT_REFERER
    """The referer URL."""
    comptime FTP_PORT: Self = CURLOPT_FTPPORT
    """The port to use for FTP connections."""
    comptime USERAGENT: Self = CURLOPT_USERAGENT
    """The User-Agent string to send to the server."""
    comptime LOW_SPEED_LIMIT: Self = CURLOPT_LOW_SPEED_LIMIT
    """The transfer speed, in bytes per second, that the transfer should be below during the timeout period."""
    comptime LOW_SPEED_TIME: Self = CURLOPT_LOW_SPEED_TIME
    """The time, in seconds, that the transfer should be below the low speed limit before it is considered too slow."""
    comptime RESUME_FROM: Self = CURLOPT_RESUME_FROM
    """The point, in bytes, from which to resume the transfer."""
    comptime COOKIE: Self = CURLOPT_COOKIE
    """The cookie string to send to the server."""
    comptime HTTP_HEADER: Self = CURLOPT_HTTPHEADER
    """The custom HTTP headers to send to the server."""
    comptime SSL_CERT: Self = CURLOPT_SSLCERT
    """The SSL certificate to use for the connection."""
    comptime KEY_PASSWD: Self = CURLOPT_KEYPASSWD
    """The password for the SSL key."""
    comptime CRLF: Self = CURLOPT_CRLF
    """Whether to convert LF to CRLF in the request."""
    comptime QUOTE: Self = CURLOPT_QUOTE
    """The FTP commands to send after the transfer is complete."""
    comptime WRITE_HEADER: Self = CURLOPT_WRITEHEADER
    """The callback function for writing header data."""
    comptime COOKIE_FILE: Self = CURLOPT_COOKIEFILE
    """The file to read cookies from."""
    comptime SSL_VERSION: Self = CURLOPT_SSLVERSION
    """The SSL version to use."""
    comptime TIME_CONDITION: Self = CURLOPT_TIMECONDITION
    """The time condition for the request."""
    comptime TIME_VALUE: Self = CURLOPT_TIMEVALUE
    """The time value for the request."""
    comptime CUSTOM_REQUEST: Self = CURLOPT_CUSTOMREQUEST
    """The custom request method to use."""
    comptime STDERR: Self = CURLOPT_STDERR
    """The file to write error messages to."""
    comptime POST_QUOTE: Self = CURLOPT_POSTQUOTE
    """The FTP commands to send after a POST request."""
    comptime VERBOSE: Self = CURLOPT_VERBOSE
    """Whether to enable verbose output."""
    comptime HEADER: Self = CURLOPT_HEADER
    """Whether to include the header in the output."""
    comptime NO_PROGRESS: Self = CURLOPT_NOPROGRESS
    """Whether to disable the progress meter."""
    comptime NO_BODY: Self = CURLOPT_NOBODY
    """Whether to exclude the body from the output."""
    comptime FAIL_ON_ERROR: Self = CURLOPT_FAILONERROR
    """Whether to fail on HTTP errors."""
    comptime UPLOAD: Self = CURLOPT_UPLOAD
    """Whether to enable uploading."""
    comptime POST: Self = CURLOPT_POST
    """Whether to enable POST requests."""
    comptime DIR_LIST_ONLY: Self = CURLOPT_DIRLISTONLY
    """Whether to list only directories."""
    comptime APPEND: Self = CURLOPT_APPEND
    """Whether to append to the output file."""
    comptime NETRC: Self = CURLOPT_NETRC
    """Whether to use .netrc file for authentication."""
    comptime FOLLOW_LOCATION: Self = CURLOPT_FOLLOWLOCATION
    """Whether to follow redirects."""
    comptime TRANSFER_TEXT: Self = CURLOPT_TRANSFERTEXT
    """Whether to transfer data as text."""
    comptime PROGRESS_FUNCTION: Self = CURLOPT_PROGRESSFUNCTION
    """The callback function for progress updates."""
    comptime PROGRESS_DATA: Self = CURLOPT_PROGRESSDATA
    """The data to pass to the progress callback."""
    comptime AUTO_REFERER: Self = CURLOPT_AUTOREFERER
    """Whether to automatically set the Referer header."""
    comptime PROXY_PORT: Self = CURLOPT_PROXYPORT
    """The port number of the proxy server."""
    comptime POST_FIELD_SIZE: Self = CURLOPT_POSTFIELDSIZE
    """The size of the POST data."""
    comptime HTTP_PROXY_TUNNEL: Self = CURLOPT_HTTPPROXYTUNNEL
    """Whether to tunnel through the HTTP proxy."""
    comptime INTERFACE: Self = CURLOPT_INTERFACE
    """The network interface to use."""
    comptime KRB_LEVEL: Self = CURLOPT_KRBLEVEL
    """The Kerberos authentication level."""
    comptime SSL_VERIFYPEER: Self = CURLOPT_SSL_VERIFYPEER
    """Whether to verify the peer's SSL certificate."""
    comptime CAINFO: Self = CURLOPT_CAINFO
    """The file containing the CA certificates."""
    comptime MAXREDIRS: Self = CURLOPT_MAXREDIRS
    """The maximum number of redirects to follow."""
    comptime FILE_TIME: Self = CURLOPT_FILETIME
    """Whether to attempt to retrieve the modification time of the remote document."""
    comptime TELNET_OPTIONS: Self = CURLOPT_TELNETOPTIONS
    """The options for the Telnet protocol."""
    comptime MAX_CONNECTS: Self = CURLOPT_MAXCONNECTS
    """The maximum number of simultaneous connections."""
    comptime FRESH_CONNECT: Self = CURLOPT_FRESH_CONNECT
    """Whether to use a new connection."""
    comptime FORBID_REUSE: Self = CURLOPT_FORBID_REUSE
    """Whether to forbid reusing connections."""
    comptime RANDOM_FILE: Self = CURLOPT_RANDOM_FILE
    """The file containing random data for SSL."""
    comptime EGD_SOCKET: Self = CURLOPT_EGDSOCKET
    """The path to the EGD socket."""
    comptime CONNECT_TIMEOUT: Self = CURLOPT_CONNECTTIMEOUT
    """The maximum time in seconds that you allow the connection to the server to take."""
    comptime HEADER_FUNCTION: Self = CURLOPT_HEADERFUNCTION
    """The callback function for writing header data."""
    comptime HTTPGET: Self = CURLOPT_HTTPGET
    """Whether to use HTTP GET."""
    comptime SSL_VERIFY_HOST: Self = CURLOPT_SSL_VERIFYHOST
    """Whether to verify the SSL host."""
    comptime COOKIEJAR: Self = CURLOPT_COOKIEJAR
    """The file to write cookies to."""
    comptime SSL_CIPHER_LIST: Self = CURLOPT_SSL_CIPHER_LIST
    """The list of SSL ciphers to use."""
    comptime HTTP_VERSION: Self = CURLOPT_HTTP_VERSION
    """The HTTP version to use."""
    comptime FTP_USE_EPSV: Self = CURLOPT_FTP_USE_EPSV
    """Whether to use EPSV for FTP."""
    comptime SSL_CERT_TYPE: Self = CURLOPT_SSLCERTTYPE
    """The type of the SSL certificate."""
    comptime SSL_KEY: Self = CURLOPT_SSLKEY
    """The file containing the SSL key."""
    comptime SSL_KEY_TYPE: Self = CURLOPT_SSLKEYTYPE
    """The type of the SSL key."""
    comptime SSL_ENGINE: Self = CURLOPT_SSLENGINE
    """The SSL engine to use."""
    comptime SSL_ENGINE_DEFAULT: Self = CURLOPT_SSLENGINE_DEFAULT
    """The SSL engine to use as default."""
    comptime DNS_USE_GLOBAL_CACHE: Self = CURLOPT_DNS_USE_GLOBAL_CACHE
    """Whether to use the global DNS cache."""
    comptime DNS_CACHE_TIMEOUT: Self = CURLOPT_DNS_CACHE_TIMEOUT
    """The timeout for the DNS cache in seconds."""
    comptime PREQUOTE: Self = CURLOPT_PREQUOTE
    """The FTP commands to send before the transfer."""
    comptime DEBUG_FUNCTION: Self = CURLOPT_DEBUGFUNCTION
    """The callback function for debug messages."""
    comptime DEBUG_DATA: Self = CURLOPT_DEBUGDATA
    """The data to pass to the debug callback."""
    comptime COOKIE_SESSION: Self = CURLOPT_COOKIESESSION
    """Whether to start a new cookie session."""
    comptime CAPATH: Self = CURLOPT_CAPATH
    """The directory containing CA certificates."""
    comptime BUFFER_SIZE: Self = CURLOPT_BUFFERSIZE
    """The buffer size for network I/O."""
    comptime NO_SIGNAL: Self = CURLOPT_NOSIGNAL
    """Whether to disable signal handling."""
    comptime SHARE: Self = CURLOPT_SHARE
    """The share handle for sharing data."""
    comptime PROXY_TYPE: Self = CURLOPT_PROXYTYPE
    """The proxy type to use."""
    comptime ACCEPT_ENCODING: Self = CURLOPT_ACCEPT_ENCODING
    """The Accept-Encoding header to send."""
    comptime PRIVATE: Self = CURLOPT_PRIVATE
    """A private pointer for the user."""
    comptime HTTP200_ALIASES: Self = CURLOPT_HTTP200ALIASES
    """The list of HTTP 200 response codes to treat as success."""
    comptime UNRESTRICTED_AUTH: Self = CURLOPT_UNRESTRICTED_AUTH
    """Whether to allow unrestricted authentication."""
    comptime FTP_USE_EPRT: Self = CURLOPT_FTP_USE_EPRT
    """Whether to use EPRT for FTP."""
    comptime HTTP_AUTH: Self = CURLOPT_HTTPAUTH
    """The HTTP authentication method to use."""
    comptime SSL_CTX_FUNCTION: Self = CURLOPT_SSL_CTX_FUNCTION
    """The callback function for SSL context."""
    comptime SSL_CTX_DATA: Self = CURLOPT_SSL_CTX_DATA
    """The data to pass to the SSL context callback."""
    comptime FTP_CREATE_MISSING_DIRS: Self = CURLOPT_FTP_CREATE_MISSING_DIRS
    """Whether to create missing directories during FTP upload."""
    comptime PROXY_AUTH: Self = CURLOPT_PROXYAUTH
    """The proxy authentication method to use."""
    comptime FTP_RESPONSE_TIMEOUT: Self = CURLOPT_FTP_RESPONSE_TIMEOUT
    """The timeout for FTP response in seconds."""
    comptime IP_RESOLVE: Self = CURLOPT_IPRESOLVE
    """The IP address resolution strategy."""
    comptime MAX_FILE_SIZE: Self = CURLOPT_MAXFILESIZE
    """The maximum file size to download."""
    comptime IN_FILE_SIZE_LARGE: Self = CURLOPT_INFILESIZE_LARGE
    """The size of the input file (large)."""
    comptime RESUME_FROM_LARGE: Self = CURLOPT_RESUME_FROM_LARGE
    """The point to resume from (large)."""
    comptime MAX_FILE_SIZE_LARGE: Self = CURLOPT_MAXFILESIZE_LARGE
    """The maximum file size to download (large)."""
    comptime NETRC_FILE: Self = CURLOPT_NETRC_FILE
    """The netrc file to use for authentication."""
    comptime USE_SSL: Self = CURLOPT_USE_SSL
    """Whether to use SSL/TLS."""
    comptime POST_FIELD_SIZE_LARGE: Self = CURLOPT_POSTFIELDSIZE_LARGE
    """The size of the POST data (large)."""
    comptime TCP_NODELAY: Self = CURLOPT_TCP_NODELAY
    """Whether to enable TCP_NODELAY."""
    comptime FTP_SSL_AUTH: Self = CURLOPT_FTPSSLAUTH
    """The FTP SSL authentication method."""
    comptime IOCTL_FUNCTION: Self = CURLOPT_IOCTLFUNCTION
    """The callback function for ioctl."""
    comptime IOCTL_DATA: Self = CURLOPT_IOCTLDATA
    """The data to pass to the ioctl callback."""
    comptime FTP_ACCOUNT: Self = CURLOPT_FTP_ACCOUNT
    """The FTP account information."""
    comptime COOKIE_LIST: Self = CURLOPT_COOKIELIST
    """The list of cookies to set or manipulate."""
    comptime IGNORE_CONTENT_LENGTH: Self = CURLOPT_IGNORE_CONTENT_LENGTH
    """Whether to ignore the Content-Length header."""
    comptime FTP_SKIP_PASV_IP: Self = CURLOPT_FTP_SKIP_PASV_IP
    """Whether to skip the IP address in PASV response."""
    comptime FTP_FILE_METHOD: Self = CURLOPT_FTP_FILEMETHOD
    """The FTP file method to use."""
    comptime LOCAL_PORT: Self = CURLOPT_LOCALPORT
    """The local port to bind to."""
    comptime LOCAL_PORT_RANGE: Self = CURLOPT_LOCALPORTRANGE
    """The range of local ports to bind to."""
    comptime CONNECT_ONLY: Self = CURLOPT_CONNECT_ONLY
    """Whether to connect only without transferring data."""
    comptime CONV_FROM_NETWORK_FUNCTION: Self = CURLOPT_CONV_FROM_NETWORK_FUNCTION
    """The callback function for character conversion from network."""
    comptime CONV_TO_NETWORK_FUNCTION: Self = CURLOPT_CONV_TO_NETWORK_FUNCTION
    """The callback function for character conversion to network."""
    comptime CONV_FROM_UTF8_FUNCTION: Self = CURLOPT_CONV_FROM_UTF8_FUNCTION
    """The callback function for character conversion from UTF-8."""
    comptime MAX_SEND_SPEED_LARGE: Self = CURLOPT_MAX_SEND_SPEED_LARGE
    """The maximum send speed in bytes per second (large)."""
    comptime MAX_RECV_SPEED_LARGE: Self = CURLOPT_MAX_RECV_SPEED_LARGE
    """The maximum receive speed in bytes per second (large)."""
    comptime FTP_ALTERNATIVE_TO_USER: Self = CURLOPT_FTP_ALTERNATIVE_TO_USER
    """The alternative to the USER command for FTP."""
    comptime SOCKOPT_FUNCTION: Self = CURLOPT_SOCKOPTFUNCTION
    """The callback function for socket options."""
    comptime SOCKOPT_DATA: Self = CURLOPT_SOCKOPTDATA
    """The data to pass to the socket options callback."""
    comptime SSL_SESSIONID_CACHE: Self = CURLOPT_SSL_SESSIONID_CACHE
    """Whether to use the SSL session ID cache."""
    comptime SSH_AUTH_TYPES: Self = CURLOPT_SSH_AUTH_TYPES
    """The SSH authentication types to use."""
    comptime SSH_PUBLIC_KEYFILE: Self = CURLOPT_SSH_PUBLIC_KEYFILE
    """The SSH public key file."""
    comptime SSH_PRIVATE_KEYFILE: Self = CURLOPT_SSH_PRIVATE_KEYFILE
    """The SSH private key file."""
    comptime FTP_SSL_CCC: Self = CURLOPT_FTP_SSL_CCC
    """The FTP SSL CCC mode."""
    comptime TIMEOUT_MS: Self = CURLOPT_TIMEOUT_MS
    """The timeout in milliseconds."""
    comptime CONNECT_TIMEOUT_MS: Self = CURLOPT_CONNECTTIMEOUT_MS
    """The connection timeout in milliseconds."""
    comptime HTTP_TRANSFER_DECODING: Self = CURLOPT_HTTP_TRANSFER_DECODING
    """Whether to automatically decode HTTP transfer encoding."""
    comptime HTTP_CONTENT_DECODING: Self = CURLOPT_HTTP_CONTENT_DECODING
    """Whether to automatically decode HTTP content encoding."""
    comptime NEW_FILE_PERMS: Self = CURLOPT_NEW_FILE_PERMS
    """The permissions for newly created files."""
    comptime NEW_DIRECTORY_PERMS: Self = CURLOPT_NEW_DIRECTORY_PERMS
    """The permissions for newly created directories."""
    comptime POST_REDIR: Self = CURLOPT_POSTREDIR
    """The redirection behavior for POST requests."""
    comptime SSH_HOST_PUBLIC_KEY_MD5: Self = CURLOPT_SSH_HOST_PUBLIC_KEY_MD5
    """The MD5 hash of the SSH host public key."""
    comptime OPEN_SOCKET_FUNCTION: Self = CURLOPT_OPENSOCKETFUNCTION
    """The callback function for opening a socket."""
    comptime OPEN_SOCKET_DATA: Self = CURLOPT_OPENSOCKETDATA
    """The data to pass to the open socket callback."""
    comptime COPY_POST_FIELDS: Self = CURLOPT_COPYPOSTFIELDS
    """The POST fields to send (copied)."""
    comptime PROXY_TRANSFER_MODE: Self = CURLOPT_PROXY_TRANSFER_MODE
    """Whether to use FTP transfer mode through proxy."""
    comptime SEEK_FUNCTION: Self = CURLOPT_SEEKFUNCTION
    """The callback function for seeking in the input."""
    comptime SEEK_DATA: Self = CURLOPT_SEEKDATA
    """The data to pass to the seek callback."""
    comptime CRL_FILE: Self = CURLOPT_CRLFILE
    """The file containing CRL (Certificate Revocation List)."""
    comptime ISSUER_CERT: Self = CURLOPT_ISSUERCERT
    """The issuer certificate file."""
    comptime ADDRESS_SCOPE: Self = CURLOPT_ADDRESS_SCOPE
    """The address scope for IPv6 connections."""
    comptime CERT_INFO: Self = CURLOPT_CERTINFO
    """Whether to get certificate chain information."""
    comptime USERNAME: Self = CURLOPT_USERNAME
    """The username for authentication."""
    comptime PASSWORD: Self = CURLOPT_PASSWORD
    """The password for authentication."""
    comptime PROXY_USERNAME: Self = CURLOPT_PROXYUSERNAME
    """The username for proxy authentication."""
    comptime PROXY_PASSWORD: Self = CURLOPT_PROXYPASSWORD
    """The password for proxy authentication."""
    comptime NO_PROXY: Self = CURLOPT_NOPROXY
    """The list of hosts that should not use a proxy."""
    comptime TFTP_BLK_SIZE: Self = CURLOPT_TFTP_BLKSIZE
    """The block size for TFTP."""
    comptime SOCKS5_GSSAPI_SERVICE: Self = CURLOPT_SOCKS5_GSSAPI_SERVICE
    """The SOCKS5 GSSAPI service name."""
    comptime SOCKS5_GSSAPI_NEC: Self = CURLOPT_SOCKS5_GSSAPI_NEC
    """Whether to use SOCKS5 GSSAPI NEC mode."""
    comptime PROTOCOLS: Self = CURLOPT_PROTOCOLS
    """The allowed protocols."""
    comptime REDIR_PROTOCOLS: Self = CURLOPT_REDIR_PROTOCOLS
    """The allowed protocols for redirects."""
    comptime SSH_KNOWNHOSTS: Self = CURLOPT_SSH_KNOWNHOSTS
    """The SSH known hosts file."""
    comptime SSH_KEY_FUNCTION: Self = CURLOPT_SSH_KEYFUNCTION
    """The callback function for SSH key handling."""
    comptime SSH_KEY_DATA: Self = CURLOPT_SSH_KEYDATA
    """The data to pass to the SSH key callback."""
    comptime MAIL_FROM: Self = CURLOPT_MAIL_FROM
    """The email address to send from."""
    comptime MAIL_RCPT: Self = CURLOPT_MAIL_RCPT
    """The email recipient address."""
    comptime FTP_USE_PRET: Self = CURLOPT_FTP_USE_PRET
    """Whether to use PRET for FTP."""
    comptime RTSP_REQUEST: Self = CURLOPT_RTSP_REQUEST
    """The RTSP request method."""
    comptime RTSP_SESSION_ID: Self = CURLOPT_RTSP_SESSION_ID
    """The RTSP session ID."""
    comptime RTSP_STREAM_URI: Self = CURLOPT_RTSP_STREAM_URI
    """The RTSP stream URI."""
    comptime RTSP_TRANSPORT: Self = CURLOPT_RTSP_TRANSPORT
    """The RTSP transport."""
    comptime RTSP_CLIENT_CSEQ: Self = CURLOPT_RTSP_CLIENT_CSEQ
    """The RTSP client sequence number."""
    comptime RTSP_SERVER_CSEQ: Self = CURLOPT_RTSP_SERVER_CSEQ
    """The RTSP server sequence number."""
    comptime INTERLEAVE_DATA: Self = CURLOPT_INTERLEAVEDATA
    """The data to pass to the interleave callback."""
    comptime INTERLEAVE_FUNCTION: Self = CURLOPT_INTERLEAVEFUNCTION
    """The callback function for interleaved data."""
    comptime WILDCARD_MATCH: Self = CURLOPT_WILDCARDMATCH
    """Whether to enable wildcard matching."""
    comptime CHUNK_BGN_FUNCTION: Self = CURLOPT_CHUNK_BGN_FUNCTION
    """The callback function at the beginning of a chunk."""
    comptime CHUNK_END_FUNCTION: Self = CURLOPT_CHUNK_END_FUNCTION
    """The callback function at the end of a chunk."""
    comptime FN_MATCH_FUNCTION: Self = CURLOPT_FNMATCH_FUNCTION
    """The callback function for filename matching."""
    comptime CHUNK_DATA: Self = CURLOPT_CHUNK_DATA
    """The data to pass to the chunk callbacks."""
    comptime FN_MATCH_DATA: Self = CURLOPT_FNMATCH_DATA
    """The data to pass to the filename match callback."""
    comptime RESOLVE: Self = CURLOPT_RESOLVE
    """The list of host/IP pairs to resolve."""
    comptime TLS_AUTH_USERNAME: Self = CURLOPT_TLSAUTH_USERNAME
    """The username for TLS authentication."""
    comptime TLS_AUTH_PASSWORD: Self = CURLOPT_TLSAUTH_PASSWORD
    """The password for TLS authentication."""
    comptime TLS_AUTH_TYPE: Self = CURLOPT_TLSAUTH_TYPE
    """The TLS authentication type."""
    comptime TRANSFER_ENCODING: Self = CURLOPT_TRANSFER_ENCODING
    """Whether to enable transfer encoding."""
    comptime CLOSE_SOCKET_FUNCTION: Self = CURLOPT_CLOSESOCKETFUNCTION
    """The callback function for closing a socket."""
    comptime CLOSE_SOCKET_DATA: Self = CURLOPT_CLOSESOCKETDATA
    """The data to pass to the close socket callback."""
    comptime GSSAPI_DELEGATION: Self = CURLOPT_GSSAPI_DELEGATION
    """The GSSAPI delegation level."""
    comptime DNS_SERVERS: Self = CURLOPT_DNS_SERVERS
    """The list of DNS servers to use."""
    comptime TCP_KEEPALIVE: Self = CURLOPT_TCP_KEEPALIVE
    """Whether to enable TCP keep-alive."""
    comptime TCP_KEEPIDLE: Self = CURLOPT_TCP_KEEPIDLE
    """The TCP keep-alive idle timeout in seconds."""
    comptime TCP_KEEPINTVL: Self = CURLOPT_TCP_KEEPINTVL
    """The TCP keep-alive interval in seconds."""
    comptime SSL_OPTIONS: Self = CURLOPT_SSL_OPTIONS
    """The SSL options."""
    comptime EXPECT_100_TIMEOUT_MS: Self = CURLOPT_EXPECT_100_TIMEOUT_MS
    """The timeout for Expect: 100-continue in milliseconds."""
    comptime PINNED_PUBLIC_KEY: Self = CURLOPT_PINNEDPUBLICKEY
    """The pinned public key."""
    comptime UNIX_SOCKET_PATH: Self = CURLOPT_UNIX_SOCKET_PATH
    """The path to the Unix domain socket."""
    comptime PATH_AS_IS: Self = CURLOPT_PATH_AS_IS
    """Whether to disable path normalization."""
    comptime PIPE_WAIT: Self = CURLOPT_PIPEWAIT
    """Whether to wait for pipe connection."""
    comptime CONNECT_TO: Self = CURLOPT_CONNECT_TO
    """The list of host substitutions for connection."""
    comptime PROXY_CAINFO: Self = CURLOPT_PROXY_CAINFO
    """The file containing the proxy CA certificates."""
    comptime PROXY_CAPATH: Self = CURLOPT_PROXY_CAPATH
    """The directory containing proxy CA certificates."""
    comptime PROXY_SSL_VERIFYPEER: Self = CURLOPT_PROXY_SSL_VERIFYPEER
    """Whether to verify the proxy's SSL certificate."""
    comptime PROXY_SSL_VERIFYHOST: Self = CURLOPT_PROXY_SSL_VERIFYHOST
    """Whether to verify the proxy SSL host."""
    comptime PROXY_SSL_VERSION: Self = CURLOPT_PROXY_SSLVERSION
    """The SSL version to use for proxy."""
    comptime PROXY_SSL_CERT: Self = CURLOPT_PROXY_SSLCERT
    """The SSL certificate to use for proxy."""
    comptime PROXY_SSL_CERT_TYPE: Self = CURLOPT_PROXY_SSLCERTTYPE
    """The type of the proxy SSL certificate."""
    comptime PROXY_SSL_KEY: Self = CURLOPT_PROXY_SSLKEY
    """The file containing the proxy SSL key."""
    comptime PROXY_SSL_KEY_TYPE: Self = CURLOPT_PROXY_SSLKEYTYPE
    """The type of the proxy SSL key."""
    comptime PROXY_KEYPASSWD: Self = CURLOPT_PROXY_KEYPASSWD
    """The password for the proxy SSL key."""
    comptime PROXY_SSL_CIPHER_LIST: Self = CURLOPT_PROXY_SSL_CIPHER_LIST
    """The list of SSL ciphers to use for proxy."""
    comptime PROXY_CRL_FILE: Self = CURLOPT_PROXY_CRLFILE
    """The file containing proxy CRL (Certificate Revocation List)."""
    comptime PROXY_SSL_OPTIONS: Self = CURLOPT_PROXY_SSL_OPTIONS
    """The SSL options for proxy."""
    comptime ABSTRACT_UNIX_SOCKET: Self = CURLOPT_ABSTRACT_UNIX_SOCKET
    """The abstract Unix domain socket path."""
    comptime DOH_URL: Self = CURLOPT_DOH_URL
    """The DNS over HTTPS URL."""
    comptime UPLOAD_BUFFER_SIZE: Self = CURLOPT_UPLOAD_BUFFERSIZE
    """The upload buffer size."""
    comptime HTTP09_ALLOWED: Self = CURLOPT_HTTP09_ALLOWED
    """Whether to allow HTTP/0.9."""
    comptime MAX_AGE_CONN: Self = CURLOPT_MAXAGE_CONN
    """The maximum age of a connection to reuse."""
    comptime SSL_CERT_BLOB: Self = CURLOPT_SSLCERT_BLOB
    """The SSL certificate as a blob."""
    comptime SSL_KEY_BLOB: Self = CURLOPT_SSLKEY_BLOB
    """The SSL key as a blob."""
    comptime PROXY_SSL_CERT_BLOB: Self = CURLOPT_PROXY_SSLCERT_BLOB
    """The proxy SSL certificate as a blob."""
    comptime PROXY_SSL_KEY_BLOB: Self = CURLOPT_PROXY_SSLKEY_BLOB
    """The proxy SSL key as a blob."""
    comptime ISSUER_CERT_BLOB: Self = CURLOPT_ISSUERCERT_BLOB
    """The issuer certificate as a blob."""
    comptime PROXY_ISSUER_CERT: Self = CURLOPT_PROXY_ISSUERCERT
    """The proxy issuer certificate."""
    comptime PROXY_ISSUER_CERT_BLOB: Self = CURLOPT_PROXY_ISSUERCERT_BLOB
    """The proxy issuer certificate as a blob."""
    comptime AWS_SIGV4: Self = CURLOPT_AWS_SIGV4
    """The AWS Signature Version 4 parameters."""
    comptime DOH_SSL_VERIFY_PEER: Self = CURLOPT_DOH_SSL_VERIFYPEER
    """Whether to verify the DNS over HTTPS SSL certificate."""
    comptime DOH_SSL_VERIFY_HOST: Self = CURLOPT_DOH_SSL_VERIFYHOST
    """Whether to verify the DNS over HTTPS SSL host."""
    comptime DOH_SSL_VERIFY_STATUS: Self = CURLOPT_DOH_SSL_VERIFYSTATUS
    """Whether to verify the DNS over HTTPS certificate status."""
    comptime CAINFO_BLOB: Self = CURLOPT_CAINFO_BLOB
    """The CA certificates as a blob."""
    comptime PROXY_CAINFO_BLOB: Self = CURLOPT_PROXY_CAINFO_BLOB
    """The proxy CA certificates as a blob."""
    comptime SSH_HOST_PUBLIC_KEY_SHA256: Self = CURLOPT_SSH_HOST_PUBLIC_KEY_SHA256
    """The SHA256 hash of the SSH host public key."""
    comptime PREREQ_FUNCTION: Self = CURLOPT_PREREQ_FUNCTION
    """The callback function for pre-request processing."""
    comptime PREREQ_DATA: Self = CURLOPT_PREREQ_DATA
    """The data to pass to the pre-request callback."""
    comptime MAX_LIFETIME_CONN: Self = CURLOPT_MAX_LIFETIME_CONN
    """The maximum lifetime of a connection in milliseconds."""
    comptime MIME_OPTIONS: Self = CURLOPT_MIME_OPTIONS
    """The MIME options."""
    comptime SSH_HOST_KEY_FUNCTION: Self = CURLOPT_SSH_HOST_KEY_FUNCTION
    """The callback function for SSH host key verification."""
    comptime SSH_HOST_KEY_DATA: Self = CURLOPT_SSH_HOST_KEY_DATA
    """The data to pass to the SSH host key callback."""
    comptime PROTOCOLS_STR: Self = CURLOPT_PROTOCOLS_STR
    """The allowed protocols as a string."""
    comptime REDIR_PROTOCOLS_STR: Self = CURLOPT_REDIR_PROTOCOLS_STR
    """The allowed redirect protocols as a string."""
    comptime WS_OPTIONS: Self = CURLOPT_WS_OPTIONS
    """The WebSocket options."""
    comptime CA_CACHE_TIMEOUT: Self = CURLOPT_CA_CACHE_TIMEOUT
    """The CA certificate cache timeout in seconds."""
    comptime QUICK_EXIT: Self = CURLOPT_QUICK_EXIT
    """Whether to perform a quick exit."""
    comptime HAPROXY_CLIENT_IP: Self = CURLOPT_HAPROXY_CLIENT_IP
    """The client IP to send to HAProxy."""
    comptime SERVER_RESPONSE_TIMEOUT_MS: Self = CURLOPT_SERVER_RESPONSE_TIMEOUT_MS
    """The server response timeout in milliseconds."""
    comptime ECH: Self = CURLOPT_ECH
    """The Encrypted Client Hello settings."""
    comptime TCP_KEEPCNT: Self = CURLOPT_TCP_KEEPCNT
    """The TCP keep-alive probe count."""
    comptime UPLOAD_FLAGS: Self = CURLOPT_UPLOAD_FLAGS
    """The upload flags."""
    comptime SSL_SIGNATURE_ALGORITHMS: Self = CURLOPT_SSL_SIGNATURE_ALGORITHMS
    """The SSL signature algorithms."""

    @implicit
    def __init__(out self, value: Int):
        """Initialize an Option with an integer value.

        Args:
            value: The integer value corresponding to a CURLoption.
        """
        self.value = c_int(value)

    @implicit
    def __init__(out self, value: c_int):
        """Initialize an Option with a c_int value.

        Args:
            value: The c_int value corresponding to a CURLoption.
        """
        self.value = value
