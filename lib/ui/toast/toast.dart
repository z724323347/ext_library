import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'taost_anim_ctrl.dart';
import 'toast_loading.dart';
import 'toast_notify.dart';
import 'toast_text.dart';

const Duration _duration = Duration(seconds: 2);
const Duration _notificationDuration = Duration(seconds: 3);
const Duration _animationDuration = Duration(milliseconds: 300);

typedef AppToastBuilder = Widget Function(VoidCallback cancelFunc);

TransitionBuilder toastInit() => BotToastInit();
typedef AppToastNavigatorObserver = BotToastNavigatorObserver;

class AppToast {
  static VoidCallback Function(
    String? text, {
    AlignmentGeometry alignment,
    bool crossPage,
    bool clickClose,
    Color backgroundColor,
    Duration duration,
    VoidCallback? onClose,
  }) get show => showText;

  static VoidCallback showText(
    String? text, {
    IconData? icon,
    AlignmentGeometry? alignment,
    bool crossPage = true,
    bool clickClose = false,
    bool ignoreContentClick = false,
    Color backgroundColor = Colors.transparent,
    Duration duration = _duration,
    VoidCallback? onClose,
  }) {
    if (text == null || text == '') {
      return () {};
    }
    return showWidget(
      ToastText(icon: icon, text: text),
      alignment: alignment,
      crossPage: crossPage,
      clickClose: clickClose,
      ignoreContentClick: ignoreContentClick,
      backgroundColor: backgroundColor,
      duration: duration,
      onClose: onClose,
    );
  }

  static VoidCallback showSuccess(
    String? text, {
    IconData? icon,
    AlignmentGeometry? alignment,
  }) {
    return showText(
      text,
      icon: icon ?? Icons.check_circle_outline,
      alignment: alignment,
    );
  }

  static VoidCallback showFailure(
    String? text, {
    IconData? icon,
    AlignmentGeometry? alignment,
  }) {
    return showText(
      text,
      icon: icon ?? Icons.highlight_off,
      alignment: alignment,
    );
  }

  static VoidCallback showInfo(
    String? text, {
    IconData? icon,
    AlignmentGeometry? alignment,
  }) {
    return showText(
      text,
      icon: icon ?? Icons.info_outline,
      alignment: alignment,
    );
  }

  static VoidCallback showWidget(
    Widget child, {
    AlignmentGeometry? alignment,
    bool crossPage = true,
    bool clickClose = false,
    bool ignoreContentClick = false,
    Color backgroundColor = Colors.transparent,
    Duration duration = _duration,
    VoidCallback? onClose,
  }) {
    return BotToast.showAnimationWidget(
      toastBuilder: (CancelFunc cancelFunc) {
        return SafeArea(
          child: Align(
            alignment: alignment ?? Alignment.center,
            child: child,
          ),
        );
      },
      animationDuration: _animationDuration,
      wrapToastAnimation: (AnimationController controller,
          CancelFunc cancelFunc, Widget child) {
        return ProvideAnimationController(
          curve: Curves.decelerate,
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(opacity: value, child: child);
          },
          child: child,
        );
      },
      onClose: onClose,
      crossPage: crossPage,
      clickClose: clickClose,
      ignoreContentClick: ignoreContentClick,
      backgroundColor: backgroundColor,
      duration: duration,
    );
  }

  static VoidCallback showLoading({
    String? text,
    ValueListenable<String>? textListenable,
    BackButtonBehavior backButtonBehavior = BackButtonBehavior.ignore,
    bool crossPage = false,
    bool clickClose = false,
    Color backgroundColor = Colors.transparent,
  }) {
    return BotToast.showCustomLoading(
      toastBuilder: (CancelFunc cancelFunc) {
        return ToastLoading(
          text,
          textListenable: textListenable,
        );
      },
      clickClose: clickClose,
      ignoreContentClick: true,
      crossPage: crossPage,
      backgroundColor: backgroundColor,
    );
  }

  static VoidCallback showNotification({
    Widget? title,
    Widget? subtitle,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Duration? duration = _notificationDuration,
    VoidCallback? onClose,
    bool enableSlideOff = true,
    bool crossPage = true,
  }) {
    return showCustomNotification(
      builder: (CancelFunc cancelFunc) {
        return ToastNotification(
          title: title,
          subtitle: subtitle,
          onTap: onTap,
          onLongPress: onLongPress,
          onCancel: cancelFunc,
        );
      },
      duration: duration,
      onClose: onClose,
      enableSlideOff: enableSlideOff,
      crossPage: crossPage,
    );
  }

  static VoidCallback showCustomNotification({
    required ToastBuilder builder,
    Duration? duration = _notificationDuration,
    VoidCallback? onClose,
    bool enableSlideOff = true,
    bool crossPage = true,
  }) {
    return BotToast.showCustomNotification(
      toastBuilder: builder,
      dismissDirections: const <DismissDirection>[DismissDirection.up],
      duration: duration,
      onClose: onClose,
      enableSlideOff: enableSlideOff,
      crossPage: crossPage,
    );
  }

  static void cleanAll() => BotToast.cleanAll();

  static void closeAllLoading() => BotToast.closeAllLoading();
}
