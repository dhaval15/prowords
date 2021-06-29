import 'dart:async';

import 'package:flutter/material.dart';
import '../api/api.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class AddBookmarkPage extends StatefulWidget {
  final Bookmark bookmark;
  final ScrollController? controller;

  const AddBookmarkPage({
    required this.bookmark,
    this.controller,
  });

  @override
  _AddBookmarkPageState createState() => _AddBookmarkPageState();
}

class _AddBookmarkPageState extends State<AddBookmarkPage> {
  late Bookmark bookmark;
  late StreamController<int> _controller;

  @override
  void initState() {
    super.initState();
    bookmark = widget.bookmark;
    _controller = StreamController();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void add() async {
    await Providers.of<BookmarksApi>(context).insertBookmark(bookmark);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          controller: widget.controller,
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              'Save',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
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
            TagField(
              tags: bookmark.tags.toSet(),
              onChanged: (tags) {
                bookmark = bookmark.copyWith(tags: tags.toList());
                _controller.add(tags.length);
              },
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<int>(
        stream: _controller.stream,
        initialData: bookmark.tags.length,
        builder: (context, snapshot) {
          return snapshot.data! > 0
              ? FloatingActionButton(
                  onPressed: add,
                  child: Icon(Icons.done),
                )
              : SizedBox();
        },
      ),
    );
  }
}
