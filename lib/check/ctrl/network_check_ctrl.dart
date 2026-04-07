import 'package:ext_library/lib_ext.dart';
import 'package:http/http.dart' as http;

class NetworkCheckCtrl extends GetxController {
  static NetworkCheckCtrl get to => Get.find();

  final httpBenchmark = const NetworkBenchmark().obs;
  final wsBenchmark = const NetworkBenchmark().obs;
  final webBenchmark = RxMap<String, Duration?>({
    'https://www.baidu.com': null,
    'https://nls-gateway-cn-shanghai.aliyuncs.com': null,
    'https://www.google.com': null,
  });

  late Dio dio;
  String url = '';

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void initNetWork({required Dio dio, String? url}) {
    this.dio = dio;
    this.url = url.safety;
    // 将 Map 转换为 List
    List<MapEntry<String, Duration?>> entries = webBenchmark.entries.toList();
    entries.insert(0, MapEntry(dio.options.baseUrl, null));
    webBenchmark.value = Map.fromEntries(entries);
    doTest();
  }

  Future<void> doTest() async {
    loading.value = true;
    await 100.ms.delay();
    testWeb().whenComplete(testWeb);
    testHttp();
    loading.value = false;
  }

  Future<void> testHttp() {
    return Future.sync(() {
      return Uri.parse('${dio.options.baseUrl}$url');
    }).then((uri) {
      return _runTest(
        uri: uri,
        rxBenchmark: httpBenchmark,
        sampleCount: 3,
      );
    });
  }

  Future<void> testWeb() {
    // 清除之前的测试结果
    webBenchmark.updateAll((key, value) => null);

    final stopwatch = Stopwatch();
    final client = http.Client();

    return Future.forEach<String>(webBenchmark.keys, (url) {
      final uri = Uri.parse(url);

      if (stopwatch.isRunning) {
        stopwatch.reset();
      } else {
        stopwatch.start();
      }
      return client
          .get(uri)
          .timeout(const Duration(seconds: 5))
          .then((response) {
        webBenchmark[url] = stopwatch.elapsed;
      }).catchError((error, stackTrace) {
        devlLogU.e('测试Web时出错', error, stackTrace);
        webBenchmark[url] = Duration.zero;
      });
    });
  }

  Future<void> _runTest({
    required Uri uri,
    Map<String, dynamic>? headers,
    ValidateStatus? validateStatus,
    required Rx<NetworkBenchmark> rxBenchmark,
    int sampleCount = 3,
  }) {
    rxBenchmark.value = const NetworkBenchmark(isCompleted: false);
    devLogs('uri  $uri');
    final int times = sampleCount <= 0 ? 1 : sampleCount;
    final List<Duration> costs = <Duration>[];
    int? totalBytes;

    return Future.doWhile(() async {
      if (costs.length >= times) {
        return false;
      }

      final stopWatch = Stopwatch()..start();
      final response = await dio.getUri(
        uri,
        options: Options(
          sendTimeout: 5000.ms,
          receiveTimeout: 5000.ms,
          responseType: ResponseType.json,
          headers: headers,
          validateStatus: validateStatus,
        ),
      );
      stopWatch.stop();
      costs.add(stopWatch.elapsed);

      final String? contentLength =
          response.headers.value(Headers.contentLengthHeader);
      totalBytes ??= int.tryParse(contentLength ?? '');
      return true;
    }).then((_) {
      final int avgMs = costs.fold<int>(
            0,
            (sum, e) => sum + e.inMilliseconds,
          ) ~/
          costs.length;
      final Duration avgDuration = Duration(milliseconds: avgMs);

      rxBenchmark.value = rxBenchmark.value.copyWith(
        connectionDuration: costs.first,
        networkDuration: avgDuration,
        totalBytes: totalBytes,
        decodingDuration: null,
      );
    }).catchError((error, stackTrace) {
      devlLogU.e('测试时出错', error, stackTrace);
      rxBenchmark.value = rxBenchmark.value.copyWith(error: error);
    }).whenComplete(() {
      rxBenchmark.value = rxBenchmark.value.copyWith(isCompleted: true);
    });
  }
}

class NetworkBenchmark {
  const NetworkBenchmark({
    this.connectionDuration,
    this.networkDuration,
    this.decodingDuration,
    this.totalBytes,
    this.error,
    this.isCompleted = true,
  });

  final Duration? connectionDuration;
  final Duration? networkDuration;
  final Duration? decodingDuration;
  final int? totalBytes;
  final Object? error;
  final bool isCompleted;

  NetworkBenchmark copyWith({
    Duration? connectionDuration,
    Duration? networkDuration,
    Duration? decodingDuration,
    int? totalBytes,
    dynamic error,
    bool? isCompleted,
  }) {
    return NetworkBenchmark(
      connectionDuration: connectionDuration ?? this.connectionDuration,
      networkDuration: networkDuration ?? this.networkDuration,
      decodingDuration: decodingDuration ?? this.decodingDuration,
      totalBytes: totalBytes ?? this.totalBytes,
      error: error ?? this.error,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
