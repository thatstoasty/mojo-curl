# import os
# from pathlib import Path
# import pathlib
# from sys import ffi, CompilationTarget
# from sys.ffi import DLHandle, c_char, c_int, c_uint, c_size_t, c_long
# from sys.param_env import env_get_string

# from curl.c.curl import CURL, CURLcode, CURLOPT, CURLINFO

# from memory import OpaquePointer, UnsafePointer


# @fieldwise_init
# struct curl(Copyable, Movable):
#     """CURL Easy interface C API binding struct.

#     This struct provides a comprehensive interface to the libcurl Easy API
#     by dynamically loading the shared library and exposing the C functions
#     as Mojo methods. It handles the FFI (Foreign Function Interface) calls
#     to the underlying libcurl C implementation.

#     The Easy interface is the synchronous, blocking interface to libcurl
#     that allows you to perform one transfer at a time.
#     """

#     var lib: DLHandle

#     fn __init__(out self):
#         """Initialize the curl binding by loading the libcurl shared library.
        
#         This constructor attempts to load libcurl from common system locations.
#         It will search for the library in standard paths and raise an error
#         if libcurl cannot be found.
#         """
#         var path = String(env_get_string["LIBCURL_LIB_PATH", ""]())

#         # If the program was not compiled with a specific path, then check if it was set via environment variable.
#         if path == "":
#             path = os.getenv("LIBCURL_LIB_PATH")

#         try:
#             # If its not explicitly set, then assume the program is running from the root of the project.
#             if path == "":
#                 if CompilationTarget.is_macos():
#                     path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.dylib")
#                 else:
#                     path = String(pathlib.cwd() / ".pixi/envs/default/lib/libcurl.so")

#             if not pathlib.Path(path).exists():
#                 os.abort(
#                     "The path to the libcurl library is not set. Set the path as either a compilation variable with `-D"
#                     " LIBCURL_LIB_PATH=/path/to/libcurl.dylib/so` or environment variable with"
#                     " `TLSE_LIB_PATH=/path/to/libtlse.dylib/so`. Please set the TLSE_LIB_PATH environment variable to the"
#                     " path of the TLSE library. The default path is `.pixi/envs/default/lib/libtlse.dylib/so`, but this"
#                     " error indicates that the dylib/so did not exist at that location."
#                 )
#             self.lib = ffi.DLHandle(path, ffi.RTLD.LAZY)
#         except e:
#             self.lib = os.abort[ffi.DLHandle](String("Failed to load the TLSE library: ", e))

#     # Global libcurl functions
#     fn curl_global_init(self, flags: c_long) -> CURLcode:
#         """Global libcurl initialization.
        
#         This function sets up the program environment that libcurl needs.
#         This function must be called at least once within a program (a program is all the code that shares a memory space) before the program calls any other function in libcurl.
        
#         Args:
#             flags: Initialization flags (e.g., CURL_GLOBAL_DEFAULT).
        
#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (c_long) -> CURLcode]("curl_global_init")(flags)

#     fn curl_global_cleanup(self) -> NoneType:
#         """Global libcurl cleanup.
        
#         This function releases resources acquired by curl_global_init().
#         You should call curl_global_cleanup() once per program when you're done using libcurl.
#         """
#         return self.lib.get_function[fn () -> NoneType]("curl_global_cleanup")()

#     fn curl_version(self) -> UnsafePointer[c_char]:
#         """Return the version string of libcurl.
        
#         Returns:
#             A pointer to a null-terminated string containing the version.
#         """
#         return self.lib.get_function[fn () -> UnsafePointer[c_char]]("curl_version")()

#     fn curl_version_info(self, type: c_int) -> UnsafePointer[curl_version_info_data]:
#         """Return detailed version information about libcurl.
        
#         Args:
#             type: The version info type (usually CURLVERSION_NOW).
            
#         Returns:
#             A pointer to a curl_version_info_data structure.
#         """
#         return self.lib.get_function[fn (c_int) -> UnsafePointer[curl_version_info_data]]("curl_version_info")(type)

#     # Easy interface functions
#     fn curl_easy_init(self) -> CURL:
#         """Start a libcurl easy session.
        
#         This function allocates and returns a CURL easy handle that you must use
#         as input to other functions in the easy interface. This call MUST have
#         a corresponding call to curl_easy_cleanup() when the operation is complete.
        
#         Returns:
#             A CURL handle on success, or NULL on error.
#         """
#         return self.lib.get_function[fn () -> CURL]("curl_easy_init")()

#     fn curl_easy_setopt(self, curl: CURL, option: CURLoption, parameter: OpaquePointer) -> CURLcode:
#         """Set options for a curl easy handle.
        
