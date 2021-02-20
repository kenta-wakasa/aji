import 'dart:io';

import 'package:aji/provider/users_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../entity/posts.dart';
import '../entity/users.dart';

final postsProvider = ChangeNotifierProvider.autoDispose<PostsProvider>(
  (ref) => PostsProvider._(ref.watch(usersProvider).users),
);

class PostsProvider extends ChangeNotifier {
  PostsProvider._(this.users);

  final storage = FirebaseStorage.instance;
  final Users users;
  final _picker = ImagePicker();
  File _imageFile;

  File get imageFile => _imageFile;

  Future<String> _pickImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    return pickedFile?.path;
  }

  Future<File> _cropImage(String sourcePath) async {
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: sourcePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 800,
      maxWidth: 800,
      compressQuality: 100,
    );
    return croppedFile;
  }

  Future<void> addImage() async {
    final sourcePath = await _pickImage();
    if (sourcePath == null) {
      return;
    }
    _imageFile = await _cropImage(sourcePath);
    notifyListeners();
  }

  Future<String> _saveImage() async {
    if (users.id == null || _imageFile == null) {
      return null;
    }
    final utc = DateTime.now().toUtc();
    final timeString = utc.toIso8601String().replaceAll(':', '-').split('.')[0];
    final path = 'posts/${users.id}/$timeString.jpg';
    final task = await storage.ref(path).putFile(_imageFile);
    if (task == null) {
      return null;
    }
    final downloadURL = await task.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> addPosts() async {
    final url = await _saveImage();
    final posts = Posts(
      url: url,
      usersId: users.id,
      title: '',
      createdAt: Timestamp.fromDate(DateTime.now()),
    );
    await PostsRepository.instance.addPosts(posts);
  }
}
