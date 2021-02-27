import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class Users {
  const Users._({
    @required this.id,
    @required this.name,
    @required this.createdAt,
    @required this.avatarUrl,
  });
  factory Users.fromDoc({@required DocumentSnapshot doc}) {
    return Users._(
      id: doc.id,
      name: doc.data()['name'] as String,
      createdAt: doc.data()['createdAt'] as Timestamp,
      avatarUrl: doc.data()['avatarUrl'] as String,
    );
  }

  factory Users.anonymous() {
    return Users._(
      id: null,
      name: 'ゲスト',
      createdAt: Timestamp.fromDate(DateTime.now()),
      avatarUrl:
          'https://firebasestorage.googleapis.com/v0/b/aji-dev.appspot.com/o/assets%2Fdefault_avator.png?alt=media&token=eab9105b-08da-48e7-bfd6-b51eabad0856',
    );
  }

  factory Users.fromUser(User user) {
    return Users._(
      id: user.uid,
      name: user.displayName,
      createdAt: Timestamp.now(),
      avatarUrl: user.photoURL,
    );
  }

  final String id;
  final String name;
  final Timestamp createdAt;
  final String avatarUrl;

  Future<Users> updateName(String name) async {
    final users = copyWith(name: name);
    await UsersRepository.instance.updateUsers(users);
    return users;
  }

  Users copyWith({
    String id,
    String name,
    Timestamp createdAt,
    String avatarUrl,
  }) =>
      Users._(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}

class UsersRepository {
  UsersRepository._();
  static UsersRepository instance = UsersRepository._();
  final _users = FirebaseFirestore.instance.collection('users');

  Future<Users> fetchByUserId(String userId) async {
    final doc = await _users.doc(userId).get();
    return Users.fromDoc(doc: doc);
  }

  Future<List<Users>> fetchAllUsers() async {
    final query = await _users.get();
    return query.docs.map((doc) => Users.fromDoc(doc: doc)).toList();
  }

  Future<void> addUsers(Users users) async {
    final snapshot = await _users.doc(users.id).get();
    if (!snapshot.exists) {
      await _users.doc(users.id).set(
        <String, dynamic>{
          'name': users.name,
          'createdAt': users.createdAt,
          'avatarUrl': users.avatarUrl,
        },
      );
    }
  }

  Future<void> updateUsers(Users users) async {
    await _users.doc(users.id).update(
      <String, dynamic>{
        'name': users.name,
        'createdAt': users.createdAt,
        'avatarUrl': users.avatarUrl,
      },
    );
  }
}
