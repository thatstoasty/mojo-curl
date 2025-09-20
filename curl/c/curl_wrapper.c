#include "curl.h"
#include "easy.h"

// Wrapper functions to handle variadic curl_easy_setopt calls safely
// These provide type-safe wrappers around the variadic curl_easy_setopt function

CURLcode curl_easy_setopt_string_wrapper(CURL *curl, CURLoption option, const char *param) {
    return curl_easy_setopt(curl, option, param);
}

CURLcode curl_easy_setopt_long_wrapper(CURL *curl, CURLoption option, long param) {
    return curl_easy_setopt(curl, option, param);
}

CURLcode curl_easy_setopt_pointer_wrapper(CURL *curl, CURLoption option, void *param) {
    return curl_easy_setopt(curl, option, param);
}

CURLcode curl_easy_setopt_callback_wrapper(CURL *curl, CURLoption option, void *callback) {
    return curl_easy_setopt(curl, option, callback);
}

// Wrapper for curl_easy_getinfo with string output
CURLcode curl_easy_getinfo_string_wrapper(CURL *curl, CURLINFO info, char **param) {
    return curl_easy_getinfo(curl, info, param);
}

// Wrapper for curl_easy_getinfo with long output
CURLcode curl_easy_getinfo_long_wrapper(CURL *curl, CURLINFO info, long *param) {
    return curl_easy_getinfo(curl, info, param);
}
