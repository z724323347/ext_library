// ignore_for_file: always_put_control_body_on_new_line, strict_raw_type, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'frame_logcat.dart';

/// 渲染帧 TaskQueue
class FrameTaskQueue {
  FrameTaskQueue._();

  bool _hasRequestedAnEventLoopCallback = false;
  int maxTaskSize = 0;

  static FrameTaskQueue? _instance;

  static FrameTaskQueue? get instance {
    _instance ??= FrameTaskQueue._();
    return _instance;
  }

  SchedulingStrategy schedulingStrategy = defaultSchedulingStrategy;

  final Queue<TaskEntry<dynamic>> _taskQueue = ListQueue();

  int get taskLength => _taskQueue.length;

  Future<bool> handleEventLoopCallback() async {
    if (_taskQueue.isEmpty) return false;
    final TaskEntry<dynamic> entry = _taskQueue.first;
    if (schedulingStrategy(
        priority: entry.priority, scheduler: SchedulerBinding.instance)) {
      try {
        _taskQueue.removeFirst();
        entry.run();
      } catch (exception, exceptionStack) {
        StackTrace? callbackStack;
        assert(() {
          callbackStack = entry.debugStack;
          return true;
        }());
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: exceptionStack,
          library: 'scheduler library',
          context: ErrorDescription('during a task callback'),
          informationCollector: (callbackStack == null)
              ? null
              : () sync* {
                  yield DiagnosticsStackTrace(
                    '\nThis exception was thrown in the context of a scheduler callback. '
                    'When the scheduler callback was _registered_ (as opposed to when the '
                    'exception was thrown), this was the stack',
                    callbackStack,
                  );
                },
        ));
      }
      return _taskQueue.isNotEmpty;
    }
    return true;
  }

  /// Ensures that the scheduler services a task scheduled by [scheduleTask].
  Future<void> _ensureEventLoopCallback() async {
    assert(_taskQueue.isNotEmpty);
    if (_hasRequestedAnEventLoopCallback) return;
    _hasRequestedAnEventLoopCallback = true;
    Timer.run(() {
      _removeIgnoreTasks();
      _runTasks();
    });
  }

  /// Scheduled by _ensureEventLoopCallback.
  Future<void> _runTasks() async {
    _hasRequestedAnEventLoopCallback = false;
    await SchedulerBinding.instance.endOfFrame;
    if (await handleEventLoopCallback()) {
      await _ensureEventLoopCallback();
    }
  }

  void shuffleTask(bool Function(TaskEntry taskEntry) condition) {
    _taskQueue.removeWhere((TaskEntry e) => condition(e));
  }

  void _removeIgnoreTasks() {
    while (_taskQueue.isNotEmpty) {
      if (!_taskQueue.first.canIgnore()) {
        break;
      }
      _taskQueue.removeFirst();
    }
  }

  Future<T> scheduleTask<T>(
      TaskCallback<T> task, Priority priority, ValueGetter<bool> canIgnore,
      {String? debugLabel, Flow? flow, int? id}) {
    final TaskEntry<T> entry =
        TaskEntry<T>(task, priority.value, canIgnore, debugLabel, flow, id: id);
    _addTask(entry);
    _ensureEventLoopCallback();
    return entry.completer.future;
  }

  void _addTask(TaskEntry _taskEntry) {
    if (maxTaskSize != 0 && _taskQueue.length >= maxTaskSize) {
      logcat('remove Task');
      _taskQueue.removeFirst();
    }
    _taskQueue.add(_taskEntry);
  }

  void resetMaxTaskSize() {
    maxTaskSize = 0;
  }
}

class TaskEntry<T> {
  TaskEntry(
      this.task, this.priority, this.canIgnore, this.debugLabel, this.flow,
      {this.id}) {
    assert(() {
      debugStack = StackTrace.current;
      return true;
    }());
    completer = Completer<T>();
  }

  final TaskCallback<T> task;
  final int priority;
  final String? debugLabel;
  final Flow? flow;
  final int? id;
  final ValueGetter<bool> canIgnore;
  StackTrace? debugStack;
  late Completer<T> completer;

  void run() {
    if (!kReleaseMode) {
      Timeline.timeSync(
        debugLabel ?? 'Scheduled Task',
        () {
          completer.complete(task());
        },
        flow: flow != null ? Flow.step(flow!.id) : null,
      );
    } else {
      completer.complete(task());
    }
  }
}