#         This function is used to tell libcurl how to behave. By setting the
#         appropriate options, the application can change libcurl's behavior.
#         All options are set with an option followed by a parameter.
        
#         Args:
#             curl: The CURL handle to set options for.
#             option: The option to set (e.g., CURLOPT_URL, CURLOPT_WRITEFUNCTION).
#             parameter: The value/pointer for the option.

#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL, CURLoption, OpaquePointer) -> CURLcode]("curl_easy_setopt")(
#             curl, option, parameter
#         )

#     fn curl_easy_setopt_string(self, curl: CURL, option: CURLoption, parameter: UnsafePointer[c_char, mut=False]) -> CURLcode:
#         """Set a string option for a curl easy handle.
        
#         Convenience method for setting string options without manual casting.
        
#         Args:
#             curl: The CURL handle to set options for.
#             option: The string option to set.
#             parameter: The string value for the option.
            
#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL, CURLoption, UnsafePointer[c_char, mut=False]) -> CURLcode]("curl_easy_setopt")(
#             curl, option, parameter
#         )

#     fn curl_easy_setopt_long(self, curl: CURL, option: CURLoption, parameter: c_long) -> CURLcode:
#         """Set a long/integer option for a curl easy handle.
        
#         Convenience method for setting integer options.
        
#         Args:
#             curl: The CURL handle to set options for.
#             option: The integer option to set.
#             parameter: The integer value for the option.
            
#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL, CURLoption, c_long) -> CURLcode]("curl_easy_setopt")(
#             curl, option, parameter
#         )

#     fn curl_easy_perform(self, curl: CURL) -> CURLcode:
#         """Perform a blocking file transfer.
        
#         This function performs the entire request in a blocking manner and returns
#         when done, or if it failed. For non-blocking behavior, consider using the
#         multi interface instead.
        
#         Args:
#             curl: The CURL handle to perform the transfer with.

#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL) -> CURLcode]("curl_easy_perform")(curl)

#     fn curl_easy_cleanup(self, curl: CURL) -> NoneType:
#         """End a libcurl easy handle.
        
#         This function must be the last function to call for an easy session.
#         It is the opposite of the curl_easy_init() function and must be called
#         with the same handle as input that a curl_easy_init() call returned.
        
#         Args:
#             curl: The CURL handle to cleanup.
#         """
#         return self.lib.get_function[fn (CURL) -> NoneType]("curl_easy_cleanup")(curl)

#     fn curl_easy_getinfo(self, curl: CURL, info: CURLINFO, parameter: OpaquePointer) -> CURLcode:
#         """Extract information from a curl handle.
        
#         Request internal information from the curl session with this function.
#         The third argument MUST be pointing to the specific type of the used option
#         which is documented in each option's manual page. The data pointed to
#         will be filled in accordingly and can be relied upon only if the function
#         returns CURLE_OK.
        
#         Args:
#             curl: The CURL handle to extract info from.
#             info: The information to extract.
#             parameter: Pointer to store the extracted information.

#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL, CURLINFO, OpaquePointer) -> CURLcode]("curl_easy_getinfo")(
#             curl, info, parameter
#         )

#     fn curl_easy_duphandle(self, curl: CURL) -> CURL:
#         """Clone a libcurl session handle.
        
#         Creates a new curl session handle with the same options set for the handle
#         passed in. Duplicating a handle could only be a matter of cloning data and
#         options, internal state info and things like persistent connections cannot
#         be transferred.
        
#         Args:
#             curl: The CURL handle to duplicate.
            
#         Returns:
#             A new CURL handle on success, or NULL on error.
#         """
#         return self.lib.get_function[fn (CURL) -> CURL]("curl_easy_duphandle")(curl)

#     fn curl_easy_reset(self, curl: CURL) -> NoneType:
#         """Reset all options of a libcurl session handle.
        
#         Re-initializes all options previously set on a specified CURL handle to
#         the default values. This puts back the handle to the same state as it was
#         in when it was just created with curl_easy_init().
        
#         It does keep: live connections, the Session ID cache, the DNS cache,
#         the cookies and shares.
        
#         Args:
#             curl: The CURL handle to reset.
#         """
#         return self.lib.get_function[fn (CURL) -> NoneType]("curl_easy_reset")(curl)

#     fn curl_easy_recv(self, curl: CURL, buffer: OpaquePointer, buflen: c_size_t, n: UnsafePointer[c_size_t]) -> CURLcode:
#         """Receives raw data on an "easy" connection.
        
#         This function receives raw data from the established connection. You may
#         use it together with curl_easy_send() to implement custom protocols using
#         libcurl's easy interface. This functionality can be particularly useful if
#         you use proxies and/or SSL encryption: libcurl will take care of proxy
#         negotiation and connection setup.
        
