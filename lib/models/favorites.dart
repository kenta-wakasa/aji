import 'package:aji/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favorites {
  Favorites({
    required this.users,
    required this.createdAt,
  });

  static Future<Favorites> fromDoc(DocumentSnapshot doc) async {
    final userId = doc.data()!['usersId'] as String;
    return Favorites(
      users: await UsersRepository.instance.fetchByUserId(userId),
      createdAt: doc.data()!['createdAt'] as Timestamp,
    );
  }

  final Users users;
  final Timestamp createdAt;

  Future<void> addToFirebase(CollectionReference ref) async {
    await ref.add(
      <String, dynamic>{
        'createdAt': createdAt,
        'usersId': users.id,
      },
    );
  }
}
