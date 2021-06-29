import 'package:flutter/material.dart';
import 'package:prowords/src/api/library_api.dart';
import 'package:prowords/src/api/providers.dart';
import 'package:prowords/src/screens/screens.dart';
import 'package:prowords/src/styles/styles.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class BookmarkPage extends StatelessWidget {
  final Bookmark bookmark;
  final ScrollController? controller;

  const BookmarkPage({
    required this.bookmark,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.all(16),
      physics: BouncingScrollPhysics(),
      children: [
        Text(
          bookmark.text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'From Book',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bookmark.title,
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w300,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TagsView(
          tags: bookmark.tags,
          forground: Scheme.of(context).onBackground.withOpacity(0.1),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () async {
              final book = await Providers.of<LibraryApi>(context)
                  .fetchBook(bookmark.bookId);
              Navigator.of(context)
                  .pushNamed(Screens.EPUB, arguments: {#book: book});
            },
            child: Text('Open Book'),
          ),
        ),
      ],
    );
  }
}