#         Args:
#             curl: The CURL handle for the connection.
#             buffer: Buffer to store the received data.
#             buflen: Size of the buffer.
#             n: Pointer to store the number of bytes actually received.
            
#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL, OpaquePointer, c_size_t, UnsafePointer[c_size_t]) -> CURLcode]("curl_easy_recv")(
#             curl, buffer, buflen, n
#         )

#     fn curl_easy_send(self, curl: CURL, buffer: OpaquePointer, buflen: c_size_t, n: UnsafePointer[c_size_t]) -> CURLcode:
#         """Sends raw data over an "easy" connection.
        
#         This function sends raw data over the established connection. You may use
#         it together with curl_easy_recv() to implement custom protocols using
#         libcurl's easy interface. This functionality can be particularly useful if
#         you use proxies and/or SSL encryption: libcurl will take care of proxy
#         negotiation and connection setup.
        
#         Args:
#             curl: The CURL handle for the connection.
#             buffer: Buffer containing the data to send.
#             buflen: Size of the data to send.
#             n: Pointer to store the number of bytes actually sent.
            
#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL, OpaquePointer, c_size_t, UnsafePointer[c_size_t]) -> CURLcode]("curl_easy_send")(
#             curl, buffer, buflen, n
#         )

#     fn curl_easy_upkeep(self, curl: CURL) -> CURLcode:
#         """Perform any connection upkeep checks.
        
#         Some protocols have "connection upkeep" mechanisms. These mechanisms
#         usually send some traffic on existing connections in order to keep them
#         alive; this can prevent connections from being closed due to overzealous
#         firewalls, for example.
        
#         Args:
#             curl: The CURL handle to perform upkeep on.
            
#         Returns:
#             CURLE_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURL) -> CURLcode]("curl_easy_upkeep")(curl)

#     fn curl_easy_strerror(self, code: CURLcode) -> UnsafePointer[c_char]:
#         """Return string describing error code.
        
#         This function returns a string describing the CURLcode error code passed in the argument errornum.
        
#         Args:
#             code: The CURLcode error code.
            
#         Returns:
#             A pointer to a null-terminated string describing the error.
#         """
#         return self.lib.get_function[fn (CURLcode) -> UnsafePointer[c_char]]("curl_easy_strerror")(code)

#     fn curl_easy_getdate(self, datestr: UnsafePointer[c_char, mut=False], unused: UnsafePointer[c_long]) -> c_long:
#         """Parse a date string and return it as seconds since epoch.
        
#         Args:
#             datestr: The date string to parse.
#             unused: Unused parameter (pass NULL).
            
#         Returns:
#             Seconds since epoch, or -1 on error.
#         """
#         return self.lib.get_function[fn (UnsafePointer[c_char, mut=False], UnsafePointer[c_long]) -> c_long]("curl_getdate")(
#             datestr, unused
#         )

#     # String list functions
#     fn curl_slist_append(self, list: curl_slist, string: UnsafePointer[c_char, mut=False]) -> curl_slist:
#         """Append a string to a curl string list.
        
#         Args:
#             list: The existing string list (can be NULL).
#             string: The string to append.
            
#         Returns:
#             A pointer to the new list, or NULL on error.
#         """
#         return self.lib.get_function[fn (curl_slist, UnsafePointer[c_char, mut=False]) -> curl_slist]("curl_slist_append")(
#             list, string
#         )

#     fn curl_slist_free_all(self, list: curl_slist) -> NoneType:
#         """Free an entire curl string list.
        
#         Args:
#             list: The string list to free.
#         """
#         return self.lib.get_function[fn (curl_slist) -> NoneType]("curl_slist_free_all")(list)

#     # URL encoding/decoding functions
#     fn curl_easy_escape(self, curl: CURL, string: UnsafePointer[c_char, mut=False], length: c_int) -> UnsafePointer[c_char]:
#         """URL encode a string.
        
#         Args:
#             curl: The CURL handle.
#             string: The string to encode.
#             length: Length of the string, or 0 for strlen(string).
            
#         Returns:
#             A pointer to the encoded string, or NULL on error. Must be freed with curl_free().
#         """
#         return self.lib.get_function[fn (CURL, UnsafePointer[c_char, mut=False], c_int) -> UnsafePointer[c_char]]("curl_easy_escape")(
#             curl, string, length
#         )

#     fn curl_easy_unescape(self, curl: CURL, string: UnsafePointer[c_char, mut=False], length: c_int, outlength: UnsafePointer[c_int]) -> UnsafePointer[c_char]:
#         """URL decode a string.
        
