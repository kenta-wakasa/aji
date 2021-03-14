import 'package:aji/pages/utils/google_button.dart';
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
    const title = Text('この機能を使うにはログインが必要です');
    final content = GoogleButton();
    final actions = <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('OK'),
      ),
    ];
    final ret = await showDialog<bool>(
      context: context,
      builder: (context) => EasyDialog._(title: title, content: content, actions: actions),
    );
    return ret;
  }

  static void showIsSending({
    required BuildContext context,
  }) {
    const title = Text('投稿中...');
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(),
        ),
      ],
    );

    final actions = [Container()];
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => EasyDialog._(title: title, content: content, actions: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      titleTextStyle: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),
      title: title,
      content: content,
      actions: actions,
    );
  }
}
