import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Posts {
  const Posts({
    @required this.usersId,
    @required this.title,
    @required this.createdAt,
    @required this.url,
  });

  factory Posts.fromDoc({@required DocumentSnapshot doc}) {
    return Posts(
      usersId: doc.data()['usersId'] as String,
      title: doc.data()['title'] as String,
      url: doc.data()['url'] as String,
      createdAt: doc.data()['createdAt'] as Timestamp,
    );
  }

  final String usersId;
  final String title;
  final String url;
  final Timestamp createdAt;

  Posts copyWith({
    String usersId,
    String title,
    String url,
    Timestamp createdAt,
  }) =>
      Posts(
        usersId: usersId ?? this.usersId,
        title: title ?? this.title,
        url: url ?? this.url,
        createdAt: createdAt ?? this.createdAt,
      );
}

class PostsRepository {
  PostsRepository._();

  static PostsRepository instance = PostsRepository._();
  static const limit = 3;

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
        'usersId': posts.usersId,
        'title': posts.title,
        'url': posts.url,
        'createdAt': posts.createdAt,
      },
    );
  }

  Future<void> fetchPosts() async {
    final snapshot =
        await _posts.orderBy('createdAt', descending: true).limit(limit).get();
    _lastDoc = snapshot.docs.last;
    final firstDoc = snapshot.docs.first;
    _stream = _posts
        .orderBy('createdAt', descending: true)
        .endBeforeDocument(firstDoc)
        .snapshots();
    if (_subNewPosts != null) {
      await _subNewPosts.cancel();
    }
    _subNewPosts = _stream.listen(
      (snapShot) => _newPostList =
          snapShot.docs.map((doc) => Posts.fromDoc(doc: doc)).toList(),
    );
    _oldPostList = snapshot.docs.map((doc) => Posts.fromDoc(doc: doc)).toList();
  }

  Future<bool> fetchNextPosts() async {
    assert(_lastDoc != null);
    try {
      final snapshot = await _posts
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_lastDoc)
          .limit(limit)
          .get();
      if (snapshot.docs.isEmpty) {
        return false;
      }
      _lastDoc = snapshot.docs.last;
      _oldPostList.addAll(
        snapshot.docs
            .map(
              (doc) => Posts.fromDoc(doc: doc),
            )
            .toList(),
      );
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> subscriptionCancel() async {
    await _subNewPosts.cancel();
  }
}
