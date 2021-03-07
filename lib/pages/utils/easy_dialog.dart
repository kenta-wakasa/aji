import 'package:flutter/material.dart';

class EasyDialog extends StatelessWidget {
  const EasyDialog._({required this.title, required this.content});
  final Widget title;
  final Widget content;

  static Future<bool?> show({
    required BuildContext context,
    required Widget title,
    required Widget content,
  }) async {
    final ret = await showDialog<bool>(
      context: context,
      builder: (context) => EasyDialog._(title: title, content: content),
    );
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      title: title,
      content: content,
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
