import 'package:flutter/material.dart';

extension TextEditingControllerExt on TextEditingController {
  void input(String data) {
    if (this == null) {
      return;
    }
    if (text.isNotEmpty) {
      clear();
    }
    selection = selection;
    String newText;
    TextSelection newSelection;

    if (selection.isValid) {
      final start = selection.start;
      newText = text.replaceRange(start, selection.end, data);
      newSelection = TextSelection.collapsed(offset: start + data.length);
    } else {
      newText = text + data;
      newSelection = TextSelection.collapsed(offset: newText.length);
    }

    value = value.copyWith(
      text: newText,
      selection: newSelection,
    );
  }

  void deleteSelection(TextSelection selection) {
    if (!selection.isValid) {
      return;
    }

    int start, end;
    if (selection.start <= 0) {
      return;
    } else if (selection.isCollapsed) {
      start = selection.end - 1;
      end = selection.end;
    } else if (selection.isNormalized) {
      start = selection.start;
      end = selection.end;
    } else {
      start = selection.end;
      end = selection.start;
    }

    deleteRange(start, end);
  }

  void deleteRange(int start, int end) {
    final newText = text.replaceRange(start, end, '');
    value = newText.isEmpty
        ? TextEditingValue.empty
        : TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: start),
          );
  }

  void backspace() {
    if (text.isEmpty) {
      return;
    }

    final selection = this.selection;
    if (selection.isValid) {
      deleteSelection(selection);
    } else {
      final start = text.length - 1;
      final end = text.length;
      deleteRange(start, end);
    }
  }
}

class ChangeTextEditingController extends TextEditingController {
  var completeText = '';

  ChangeTextEditingController.fromValue(TextEditingValue value)
      : super.fromValue(value);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (!value.composing.isValid || !withComposing) {
      if (completeText != value.text) {
        completeText = value.text;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
      return TextSpan(style: style, text: text);
    }

    final TextStyle composingStyle = style!.merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    return TextSpan(style: style, children: <TextSpan>[
      TextSpan(text: value.composing.textBefore(value.text)),
      TextSpan(
        style: composingStyle,
        text: value.composing.isValid && !value.composing.isCollapsed
            ? value.composing.textInside(value.text)
            : '',
      ),
      TextSpan(text: value.composing.textAfter(value.text)),
    ]);
  }
}
