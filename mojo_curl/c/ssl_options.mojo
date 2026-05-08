from std.ffi import c_long


@fieldwise_init
struct SSLOption(TrivialRegisterPassable):
    var bits: c_long
    """Struct representing SSL options for the CURLSSLOPT option in libcurl."""

    comptime REVOKE_BEST_EFFORT = Self(1 << 0)
    """
    Tells libcurl to ignore certificate revocation checks in case of missing or
    offline distribution points for those SSL backends where such behavior is present.

    This option is only supported for Schannel (the native Windows SSL library).

    If combined with CURLSSLOPT_NO_REVOKE, the latter takes precedence. (Added in 7.70.0)
    """
    comptime ALLOW_BEAST = Self(1 << 1)
    """Tells libcurl to not attempt to use any workarounds for a security flaw
    in the SSL3 and TLS1.0 protocols.

    If this option isn't used or this bit is set to 0, the SSL layer libcurl
    uses may use a work-around for this flaw although it might cause
    interoperability problems with some (older) SSL implementations.

    > WARNING: avoiding this work-around lessens the security, and by
    > setting this option to 1 you ask for exactly that. This option is only
    > supported for DarwinSSL, NSS and OpenSSL.
    """
    comptime NO_PARTIALCHAIN = Self(1 << 2)
    """Tells libcurl to not accept "partial" certificate chains, which it otherwise does by default.

    This option is only supported for OpenSSL and will fail the certificate verification
    if the chain ends with an intermediate certificate and not with a root cert.
    (Added in 7.68.0)
    """
    comptime NATIVE_CA = Self(1 << 4)
    """Tell libcurl to use the operating system's native CA store for certificate verification.

    Works only on Windows when built to use OpenSSL.

    This option is experimental and behavior is subject to change. (Added in 7.71.0).
    """
    comptime AUTO_CLIENT_CERT = Self(1 << 5)
    """Tell libcurl to automatically locate and use a client certificate for authentication,
    when requested by the server.

    This option is only supported for Schannel (the native Windows SSL library).
    Prior to 7.77.0 this was the default behavior in libcurl with Schannel.

    Since the server can request any certificate that supports client authentication in
    the OS certificate store it could be a privacy violation and unexpected. (Added in 7.77.0)
    """