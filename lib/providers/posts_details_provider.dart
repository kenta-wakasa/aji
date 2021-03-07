import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favorites.dart';
import '../models/posts.dart';
import '../models/users.dart';
import '../providers/users_provider.dart';

final postsDetailsProvider = ChangeNotifierProvider.family.autoDispose<PostsDetailsProvider, Posts>(
  (ref, posts) => PostsDetailsProvider._(
    posts: posts,
    users: ref.watch(usersProvider).users,
  ),
);

class PostsDetailsProvider extends ChangeNotifier {
  PostsDetailsProvider._({required this.posts, required this.users});
  final Posts posts;
  final Users users;

  int get favoritesCount => posts.favorites.length;
  bool get isFavorite => posts.favorites.where((e) => e.users == users).isNotEmpty;

  Future<void> _addFavorites() async {
    final favorites = Favorites(users: users, createdAt: Timestamp.now());
    posts.favorites.add(favorites);
    await favorites.addToFirebase(posts.docReference!.collection('favorites'));
  }

  Future<void> _removeFavorites() async {
    posts.favorites.removeWhere((e) => e.users == users);
    final snap = await posts.docReference!.collection('favorites').where('usersId', isEqualTo: users.id).get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> switchFavorites() async {
    if (isFavorite) {
      await _removeFavorites();
    } else {
      await _addFavorites();
    }
    notifyListeners();
  }
}
