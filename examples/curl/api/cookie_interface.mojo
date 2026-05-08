# Converted from allexamples/cookie_interface.c
# Import and export cookies using the CURLOPT_COOKIELIST interface

from mojo_curl import Easy
from mojo_curl.c.types import Result


def main() raises:
    var easy = Easy()

    _ = easy.url("https://www.example.com/")
    _ = easy.verbose(verbose=True)
    # Enable the cookie engine by providing an empty cookie file path
    _ = easy.cookie_file()

    var result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))

    # Print all cookies libcurl knows about
    print("Cookies, curl knows:")
    var jar = easy.cookies()
    var count = 0
    for cookie in jar:
        count += 1
        print("[", count, "]:", cookie)
    if count == 0:
        print("(none)")
    jar^.free()

    # Erase all in-memory cookies
    print("Erasing curl's knowledge of cookies!")
    _ = easy.cookie_list("ALL")
    var jar2 = easy.cookies()
    count = 0
    for cookie in jar2:
        count += 1
        print("[", count, "]:", cookie)
    if count == 0:
        print("(none)")
    jar2^.free()

    print("Setting a cookie 'PREF' via cookie interface:")
    # Netscape format: domain\tinclude_subdomains\tpath\tsecure\texpiry\tname\tvalue
    # Expiry 4102444800 = year 2100 (far future)
    _ = easy.cookie_list(
        ".example.com\tTRUE\t/\tFALSE\t4102444800\tPREF\thello example, I like you!"
    )
    # HTTP Set-Cookie style header
    _ = easy.cookie_list(
        "Set-Cookie: OLD_PREF=3d141414bf4209321;"
        " expires=Sun, 17-Jan-2038 19:14:07 GMT; path=/; domain=.example.com"
    )

    var jar3 = easy.cookies()
    count = 0
    for cookie in jar3:
        count += 1
        print("[", count, "]:", cookie)
    if count == 0:
        print("(none)")
    jar3^.free()

    result = easy.perform()
    if result != Result.OK:
        raise Error(easy.describe_error(result))
