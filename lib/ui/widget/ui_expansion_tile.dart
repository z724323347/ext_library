// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.trailingExt,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.isShowChildrenBorder = true,
    this.tileHeight,
  })  : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline is not supported since the expanded children '
          'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  final Widget? leading;

  final Widget title;

  final Widget? subtitle;

  final ValueChanged<bool>? onExpansionChanged;

  final List<Widget> children;

  final Color? backgroundColor;

  final Color? collapsedBackgroundColor;

  final Widget? trailing;

  final Widget? trailingExt;

  final bool initiallyExpanded;

  final bool maintainState;

  final EdgeInsetsGeometry? tilePadding;

  final Alignment? expandedAlignment;

  final CrossAxisAlignment? expandedCrossAxisAlignment;

  final EdgeInsetsGeometry? childrenPadding;

  final Color? iconColor;

  final Color? collapsedIconColor;

  final Color? textColor;

  final Color? collapsedTextColor;
  final bool isShowChildrenBorder;
  final double? tileHeight;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        border: widget.isShowChildrenBorder
            ? Border(bottom: BorderSide(color: borderSideColor))
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: widget.tileHeight,
            child: ListTileTheme.merge(
              iconColor: _iconColor.value,
              textColor: _headerColor.value,
              child: ListTile(
                onTap: _handleTap,
                contentPadding: widget.tilePadding,
                leading: widget.leading,
                title: widget.title,
                subtitle: widget.subtitle,
                trailing: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.trailingExt ?? Container(),
                      RotationTransition(
                        turns: _iconTurns,
                        child: widget.trailing ??
                            RotatedBox(
                              quarterTurns: -1,
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? theme.textTheme.bodySmall!.color
      ..end = widget.textColor ?? colorScheme.secondary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? colorScheme.secondary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final closed = !_isExpanded && _controller.isDismissed;
    final shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment:
                widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
