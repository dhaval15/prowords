import 'package:flutter/material.dart';
import 'package:prowords/src/models/models.dart';

class BookmarkTile extends StatelessWidget {
  final Bookmark bookmark;
  final GestureTapCallback? onTap;

  const BookmarkTile({
    Key? key,
    required this.bookmark,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      title: Text(
        bookmark.text,
        textAlign: TextAlign.justify,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          bookmark.title,
          textAlign: TextAlign.justify,
        ),
      ),
      onTap: onTap,
    );
  }
}
