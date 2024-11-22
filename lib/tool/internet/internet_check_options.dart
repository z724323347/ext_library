part of internet_checker;

/// This class should be pretty self-explanatory.
/// If [InternetCheckOptions.port]
/// or [InternetCheckOptions.timeout] are not specified, they both
/// default to [InternetConnectionChecker.DEFAULT_PORT]
/// and [InternetConnectionChecker.DEFAULT_TIMEOUT]
/// Also... yeah, I'm not great at naming things.
class InternetCheckOptions {
  /// [InternetCheckOptions] Constructor
  InternetCheckOptions({
    this.address,
    this.hostname,
    this.port = InternetConnectionChecker.DEFAULT_PORT,
    this.timeout = InternetConnectionChecker.DEFAULT_TIMEOUT,
  }) : assert(
          (address != null || hostname != null) &&
              ((address != null) != (hostname != null)),
          'Either address or hostname must be provided, but not both.',
        );

  /// An internet address or a Unix domain address.
  /// This object holds an internet address. If this internet address
  /// is the result of a DNS lookup, the address also holds the hostname
  /// used to make the lookup.
  /// An Internet address combined with a port number represents an
  /// endpoint to which a socket can connect or a listening socket can
  /// bind.
  /// Either [address] or [hostname] must not be null.
  final InternetAddress? address;

  /// The hostname to use for this connection checker.
  /// Will be used to resolve an IP address to open the socket connection to.
  /// Can be used to verify against services that are not guaranteed to have
  /// a fixed IP address. Connecting via hostname also verifies that
  /// DNS resolution is working for the client.
  /// Either [address] or [hostname] must not be null.
  final String? hostname;

  /// Port
  final int port;

  /// Timeout Duration
  final Duration timeout;

  @override
  String toString() => 'InternetCheckOptions($address, $port, $timeout)';
}
