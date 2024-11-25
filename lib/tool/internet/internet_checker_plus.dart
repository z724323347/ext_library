library internet_checker;

// Dart Packages
import 'dart:async';
import 'package:http/http.dart' as http;

class InternetConnection {
  factory InternetConnection() => _instance;

  InternetConnection.createInstance({
    this.checkInterval = const Duration(seconds: 10),
    List<InternetCheckOption>? customCheckOptions,
    bool useDefaultOptions = true,
  }) : assert(
          useDefaultOptions || customCheckOptions?.isNotEmpty == true,
          'You must provide a list of options if you are not using the '
          'default ones.',
        ) {
    _internetCheckOptions = [
      if (useDefaultOptions) ..._defaultCheckOptions,
      if (customCheckOptions != null) ...customCheckOptions,
    ];

    _statusController.onListen = _maybeEmitStatusUpdate;
    _statusController.onCancel = _handleStatusChangeCancel;
  }

  final List<InternetCheckOption> _defaultCheckOptions = [
    InternetCheckOption(uri: Uri.parse('https://one.one.one.one')),
    InternetCheckOption(uri: Uri.parse('https://icanhazip.com/')),
    InternetCheckOption(
      uri: Uri.parse('https://jsonplaceholder.typicode.com/todos/1'),
    ),
    InternetCheckOption(uri: Uri.parse('https://reqres.in/api/users/1')),
  ];

  late List<InternetCheckOption> _internetCheckOptions;
  final _statusController = StreamController<InternetStatus>.broadcast();
  static final _instance = InternetConnection.createInstance();
  final Duration checkInterval;
  InternetStatus? _lastStatus;
  Timer? _timerHandle;

  Future<InternetCheckResult> _checkReachabilityFor(
    InternetCheckOption option,
  ) async {
    try {
      final response = await http
          .head(option.uri, headers: option.headers)
          .timeout(option.timeout);

      return InternetCheckResult(
        option: option,
        isSuccess: option.responseStatusFn(response),
      );
    } catch (_) {
      return InternetCheckResult(
        option: option,
        isSuccess: false,
      );
    }
  }

  Future<bool> get hasInternetAccess async {
    final completer = Completer<bool>();
    int length = _internetCheckOptions.length;

    for (final option in _internetCheckOptions) {
      unawaited(
        _checkReachabilityFor(option).then((result) {
          length -= 1;

          if (completer.isCompleted) return;

          if (result.isSuccess) {
            completer.complete(true);
          } else if (length == 0) {
            completer.complete(false);
          }
        }),
      );
    }

    return completer.future;
  }

  Future<InternetStatus> get internetStatus async => await hasInternetAccess
      ? InternetStatus.connected
      : InternetStatus.disconnected;

  Future<void> _maybeEmitStatusUpdate() async {
    _timerHandle?.cancel();

    final currentStatus = await internetStatus;

    if (!_statusController.hasListener) return;

    if (_lastStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }

    _timerHandle = Timer(checkInterval, _maybeEmitStatusUpdate);

    _lastStatus = currentStatus;
  }

  void _handleStatusChangeCancel() {
    if (_statusController.hasListener) return;

    _timerHandle?.cancel();
    _timerHandle = null;
    _lastStatus = null;
  }

  InternetStatus? get lastTryResults => _lastStatus;
  Stream<InternetStatus> get onStatusChange => _statusController.stream;
}

/// code
///
/// InternetStatus
///
/// ResponseStatusFn
///
/// InternetCheckOption
///
/// InternetCheckResult

//

///
enum InternetStatus {
  /// Internet is available because at least one of the HEAD requests succeeded.
  connected,

  /// None of the HEAD requests succeeded. Basically, no internet.
  disconnected,
}

typedef ResponseStatusFn = bool Function(http.Response response);

class InternetCheckOption {
  InternetCheckOption({
    required this.uri,
    this.timeout = const Duration(seconds: 3),
    this.headers = const {},
    ResponseStatusFn? responseStatusFn,
  }) : responseStatusFn = responseStatusFn ?? defaultResponseStatusFn;

  static ResponseStatusFn defaultResponseStatusFn = (response) {
    return response.statusCode == 200;
  };

  final Uri uri;
  final Duration timeout;
  final Map<String, String> headers;
  final ResponseStatusFn responseStatusFn;
  @override
  String toString() {
    return 'InternetCheckOption(\n'
        '  uri: $uri,\n'
        '  timeout: $timeout,\n'
        '  headers: $headers\n'
        ')';
  }
}

class InternetCheckResult {
  InternetCheckResult({required this.option, required this.isSuccess});
  final InternetCheckOption option;
  final bool isSuccess;

  @override
  String toString() {
    return 'InternetCheckResult(\n'
        '  option: ${option.toString().replaceAll('\n', '\n  ')},\n'
        '  isSuccess: $isSuccess\n'
        ')';
  }
}