#         Args:
#             curl: The CURL handle.
#             string: The string to decode.
#             length: Length of the string, or 0 for strlen(string).
#             outlength: Pointer to store the length of the decoded string.
            
#         Returns:
#             A pointer to the decoded string, or NULL on error. Must be freed with curl_free().
#         """
#         return self.lib.get_function[fn (CURL, UnsafePointer[c_char, mut=False], c_int, UnsafePointer[c_int]) -> UnsafePointer[c_char]]("curl_easy_unescape")(
#             curl, string, length, outlength
#         )

#     fn curl_free(self, ptr: OpaquePointer) -> NoneType:
#         """Free memory allocated by libcurl.
        
#         This function should be used to free strings returned by curl functions
#         like curl_easy_escape() and curl_easy_unescape().
        
#         Args:
#             ptr: Pointer to the memory to free.
#         """
#         return self.lib.get_function[fn (OpaquePointer) -> NoneType]("curl_free")(ptr)

#     # Multi interface functions
#     fn curl_multi_init(self) -> CURLM:
#         """Initialize a multi session.
        
#         Returns:
#             A CURLM handle on success, or NULL on error.
#         """
#         return self.lib.get_function[fn () -> CURLM]("curl_multi_init")()

#     fn curl_multi_add_handle(self, multi_handle: CURLM, curl_handle: CURL) -> CURLMcode:
#         """Add an easy handle to a multi session.
        
#         Args:
#             multi_handle: The multi handle.
#             curl_handle: The easy handle to add.
            
#         Returns:
#             CURLM_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURLM, CURL) -> CURLMcode]("curl_multi_add_handle")(multi_handle, curl_handle)

#     fn curl_multi_remove_handle(self, multi_handle: CURLM, curl_handle: CURL) -> CURLMcode:
#         """Remove an easy handle from a multi session.
        
#         Args:
#             multi_handle: The multi handle.
#             curl_handle: The easy handle to remove.
            
#         Returns:
#             CURLM_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURLM, CURL) -> CURLMcode]("curl_multi_remove_handle")(multi_handle, curl_handle)

#     fn curl_multi_perform(self, multi_handle: CURLM, running_handles: UnsafePointer[c_int]) -> CURLMcode:
#         """Perform transfers on all added handles.
        
#         Args:
#             multi_handle: The multi handle.
#             running_handles: Pointer to store the number of running handles.
            
#         Returns:
#             CURLM_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURLM, UnsafePointer[c_int]) -> CURLMcode]("curl_multi_perform")(
#             multi_handle, running_handles
#         )

#     fn curl_multi_cleanup(self, multi_handle: CURLM) -> CURLMcode:
#         """Clean up a multi session.
        
#         Args:
#             multi_handle: The multi handle to cleanup.
            
#         Returns:
#             CURLM_OK on success, or an error code on failure.
#         """
#         return self.lib.get_function[fn (CURLM) -> CURLMcode]("curl_multi_cleanup")(multi_handle)

#     fn curl_multi_info_read(self, multi_handle: CURLM, msgs_in_queue: UnsafePointer[c_int]) -> CURLMsg:
#         """Read info from individual transfers.
        
#         Args:
#             multi_handle: The multi handle.
#             msgs_in_queue: Pointer to store the number of messages in queue.
            
#         Returns:
#             A pointer to a CURLMsg structure, or NULL if no more messages.
#         """
#         return self.lib.get_function[fn (CURLM, UnsafePointer[c_int]) -> CURLMsg]("curl_multi_info_read")(
#             multi_handle, msgs_in_queue
#         )

#     fn curl_multi_strerror(self, code: CURLMcode) -> UnsafePointer[c_char]:
#         """Return string describing multi error code.
        
#         Args:
#             code: The CURLMcode error code.

#         Returns:
#             A pointer to a null-terminated string describing the error.
#         """
#         return self.lib.get_function[fn (CURLMcode) -> UnsafePointer[c_char]]("curl_multi_strerror")(code)

#     # Utility methods for common operations
#     fn get_error_message(self, code: CURLcode) -> String:
#         """Get a human-readable error message for a curl error code.
        
#         Args:
#             code: The CURLcode error code.
            
#         Returns:
#             A string description of the error.
#         """
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
#         elif code == CURLE_SSL_PEER_CERTIFICATE:
#             return "SSL peer certificate error"
#         elif code == CURLE_TOO_MANY_REDIRECTS:
#             return "Too many redirects"
#         else:
#             return "Unknown curl error: " + String(code)

#     fn is_success(self, code: CURLcode) -> Bool:
#         """Check if a curl operation was successful.
        
#         Args:
#             code: The CURLcode to check.
            
#         Returns:
#             True if the operation was successful, False otherwise.
#         """
#         return code == CURLcode.CURLE_OK
