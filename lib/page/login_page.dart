import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common_widget/google_button.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width,
            height: height * 4 / 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      'AJI-BAN',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: GoogleButton(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
