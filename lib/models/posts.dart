import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'users.dart';

@immutable
class Posts {
  const Posts({
    @required this.title,
    @required this.createdAt,
    @required this.url,
    @required this.users,
  });

  static Future<Posts> fromDoc(DocumentSnapshot doc) async {
    final userId = doc.data()['usersId'] as String;
    return Posts(
      users: await UsersRepository.instance.fetchByUserId(userId),
      title: doc.data()['title'] as String,
      url: doc.data()['url'] as String,
      createdAt: doc.data()['createdAt'] as Timestamp,
    );
  }

  final String title;
  final String url;
  final Users users;
  final Timestamp createdAt;
}

class PostsRepository {
  PostsRepository._();

  static PostsRepository instance = PostsRepository._();
  static const limit = 50;

  final _posts = FirebaseFirestore.instance.collection('posts');

  DocumentSnapshot _lastDoc;
  Stream<QuerySnapshot> _stream;
  StreamSubscription<QuerySnapshot> _subNewPosts;
  List<Posts> _newPostList = <Posts>[];
  List<Posts> _oldPostList = <Posts>[];

  List<Posts> get postList => [..._newPostList, ..._oldPostList];
  Stream<QuerySnapshot> get stream => _stream;

  Future<void> addPosts(Posts posts) async {
    await _posts.add(
      <String, dynamic>{
        'usersId': posts.users.id,
        'title': posts.title,
        'url': posts.url,
        'createdAt': posts.createdAt,
      },
    );
  }

  Future<void> fetchPosts() async {
    final snapshot = await _posts.orderBy('createdAt', descending: true).limit(limit).get();
    _lastDoc = snapshot.docs.last;
    final firstDoc = snapshot.docs.first;
    _stream = _posts.orderBy('createdAt', descending: true).endBeforeDocument(firstDoc).snapshots();
    if (_subNewPosts != null) {
      await _subNewPosts.cancel();
    }
    _subNewPosts = _stream.listen(
      (snapShot) async {
        final futureList = snapShot.docs.map(Posts.fromDoc).toList();
        _newPostList = await Future.wait(futureList);
      },
    );
    final futureList = snapshot.docs.map(Posts.fromDoc).toList();
    _oldPostList = await Future.wait(futureList);
  }

  Future<bool> fetchNextPosts() async {
    assert(_lastDoc != null);
    final snapshot = await _posts
        .orderBy(
          'createdAt',
          descending: true,
        )
        .startAfterDocument(_lastDoc)
        .limit(limit)
        .get();
    if (snapshot.docs.isEmpty) {
      return false;
    }
    _lastDoc = snapshot.docs.last;
    _oldPostList.addAll(
      await Future.wait(snapshot.docs.map(Posts.fromDoc).toList()),
    );
    return true;
  }

  Future<void> subscriptionCancel() async {
    await _subNewPosts.cancel();
  }
}
