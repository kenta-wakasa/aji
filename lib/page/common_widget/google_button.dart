import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../provider/providers.dart';

class GoogleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(authProvider);
    return SizedBox(
      height: 48,
      width: 240,
      child: ElevatedButton(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SvgPicture.asset('images/btn_google_light_normal_ios.svg'),
            const Text('Login with Google    '),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // background
          onPrimary: Colors.black, // foreground
          textStyle: Theme.of(context).textTheme.button,
        ),
        onPressed: () async {
          await provider.signInWithGoogle();
        },
      ),
    );
  }
}
