import 'package:flutter/material.dart';

class CheckListTile extends StatelessWidget {
  const CheckListTile({
    Key? key,
    required this.title,
    required this.child,
    this.action,
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SelectableText(title, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            action ?? Container()
          ]),
          const SizedBox(height: 5),
          DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.grey),
            child: child,
          ),
        ],
      ),
    );
  }
}
