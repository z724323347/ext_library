
// import 'dart:async';
// import 'dart:io';

// import 'package:ext_library/tool/tool_lib.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:stack_trace/stack_trace.dart';

// class FileWriteLog {
//   static FileWriteLog? _instance;
//   static FileWriteLog get instance => _instance ??= FileWriteLog._internal();

//   late File _logFile;
//   final List<String> _buffer = [];
//   Timer? _flushTimer;
//   bool _initialized = false;
//   String logTag = '[-- AppLog --]';

//   FileWriteLog._internal() {
//     init();
//   }

//   /// 写日志
//   void wPrint(Object? message) {
 
//     Chain chain = Chain.current(); // Chain.forTrace(StackTrace.current);
//     // 将 core 和 flutter 包的堆栈合起来（即相关数据只剩其中一条）
//     chain = chain
//         .foldFrames((Frame frame) => frame.isCore || frame.package == 'flutter');
//     // 取出所有信息帧
//     final List<Frame> frames = chain.toTrace().frames;
//     // 找到当前函数的信息帧
//     final int idx =
//         frames.indexWhere((Frame element) => element.member == 'logs');
//     if (idx == -1 || idx + 1 >= frames.length) {
//       return;
//     }
//     // 调用当前函数的函数信息帧
//     final Frame frame = frames[idx + 1];
//        // time
//     final String d = DateTime.now().full;
//     String str = logTag;
//     String path = '';
//     str += '\n[LogTime]:  $d';
//     path = frame.uri.toString().split('/').last;
//     str += '\n[文件]:          ${frame.uri.toString().fixLines} \n[日志🖨]$path ${'(Line:${frame.line})'} =>  $message';
//     str += '\n';
//     // print('strstr $str');
//      _buffer.add(str);
//   }

//   /// 初始化日志系统
//   Future<void> init({String fileName = 'app.log'}) async {
//     if (_initialized) {
//       return;
//     }
//     final dir = await getTemporaryDirectory();
//     _logFile = File('${dir.path}/$fileName');
//     // 若文件过大，可清理
//     if (_logFile.existsSync()) {
//       final length = await _logFile.length();
//       if (length > 50 * 1024 * 1024) {
//         await _logFile.writeAsString(''); // 清空
//       }
//     } else {
//       await _logFile.create(recursive: true);
//     }
//     // 定期 flush 缓冲区 并后台写入
//     _flushTimer ??= Timer.periodic(2.seconds, (_) => flush());
//     _initialized = true;
//     // 重定向 print()
//     _redirectPrint();
//   }

//   /// 实时写入文件
//   Future<void> flush() async {
//     if (_buffer.isEmpty || !_initialized) {
//       return;
//     }
//     final toWrite = '${_buffer.join('\n')}\n';
//     _buffer.clear();
//     await _logFile.writeAsString(toWrite, mode: FileMode.append, flush: true);
//   }

//   /// 重定向系统 print
//   void _redirectPrint() {
//     final spec = ZoneSpecification(
//       print: (_, __, ___, String msg) {
//         instance.wPrint(msg);
//       },
//     );
//     runZonedGuarded(
//       () {},
//       (_, __) => spec.errorCallback,
//       zoneSpecification: spec,
//     );
//   }

//   /// 读取日志文件内容
//   Future<String> readLogs() async {
//     if (_logFile.existsSync()) {
//       return _logFile.readAsString();
//     }
//     return '';
//   }

//   /// 删除日志文件
//   Future<void> clearLogs() async {
//     if (_logFile.existsSync()) {
//       await _logFile.writeAsString('');
//       await _logFile.delete();
//     }
//   }

//   /// 日志文件 File
//   File get logFile => _logFile;

//   Frame? get frame {
//     Chain chain = Chain.current();
//     chain = chain
//         .foldFrames((Frame frame) => frame.isCore || frame.package == 'flutter');
//     final List<Frame> frames = chain.toTrace().frames;

//     final int idx =
//         frames.indexWhere((Frame element) => element.member == 'logs');
//     if (idx == -1 || idx + 1 >= frames.length) {
//       return null;
//     }
//     final Frame frame = frames[idx + 1];
//     return frame;
//   }
// }