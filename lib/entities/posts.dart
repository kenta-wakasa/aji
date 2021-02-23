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

  factory Posts.fromSnapshot(DocumentSnapshot snapshot) {
    return Posts(
      usersId: snapshot.data()['usersId'] as String,
      title: snapshot.data()['title'] as String,
      url: snapshot.data()['url'] as String,
      createdAt: snapshot.data()['createdAt'] as Timestamp,
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
  final _posts = FirebaseFirestore.instance.collection('posts');

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
}
