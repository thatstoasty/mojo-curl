@fieldwise_init
struct Protocol(ImplicitlyCopyable, Copyable, Movable, Writable):
    var value: UInt8
    alias HTTP_10 = Self(0)
    alias HTTP_11 = Self(1)
    alias HTTPS = Self(2)

    fn write_to[T: Writer, //](self, mut writer: T):
        writer.write(self.value)

    @staticmethod
    fn from_string(s: StringSlice) raises -> Self:
        if s == "HTTP/1.1":
            return Self.HTTP_11
        elif s == "HTTP/1.0":
            return Self.HTTP_10
        elif s == "https":
            # HTTP/2 is not yet supported; default to HTTP/1.1
            return Self.HTTPS
        else:
            raise Error("Invalid protocol: ", s)


@fieldwise_init
@register_passable("trivial")
struct StatusCode(Copyable, EqualityComparable, Movable, Writable):
    var value: UInt16

    alias CONTINUE = Self(100)
    alias SWITCHING_PROTOCOLS = Self(101)
    alias PROCESSING = Self(102)
    alias EARLY_HINTS = Self(103)

    alias OK = Self(200)
    alias CREATED = Self(201)
    alias ACCEPTED = Self(202)
    alias NON_AUTHORITATIVE_INFORMATION = Self(203)
    alias NO_CONTENT = Self(204)
    alias RESET_CONTENT = Self(205)
    alias PARTIAL_CONTENT = Self(206)
    alias MULTI_STATUS = Self(207)
    alias ALREADY_REPORTED = Self(208)
    alias IM_USED = Self(226)

    alias MULTIPLE_CHOICES = Self(300)
    alias MOVED_PERMANENTLY = Self(301)
    alias FOUND = Self(302)
    alias TEMPORARY_REDIRECT = Self(307)
    alias PERMANENT_REDIRECT = Self(308)

    alias BAD_REQUEST = Self(400)
    alias UNAUTHORIZED = Self(401)
    alias PAYMENT_REQUIRED = Self(402)
    alias FORBIDDEN = Self(403)
    alias NOT_FOUND = Self(404)
    alias METHOD_NOT_ALLOWED = Self(405)
    alias NOT_ACCEPTABLE = Self(406)
    alias PROXY_AUTHENTICATION_REQUIRED = Self(407)
    alias REQUEST_TIMEOUT = Self(408)
    alias CONFLICT = Self(409)
    alias GONE = Self(410)
    alias LENGTH_REQUIRED = Self(411)
    alias PRECONDITION_FAILED = Self(412)
    alias PAYLOAD_TOO_LARGE = Self(413)
    alias URI_TOO_LONG = Self(414)
    alias UNSUPPORTED_MEDIA_TYPE = Self(415)
    alias RANGE_NOT_SATISFIABLE = Self(416)
    alias EXPECTATION_FAILED = Self(417)
    alias IM_A_TEAPOT = Self(418)
    alias MISDIRECTED_REQUEST = Self(421)
    alias UNPROCESSABLE_ENTITY = Self(422)
    alias LOCKED = Self(423)
    alias FAILED_DEPENDENCY = Self(424)
    alias TOO_EARLY = Self(425)
    alias UPGRADE_REQUIRED = Self(426)
    alias PRECONDITION_REQUIRED = Self(428)
    alias TOO_MANY_REQUESTS = Self(429)
    alias REQUEST_HEADER_FIELDS_TOO_LARGE = Self(431)
    alias UNAVAILABLE_FOR_LEGAL_REASONS = Self(451)

    alias INTERNAL_ERROR = Self(500)
    alias NOT_IMPLEMENTED = Self(501)
    alias BAD_GATEWAY = Self(502)
    alias SERVICE_UNAVAILABLE = Self(503)
    alias GATEWAY_TIMEOUT = Self(504)
    alias HTTP_VERSION_NOT_SUPPORTED = Self(505)
    alias VARIANT_ALSO_NEGOTIATES = Self(506)
    alias INSUFFICIENT_STORAGE = Self(507)
    alias LOOP_DETECTED = Self(508)
    alias NOT_EXTENDED = Self(510)
    alias NETWORK_AUTHENTICATION_REQUIRED = Self(511)

    @staticmethod
    fn from_int(code: Int) raises -> StatusCode:
        """Creates a StatusCode instance from an integer representation.

        Arguments:
            s: The integer representation of the status code.

        Returns:
            A StatusCode instance corresponding to the provided integer.
        """
        # For every alias defined in StatusCode, check if the integer matches
        # the value of the alias.
        if Self.OK == code:
            return Self.OK
        elif Self.CREATED == code:
            return Self.CREATED
        elif Self.ACCEPTED == code:
            return Self.ACCEPTED
        elif Self.NON_AUTHORITATIVE_INFORMATION == code:
            return Self.NON_AUTHORITATIVE_INFORMATION
        elif Self.NO_CONTENT == code:
            return Self.NO_CONTENT
        elif Self.RESET_CONTENT == code:
            return Self.RESET_CONTENT
        elif Self.PARTIAL_CONTENT == code:
            return Self.PARTIAL_CONTENT
        elif Self.MULTI_STATUS == code:
            return Self.MULTI_STATUS
        elif Self.ALREADY_REPORTED == code:
            return Self.ALREADY_REPORTED
        elif Self.IM_USED == code:
            return Self.IM_USED
        elif Self.MULTIPLE_CHOICES == code:
            return Self.MULTIPLE_CHOICES
        elif Self.MOVED_PERMANENTLY == code:
            return Self.MOVED_PERMANENTLY
        elif Self.FOUND == code:
            return Self.FOUND
        elif Self.TEMPORARY_REDIRECT == code:
            return Self.TEMPORARY_REDIRECT
        elif Self.PERMANENT_REDIRECT == code:
            return Self.PERMANENT_REDIRECT
        elif Self.BAD_REQUEST == code:
            return Self.BAD_REQUEST
        elif Self.UNAUTHORIZED == code:
            return Self.UNAUTHORIZED
        elif Self.PAYMENT_REQUIRED == code:
            return Self.PAYMENT_REQUIRED
        elif Self.FORBIDDEN == code:
            return Self.FORBIDDEN
        elif Self.NOT_FOUND == code:
            return Self.NOT_FOUND
        elif Self.METHOD_NOT_ALLOWED == code:
            return Self.METHOD_NOT_ALLOWED
        elif Self.NOT_ACCEPTABLE == code:
            return Self.NOT_ACCEPTABLE
        elif Self.PROXY_AUTHENTICATION_REQUIRED == code:
            return Self.PROXY_AUTHENTICATION_REQUIRED
        elif Self.REQUEST_TIMEOUT == code:
            return Self.REQUEST_TIMEOUT
        elif Self.CONFLICT == code:
            return Self.CONFLICT
        elif Self.GONE == code:
            return Self.GONE
        elif Self.LENGTH_REQUIRED == code:
            return Self.LENGTH_REQUIRED
        elif Self.PRECONDITION_FAILED == code:
            return Self.PRECONDITION_FAILED
        elif Self.PAYLOAD_TOO_LARGE == code:
            return Self.PAYLOAD_TOO_LARGE
        elif Self.URI_TOO_LONG == code:
            return Self.URI_TOO_LONG
        elif Self.UNSUPPORTED_MEDIA_TYPE == code:
            return Self.UNSUPPORTED_MEDIA_TYPE
        elif Self.RANGE_NOT_SATISFIABLE == code:
            return Self.RANGE_NOT_SATISFIABLE
        elif Self.EXPECTATION_FAILED == code:
            return Self.EXPECTATION_FAILED
        elif Self.IM_A_TEAPOT == code:
            return Self.IM_A_TEAPOT
        elif Self.MISDIRECTED_REQUEST == code:
            return Self.MISDIRECTED_REQUEST
        elif Self.UNPROCESSABLE_ENTITY == code:
            return Self.UNPROCESSABLE_ENTITY
        elif Self.LOCKED == code:
            return Self.LOCKED
        elif Self.FAILED_DEPENDENCY == code:
            return Self.FAILED_DEPENDENCY
        elif Self.TOO_EARLY == code:
            return Self.TOO_EARLY
        elif Self.UPGRADE_REQUIRED == code:
            return Self.UPGRADE_REQUIRED
        elif Self.PRECONDITION_REQUIRED == code:
            return Self.PRECONDITION_REQUIRED
        elif Self.TOO_MANY_REQUESTS == code:
            return Self.TOO_MANY_REQUESTS
        elif Self.REQUEST_HEADER_FIELDS_TOO_LARGE == code:
            return Self.REQUEST_HEADER_FIELDS_TOO_LARGE
        elif Self.UNAVAILABLE_FOR_LEGAL_REASONS == code:
            return Self.UNAVAILABLE_FOR_LEGAL_REASONS
        elif Self.INTERNAL_ERROR == code:
            return Self.INTERNAL_ERROR
        elif Self.NOT_IMPLEMENTED == code:
            return Self.NOT_IMPLEMENTED
        elif Self.BAD_GATEWAY == code:
            return Self.BAD_GATEWAY
        elif Self.SERVICE_UNAVAILABLE == code:
            return Self.SERVICE_UNAVAILABLE
        elif Self.GATEWAY_TIMEOUT == code:
            return Self.GATEWAY_TIMEOUT
        elif Self.HTTP_VERSION_NOT_SUPPORTED == code:
            return Self.HTTP_VERSION_NOT_SUPPORTED
        elif Self.VARIANT_ALSO_NEGOTIATES == code:
            return Self.VARIANT_ALSO_NEGOTIATES
        elif Self.INSUFFICIENT_STORAGE == code:
            return Self.INSUFFICIENT_STORAGE
        elif Self.LOOP_DETECTED == code:
            return Self.LOOP_DETECTED
        elif Self.NOT_EXTENDED == code:
            return Self.NOT_EXTENDED
        elif Self.NETWORK_AUTHENTICATION_REQUIRED == code:
            return Self.NETWORK_AUTHENTICATION_REQUIRED
        elif Self.CONTINUE == code:
            return Self.CONTINUE
        elif Self.SWITCHING_PROTOCOLS == code:
            return Self.SWITCHING_PROTOCOLS
        elif Self.PROCESSING == code:
            return Self.PROCESSING
        elif Self.EARLY_HINTS == code:
            return Self.EARLY_HINTS
        else:
            raise Error("Unknown status code: ", code)

    fn __eq__(self, other: Self) -> Bool:
        """Compares two StatusCode instances for equality.

        Arguments:
            other: The StatusCode instance to compare with.

        Returns:
            True if both instances have the same value, otherwise False.
        """
        return self.value == other.value

    fn __eq__(self, other: Int) -> Bool:
        """Compares a StatusCode instance with an integer for equality.

        Arguments:
            other: The integer to compare with.

        Returns:
            True if the StatusCode instance's value matches the integer, otherwise False.
        """
        return self.value == other

    fn write_to[W: Writer, //](self, mut writer: W) -> None:
        """Writes the StatusCode instance to a writer.

        This method is used to write the status code in a human-readable format.

        Args:
            writer: The writer to which the status code will be written.
        """
        writer.write(self.value)


@fieldwise_init
struct RequestMethod(ImplicitlyCopyable, Copyable, Movable, Writable):
    var value: UInt8

    alias GET = Self(0)
    alias POST = Self(1)
    alias PUT = Self(2)
    alias DELETE = Self(3)
    alias HEAD = Self(4)
    alias PATCH = Self(5)
    alias OPTIONS = Self(6)

    fn write_to[T: Writer, //](self, mut writer: T):
        writer.write(self.value)

    @staticmethod
    fn from_string(s: StringSlice) raises -> RequestMethod:
        if s == "GET":
            return RequestMethod.GET
        elif s == "POST":
            return RequestMethod.POST
        elif s == "PUT":
            return RequestMethod.PUT
        elif s == "DELETE":
            return RequestMethod.DELETE
        elif s == "HEAD":
            return RequestMethod.HEAD
        elif s == "PATCH":
            return RequestMethod.PATCH
        elif s == "OPTIONS":
            return RequestMethod.OPTIONS
        else:
            raise Error("Invalid HTTP method: ", s)
