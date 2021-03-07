import 'package:flutter/material.dart';

class EasyDialog extends StatelessWidget {
  const EasyDialog._({required this.title, required this.content, required this.actions});
  final Widget title;
  final Widget content;
  final List<Widget>? actions;

  static Future<bool?> show({
    required BuildContext context,
    required Widget title,
    required Widget content,
    required List<Widget>? actions,
  }) async {
    final ret = await showDialog<bool>(
      context: context,
      builder: (context) => EasyDialog._(title: title, content: content, actions: actions),
    );
    return ret;
  }

  static Future<bool?> showAlertAnonymous({
    required BuildContext context,
  }) async {
    const title = Text('ログインが必要です');
    const content = SizedBox(height: 0);
    final ret = await showDialog<bool>(
      context: context,
      builder: (context) => const EasyDialog._(title: title, content: content, actions: null),
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
      actions: actions,
    );
  }
}
