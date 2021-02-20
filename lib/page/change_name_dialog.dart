import 'package:flutter/material.dart';

class ChangeNameDialog extends StatelessWidget {
  const ChangeNameDialog._({Key key, @required this.name}) : super(key: key);
  final String name;
  static Future<String> showDialog(BuildContext context, String name) async {
    final res = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ChangeNameDialog._(name: name),
      ),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '名前を変更する',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Center(
        child: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
          onSubmitted: (value) {
            nav.pop(value);
          },
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ),
    );
  }
}
