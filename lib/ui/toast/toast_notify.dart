import 'package:ext_library/tool/extensions/iterable_ext.dart';
import 'package:flutter/material.dart';

class ToastNotification extends StatelessWidget {
  const ToastNotification({
    Key? key,
    this.title,
    this.subtitle,
    this.onTap,
    this.onLongPress,
    this.onCancel,
  }) : super(key: key);

  final Widget? title;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(10));

    return Container(
      decoration: const BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(1, 3.5),
            blurRadius: 10,
          ),
        ],
      ),
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Stack(
            children: <Widget>[
              _buildTitles(context),
              Align(
                alignment: Alignment.topRight,
                heightFactor: 1,
                child: _buildCloseButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitles(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null)
            DefaultTextStyle.merge(
              style: themeData.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 22.5 / 16,
              ),
              child: title!,
            ),
          if (subtitle != null)
            DefaultTextStyle.merge(
              style: themeData.textTheme.titleSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                height: 22 / 16.5,
              ),
              child: subtitle!,
            ),
        ].divide(const SizedBox(height: 8)),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: onCancel,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Icon(
          Icons.close,
          size: 14,
          color: Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
