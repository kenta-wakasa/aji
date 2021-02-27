import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/my_page.dart';
import '../pages/post_list_page.dart';

final navigationProvider = ChangeNotifierProvider<NavigationProvider>(
  (ref) => NavigationProvider._(),
);

class NavigationProvider extends ChangeNotifier {
  NavigationProvider._() {
    _currentIndex = 0;
    _pageList = <Widget>[PostListPage(), MyPage()];
  }

  List<Widget> _pageList;
  int _currentIndex;

  int get currentIndex => _currentIndex;
  Widget get currentPage => _pageList[currentIndex];

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
