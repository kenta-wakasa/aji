import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void dispose() {
    _sub.cancel();
    PostsRepository.instance.subscriptionCancel();
    super.dispose();
  }

  List<Posts> get postList => PostsRepository.instance.postList;
  late StreamSubscription<QuerySnapshot> _sub;

  Future<void> fetchPosts() async {
    if (loading) {
      return;
    }
    loading = true;
    await PostsRepository.instance.fetchPosts();
    _sub = PostsRepository.instance.stream!.listen((event) => notifyListeners());
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
}
