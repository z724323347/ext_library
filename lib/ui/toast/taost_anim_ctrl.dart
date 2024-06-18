import 'package:flutter/material.dart';

class ProvideAnimationController extends StatefulWidget {
  const ProvideAnimationController({
    Key? key,
    this.value = 0.0,
    this.target = 1.0,
    this.duration = const Duration(seconds: 1),
    this.debugLabel,
    this.animationBehavior = AnimationBehavior.normal,
    this.curve = Curves.linear,
    required this.builder,
    this.child,
  }) : super(key: key);

  final double value;
  final double target;

  final Duration duration;
  final String? debugLabel;
  final AnimationBehavior animationBehavior;

  final Curve curve;

  final ValueWidgetBuilder<double> builder;
  final Widget? child;

  @override
  State<ProvideAnimationController> createState() =>
      ProvideAnimationControllerState();
}

class ProvideAnimationControllerState extends State<ProvideAnimationController>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _configureController();
    _animateToTarget();
  }

  @override
  void didUpdateWidget(covariant ProvideAnimationController oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool shouldUpdateController = widget.value != oldWidget.value ||
        widget.target != oldWidget.target ||
        widget.duration != oldWidget.duration ||
        widget.debugLabel != oldWidget.debugLabel ||
        widget.animationBehavior != oldWidget.animationBehavior ||
        widget.curve != oldWidget.curve;

    if (shouldUpdateController) {
      _controller.dispose();
      _configureController();
      _animateToTarget();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildChild,
      child: widget.child,
    );
  }

  Widget _buildChild(BuildContext context, Widget? child) {
    return widget.builder(context, _controller.value, child);
  }

  void _configureController() {
    _controller = AnimationController(
      value: widget.value,
      debugLabel: widget.debugLabel,
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
      animationBehavior: widget.animationBehavior,
      vsync: this,
    );
  }

  TickerFuture _animateToTarget() {
    return _controller.animateTo(
      widget.target,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  TickerFuture replay() {
    _controller.value = widget.value;
    return _animateToTarget();
  }
}
