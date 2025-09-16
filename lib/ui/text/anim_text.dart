import 'package:flutter/material.dart';

/// Adds fading effect on each character in the [text] provided to it.
///
class FadingText extends StatefulWidget {
  /// Text to animate
  final String text;

  final TextStyle? style;

  /// [text] must not be null.
  const FadingText(this.text, {super.key, this.style});

  @override
  _FadingTextState createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText> with TickerProviderStateMixin {
  final _characters = <MapEntry<String, Animation<double>>>[];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    var start = 0.2;
    final duration = 0.6 / widget.text.length;
    widget.text.runes.forEach((int rune) {
      final character = String.fromCharCode(rune);
      final animation = Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          curve: Interval(start, start + duration, curve: Curves.easeInOut),
          parent: _controller,
        ),
      );
      _characters.add(MapEntry(character, animation));
      start += duration;
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _characters
          .map(
            (entry) => FadeTransition(
              opacity: entry.value,
              child: Text(entry.key, style: widget.style),
            ),
          )
          .toList(),
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Adds jumping effect on each character in the [text] provided to it.
class TextAnim extends StatelessWidget {
  final String? text;
  // final Offset begin;
  final Offset end;
  final TextStyle? style;
  final List<Widget>? children;
  TextAnim({
    this.text,
    // this.begin = const Offset(0.0, 0.0),
    this.end = const Offset(0.0, -0.5),
    this.style,
    this.children,
    super.key,
  });

  /// Creates a jumping text widget.
  TextAnim.jump(
    this.text, {
    super.key,
    this.end = const Offset(0.0, -0.5),
    this.style,
    this.children,
  });

  /// Creates a jumping custom widget.
  TextAnim.custom(
    this.children, {
    super.key,
    this.end = const Offset(0.0, -0.5),
    this.style,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    if (children != null && children!.isNotEmpty) {
      return _CollectionSlideTransition(end: end, children: children!);
    }
    return _CollectionSlideTransition(
      end: end,
      children: text!.runes
          .map((rune) => Text(String.fromCharCode(rune), style: style))
          .toList(),
    );
  }
}

/// Adds jumping effect on each character in the [text] provided to it.
class ScalingText extends StatelessWidget {
  /// The text to add scaling effect to.
  final String text;
  final double begin = 1.0;
  final double end;
  final TextStyle? style;

  /// Creates a jumping text widget.
  const ScalingText(this.text, {super.key, this.end = 2.0, this.style});

  @override
  Widget build(BuildContext context) {
    return _CollectionScaleTransition(
      end: end,
      children: text.runes
          .map((rune) => Text(String.fromCharCode(rune), style: style))
          .toList(),
    );
  }
}

/// Adds a reversable and repetitive slide transition to each child.

class _CollectionSlideTransition extends StatefulWidget {
  /// Collection of widgets on which slide animation is applied.
  ///
  /// Preferably, [Text], [Icon] or [Image] should be used.
  final List<Widget> children;

  final Offset end;

  final Offset begin = Offset.zero;

  final bool repeat = true;

  /// Creates transiton widget.
  ///
  /// [children] is requied and must not be null.
  /// [end] property has default displacement of -1.0 in vertical direction.
  const _CollectionSlideTransition({
    required this.children,
    this.end = const Offset(0.0, -1.0),
  });

  @override
  _CollectionSlideTransitionState createState() =>
      _CollectionSlideTransitionState();
}

class _CollectionSlideTransitionState extends State<_CollectionSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_WidgetAnimations<Offset>> _widgets = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (widget.children.length * 0.25).round()),
    );

    _widgets = _WidgetAnimations.createList<Offset>(
      widgets: widget.children,
      controller: _controller,
      forwardCurve: Curves.ease,
      reverseCurve: Curves.ease,
      begin: widget.begin,
      end: widget.end,
    );

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final end = widget.end;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _widgets.map(
        (widgetAnimation) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return FractionalTranslation(
                translation: widgetAnimation.forward.value.distanceSquared >=
                        end.distanceSquared
                    ? widgetAnimation.reverse.value
                    : widgetAnimation.forward.value,
                child: widgetAnimation.widget,
              );
            },
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Adds a reversable and repetitive scale transition to each child.
class _CollectionScaleTransition extends StatefulWidget {
  /// Collection of widgets on which slide animation is applied.
  ///
  /// Preferably, [Text], [Icon] or [Image] should be used.
  final List<Widget> children;

  /// End scale of each child.
  final double end;

  /// Start scale of each child.
  final double begin = 1.0;

  /// The toggle to make the animation repeating or non-repeating.
  final bool repeat;

  /// Creates transiton widget.
  ///
  /// [children] is requied and must not be null.
  /// [end] property has default value of 2.0.
  const _CollectionScaleTransition({
    super.key,
    required this.children,
    this.end = 2.0,
    this.repeat = true,
  });

  @override
  _CollectionScaleTransitionState createState() =>
      _CollectionScaleTransitionState();
}

class _CollectionScaleTransitionState extends State<_CollectionScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_WidgetAnimations<double>> _widgets = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (widget.children.length * 0.25).round()),
    );

    _widgets = _WidgetAnimations.createList<double>(
      widgets: widget.children,
      controller: _controller,
      forwardCurve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
      begin: widget.begin,
      end: widget.end,
    );

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final end = widget.end;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _widgets.map(
        (widgetAnimation) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.scale(
                scale: widgetAnimation.forward.value >= end
                    ? widgetAnimation.reverse.value
                    : widgetAnimation.forward.value,
                child: widgetAnimation.widget,
              );
            },
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _WidgetAnimations<T> {
  final Widget widget;
  final Animation<T> forward;
  final Animation<T> reverse;

  _WidgetAnimations({
    required this.widget,
    required this.forward,
    required this.reverse,
  });

  static List<_WidgetAnimations<S>> createList<S>({
    required List<Widget> widgets,
    required AnimationController controller,
    Cubic forwardCurve = Curves.ease,
    Cubic reverseCurve = Curves.ease,
    S? begin,
    S? end,
  }) {
    final animations = <_WidgetAnimations<S>>[];

    var start = 0.0;
    final duration = 1.0 / (widgets.length * 2);
    for (final childWidget in widgets) {
      final animation = Tween<S>(
        begin: begin,
        end: end,
      ).animate(
        CurvedAnimation(
          curve: Interval(start, start + duration, curve: Curves.ease),
          parent: controller,
        ),
      );

      final revAnimation = Tween<S>(
        begin: end,
        end: begin,
      ).animate(
        CurvedAnimation(
          curve: Interval(start + duration, start + duration * 2,
              curve: Curves.ease),
          parent: controller,
        ),
      );

      animations.add(_WidgetAnimations(
        widget: childWidget,
        forward: animation,
        reverse: revAnimation,
      ));

      start += duration;
    }

    return animations;
  }
}
