import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ホーム画面',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
