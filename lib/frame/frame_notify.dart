import 'package:flutter/material.dart';

class LayoutInfoNotification extends Notification {
  LayoutInfoNotification(this.index, this.size);

  final Size size;
  final int? index;
}
