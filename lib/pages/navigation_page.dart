import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class NavigationPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(navigationProvider);
    return Scaffold(
      body: provider.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: provider.currentIndex,
        onTap: (index) => provider.currentIndex = index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.face_rounded), label: ''),
        ],
      ),
    );
  }
}
