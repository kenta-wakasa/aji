import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class NavigationPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(navigationProvider);
    return Scaffold(
      body: provider.currentPage,
      bottomNavigationBar: Container(
        height: 88,
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.2,
            style: BorderStyle.solid,
          ),
        )),
        child: BottomNavigationBar(
          iconSize: 24,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: provider.currentIndex,
          onTap: (index) {
            if (index == 0 && index == provider.currentIndex) {
              provider.resetScrollPos();
            }
            provider.currentIndex = index;
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face_rounded),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
