import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class Users {
  const Users._({
    @required this.id,
    @required this.name,
    @required this.createdAt,
  });
  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    return Users._(
      id: snapshot.id,
      name: snapshot.data()['name'] as String,
      createdAt: snapshot.data()['createdAt'] as Timestamp,
    );
  }

  factory Users.anonymous() {
    return Users._(
      id: null,
      name: 'ゲスト',
      createdAt: Timestamp.fromDate(DateTime.now()),
    );
  }

  factory Users.fromUser(User user) {
    return Users._(
      id: user.uid,
      name: user.displayName,
      createdAt: Timestamp.fromDate(DateTime.now()),
    );
  }

  final String id;
  final String name;
  final Timestamp createdAt;

  Future<Users> updateName(String name) async {
    final users = copyWith(name: name);
    await UsersRepository.instance.updateUsers(users);
    return users;
  }

  Users copyWith({
    String id,
    String name,
    Timestamp createdAt,
  }) =>
      Users._(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
}

class UsersRepository {
  UsersRepository._();
  static UsersRepository instance = UsersRepository._();
  final _users = FirebaseFirestore.instance.collection('users');

  Future<Users> fetchByUserId(String userId) async {
    final snapshot = await _users.doc(userId).get();
    return Users.fromSnapshot(snapshot);
  }

  Future<List<Users>> fetchAllUsers() async {
    final query = await _users.get();
    return query.docs.map((snapshot) => Users.fromSnapshot(snapshot)).toList();
  }

  Future<void> addUsers(Users users) async {
    final snapshot = await _users.doc(users.id).get();
    if (!snapshot.exists) {
      await _users.doc(users.id).set(
        <String, dynamic>{
          'name': users.name,
          'createdAt': users.createdAt,
        },
      );
    }
  }

  Future<void> updateUsers(Users users) async {
    await _users.doc(users.id).update(
      <String, dynamic>{
        'name': users.name,
        'createdAt': users.createdAt,
      },
    );
  }
}
