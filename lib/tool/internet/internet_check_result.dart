part of internet_checker;

/// Helper class that contains the Internet options and indicates whether
/// opening a socket to it succeeded.
class InternetCheckResult {
  /// [InternetCheckResult] constructor
  InternetCheckResult(
    this.options, {
    required this.isSuccess,
  });

  /// InternetCheckOptions
  final InternetCheckOptions options;

  /// bool val to store result
  final bool isSuccess;

  @override
  String toString() => 'InternetCheckResult($options, $isSuccess)';
}
