import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/posts.dart';

final postListProvider = ChangeNotifierProvider<PostListProvider>(
  (ref) => PostListProvider._(),
);

class PostListProvider extends ChangeNotifier {
  PostListProvider._() {
    fetchPosts();
  }

  bool loading = false;
  List<Posts> get postList => PostsRepository.instance.postList;

  @override
  void dispose() {
    PostsRepository.instance.subscriptionCancel();
    super.dispose();
  }

  Future<void> fetchPosts() async {
    if (loading) {
      return;
    }
    loading = true;
    await PostsRepository.instance.fetchPosts();
    loading = false;
    notifyListeners();
  }

  Future<void> fetchNextPosts() async {
    if (loading) {
      return;
    }
    loading = true;
    await PostsRepository.instance.fetchNextPosts();
    loading = false;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
