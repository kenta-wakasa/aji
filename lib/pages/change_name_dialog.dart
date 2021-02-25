import 'package:flutter/material.dart';

class ChangeNameDialog extends StatelessWidget {
  const ChangeNameDialog._({Key key, @required this.name}) : super(key: key);

  final String name;

  static Future<String> showDialog(BuildContext context, String name) async {
    final res = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ChangeNameDialog._(name: name),
      ),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nav = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('名前を変更する'),
      ),
      body: Center(
        child: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          style: textTheme.bodyText1,
          onSubmitted: nav.pop,
          decoration: InputDecoration(hintText: name),
        ),
      ),
    );
  }
}
