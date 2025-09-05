import 'dart:collection';

///```dart
///
/// final executor = Executor(maxConcurrent: maxConcurrent);
///
/// executor.add(() async {
///   // do something
/// });
///
/// await executor.waitForEmpty();
///
///```
/// 并发执行器
class Executor {
  Executor({this.maxConcurrent = 3});
  final int maxConcurrent;
  final Queue<Future<void> Function()> _taskQueue = Queue();
  int _running = 0;

  /// 是否完成所有任务
  bool get isComplete => _running == 0;

  void add(Future<void> Function() task) {
    _taskQueue.add(task);
    _tryExecuteNext();
  }

  void _tryExecuteNext() {
    while (_running < maxConcurrent && _taskQueue.isNotEmpty) {
      final task = _taskQueue.removeFirst();
      _running++;
      task().whenComplete(() {
        _running--;
        _tryExecuteNext();
      });
    }
  }

  Future<void> waitForEmpty() async {
    while (_taskQueue.isNotEmpty || _running > 0) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
