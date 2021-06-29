import 'package:flutter/material.dart';
import 'package:frooti/frooti.dart';
import 'package:prowords/src/pages/pages.dart';
import '../api/api.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late BookmarksLoader loader;
  @override
  void initState() {
    super.initState();
    loader = BookmarksLoader(Providers.of<BookmarksApi>(context));
  }

  void showBookmark(Bookmark bookmark) {
    Pages.showBookmark(context, bookmark: bookmark);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.onBackground.withOpacity(0.04);
    return Scaffold(
      appBar: AppBar(
        leading: DrawerIcon(),
        title: Text('Bookmarks'),
      ),
      body: SafeArea(
        child: StreamListBuilder<Bookmark>(
          padding: const EdgeInsets.all(8),
          stream: loader.bookmarks,
          builder: (context, bookmark, index) => Container(
            color: bg,
            padding: const EdgeInsets.only(bottom: 8),
            child: BookmarkTile(
              bookmark: bookmark,
              onTap: () => showBookmark(bookmark),
            ),
          ),
        ),
      ),
    );
  }
}
