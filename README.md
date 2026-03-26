# mojo-curl

![Mojo Version](https://img.shields.io/badge/Mojo%F0%9F%94%A5-26.2-orange)
![Build Status](https://github.com/thatstoasty/mojo-curl/actions/workflows/build.yml/badge.svg)
![Test Status](https://github.com/thatstoasty/mojo-curl/actions/workflows/test.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Adding the `mojo-curl` package to your project

First, you'll need to configure your `pixi.toml` file to include a few community Conda channels. Add both Modular (`"https://repo.prefix.dev/modular-community"`) and my (`"https://repo.prefix.dev/mojo-community"`) Conda channels to the list of channels. 

### Installing it from the `mojo-community` Conda channel

First, you'll need to install the `curl_wrapper` library, which provides a thin wrapper around libcurl to avoid issues with variadic arguments. You'll need to enable the `pixi-build` preview by adding this to the `workspace section of your `pixi.toml` file.

```bash
preview = ["pixi-build"]
```

Next, you can add `curl_wrapper` by running:

```bash
pixi add curl_wrapper -g "https://github.com/thatstoasty/mojo-curl.git" --subdir shim --branch main
```

> Note: Mojo cannot currently support calling C functions with variadic arguments, and the libcurl client interface makes heavy use of them. The `curl_wrapper` library provides a thin wrapper around libcurl to avoid this issue. Remember to always validate the code you're pulling from third-party sources!

Next, run the following commands in your terminal:

```bash
pixi add mojo-curl && pixi install
```

This will add `mojo-curl` to your project's dependencies and install it along with its dependencies.

### Building it from source

There's two ways to build `mojo-curl` from source: directly from the Git repository or by cloning the repository locally.

#### Building from source: Git

Run the following commands in your terminal:

```bash
pixi add -g "https://github.com/thatstoasty/mojo-curl.git" && pixi install
```

#### Building from source: Local

```bash
# Clone the repository to your local machine
git clone https://github.com/thatstoasty/mojo-curl.git

# Add the package to your project from the local path
pixi add -s ./path/to/mojo-curl && pixi install
```

## Configuring library paths

`mojo-curl` needs to locate two dynamic libraries at runtime: `libcurl` and `libcurl_wrapper` (the thin C shim that wraps libcurl's variadic functions).

### Default behavior

By default, the library looks for both in your project's Pixi environment:

| Library | macOS | Linux |
| --- | --- | --- |
| libcurl | `.pixi/envs/default/lib/libcurl.dylib` | `.pixi/envs/default/lib/libcurl.so` |
| curl_wrapper | `.pixi/envs/default/lib/libcurl_wrapper.dylib` | `.pixi/envs/default/lib/libcurl_wrapper.so` |

If you installed `mojo-curl` and `curl_wrapper` via Pixi (as described above), the libraries will already be in the expected location and no additional configuration is needed.

### Custom library paths

If your libraries are in a different location, you can override the paths using either **environment variables** or **compile-time defines**.

#### Environment variables

Set `LIBCURL_LIB_PATH` and `CURL_WRAPPER_LIB_PATH` before running your program:

```bash
export LIBCURL_LIB_PATH="/usr/lib/libcurl.so"
export CURL_WRAPPER_LIB_PATH="/opt/mylibs/libcurl_wrapper.so"
mojo run my_program.mojo
```

#### Compile-time defines

Pass the paths as `-D` flags when compiling or running:

```bash
mojo run -D LIBCURL_LIB_PATH="/usr/lib/libcurl.so" -D CURL_WRAPPER_LIB_PATH="/opt/mylibs/libcurl_wrapper.so" my_program.mojo
```

Compile-time defines take priority over environment variables. If neither is set, the default Pixi environment paths are used.

## Usage

### Making a simple GET request

```mojo
from mojo_curl import Easy
from mojo_curl.c.types import Result

fn main() raises:
    var easy = Easy()

    # Set the URL to request
    _ = easy.url("https://httpbin.org/get")

    # Perform the request (response goes to stdout by default)
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

```

### Using a write callback

Define a callback function to handle received data instead of printing to stdout:

```mojo
from std.ffi import c_char, c_size_t

from mojo_curl import Easy
from mojo_curl.c.types import MutExternalOpaquePointer, MutExternalPointer, Result

fn write_callback(
    ptr: MutExternalPointer[c_char],
    size: c_size_t,
    nmemb: c_size_t,
    userdata: MutExternalOpaquePointer,
) -> c_size_t:
    print(StringSlice(unsafe_from_utf8_ptr=ptr))
    return size * nmemb

fn main() raises:
    var easy = Easy()
    _ = easy.url("https://httpbin.org/get")
    _ = easy.write_function(write_callback)
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
```

### Setting custom HTTP headers

Use `CurlList` to attach headers to your request:

```mojo
from mojo_curl import Easy, CurlList
from mojo_curl.c.types import Result

fn main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/get")

    # Headers are passed as a dictionary
    var headers = CurlList({
        "User-Agent": "mojo-curl/1.0",
        "Accept": "application/json",
    })
    _ = easy.http_headers(headers)

    var result = easy.perform()
    if result != Result.OK:
        headers^.free()
        raise Error(easy.describe_error(result))

    headers^.free()
```

### Reading response headers

After performing a request, you can read the response headers:

```mojo
from mojo_curl import Easy
from mojo_curl.c.types import Result

fn main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/get")
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    var response_headers = easy.headers()
    for pair in response_headers.items():
        print(String(pair.key, ": ", pair.value))
```

### Making a POST request

```mojo
from mojo_curl import Easy
from mojo_curl.c.types import Result

fn main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/post")
    _ = easy.post_fields("field1=value1&field2=value2".as_bytes())

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
```

### Enabling verbose output

Useful for debugging requests and seeing the full protocol exchange:

```mojo
from mojo_curl import Easy
from mojo_curl.c.types import Result

fn main() raises:
    var easy = Easy()

    _ = easy.url("https://httpbin.org/get")
    _ = easy.verbose(True)
    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
```
