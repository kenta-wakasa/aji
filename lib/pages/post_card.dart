import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/posts.dart';

class PostCard extends ConsumerWidget {
  const PostCard({@required this.posts});
  final Posts posts;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size.width - 32;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: size,
                  width: size,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: size - 16,
                  width: size - 16,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/logo.png',
                    image: posts.url,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundImage: NetworkImage(
                      posts.users.avatarUrl,
                    ),
                  ),
                  Text(posts.title, style: Theme.of(context).textTheme.headline6),
                  IconButton(
                    icon: const Icon(Icons.favorite_border_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
