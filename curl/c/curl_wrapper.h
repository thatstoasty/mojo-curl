#ifndef CURL_WRAPPER_H
#define CURL_WRAPPER_H

#include "curl.h"
#include "easy.h"

#ifdef __cplusplus
extern "C" {
#endif

// Type-safe wrapper functions for curl_easy_setopt to avoid variadic function issues
CURLcode curl_easy_setopt_string(CURL *curl, CURLoption option, const char *param);
CURLcode curl_easy_setopt_long(CURL *curl, CURLoption option, long param);
CURLcode curl_easy_setopt_pointer(CURL *curl, CURLoption option, void *param);
CURLcode curl_easy_setopt_callback(CURL *curl, CURLoption option, void *callback);

// Type-safe wrapper functions for curl_easy_getinfo
CURLcode curl_easy_getinfo_string(CURL *curl, CURLINFO info, char **param);
CURLcode curl_easy_getinfo_long(CURL *curl, CURLINFO info, long *param);

#ifdef __cplusplus
}
#endif

#endif // CURL_WRAPPER_H
