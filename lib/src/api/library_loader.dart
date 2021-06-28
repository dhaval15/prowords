import 'api.dart';
import '../models/models.dart';

import 'populator.dart';

class LibraryLoader {
  final Populater<List<BookData>> _books;
  final LibraryApi _api;

  LibraryLoader(LibraryApi api)
      : this._api = api,
        _books = Populater<List<BookData>>(
          onPopulate: () => api.all(),
          data: [],
        );

  Stream<List<BookData>> get books => _books.stream;

  void dispose() {
    _books.dispose();
  }

  Future insert(BookData book) async {
    final id = await _api.insertBook(book);
    final newBook = book.copyWith(id: id);
    _books.modify((data) {
      data.insert(0, newBook);
    });
  }

  Future delete(int index, BookData book) async {
    await _api.deleteBook(book);
    _books.modify((data) {
      data.removeAt(index);
    });
  }
}

class RecentsLoader {
  final Populater<List<BookData>> _books;
  final LibraryApi _api;

  RecentsLoader(LibraryApi api)
      : this._api = api,
        _books = Populater<List<BookData>>(
          onPopulate: () => api.recents(),
          data: [],
        );

  Stream<List<BookData>> get books => _books.stream;

  void dispose() {
    _books.dispose();
  }

  Future update(BookData book) async {
    final newBook = await _api.updateBook(book);
    _books.modify((data) {
      data.removeWhere((element) => element.id == book.id);
      data.insert(0, newBook);
    });
  }

  Future delete(int index, BookData book) async {
    await _api.deleteBookFromRecents(book);
    _books.modify((data) {
      data.removeAt(index);
    });
  }
}
