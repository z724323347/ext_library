import 'package:flutter/material.dart';

class ApiMonitor extends StatelessWidget {
  final String? url;
  final String? web;
  const ApiMonitor({Key? key, this.url, this.web}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StringBuffer buffer = StringBuffer()
      ..writeUrls(
        title: 'App domain',
        defaultUrl: url,
      );
    final StringBuffer bufferWeb = StringBuffer()
      ..writeUrls(
        title: 'Web domain',
        defaultUrl: web,
      );

    return Row(
      children: [
        Expanded(child: SelectableText(buffer.toString())),
        Expanded(child: SelectableText(bufferWeb.toString())),
      ],
    );
  }
}

extension _StringBufferExtension on StringBuffer {
  void writeUrls({
    required String title,
    Object? defaultUrl,
    Object? overrideUrl,
    Object? currentUrl,
  }) {
    writeln('$title:');
    if (defaultUrl != null) {
      this
        ..writeln('[Default]')
        ..writeln(defaultUrl);
    }
    if (overrideUrl != null) {
      this
        ..writeln('[Override]')
        ..writeln(overrideUrl);
    }
    if (currentUrl != null) {
      this
        ..writeln('[Current]')
        ..writeln(currentUrl);
    }
  }
}
