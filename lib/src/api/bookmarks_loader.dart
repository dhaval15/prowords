import 'package:prowords/src/api/bookmarks_api.dart';

import '../models/models.dart';

import 'populator.dart';

class BookmarksLoader {
  final Populater<List<Bookmark>> _bookmarks;
  final BookmarksApi _api;

  BookmarksLoader(BookmarksApi api)
      : this._api = api,
        _bookmarks = Populater<List<Bookmark>>(
          onPopulate: () => api.all(),
          data: [],
        );

  Stream<List<Bookmark>> get bookmarks => _bookmarks.stream;

  void dispose() {
    _bookmarks.dispose();
  }

  Future insert(Bookmark bookmark) async {
    final id = await _api.insertBookmark(bookmark);
    final newBookmark = bookmark.copyWith(id: id);
    _bookmarks.modify((data) {
      data.insert(0, newBookmark);
    });
  }

  Future delete(int index, Bookmark bookmark) async {
    await _api.deleteBookmark(bookmark);
    _bookmarks.modify((data) {
      data.removeAt(index);
    });
  }
}
