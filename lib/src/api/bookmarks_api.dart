import 'package:prowords/src/models/models.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class BookmarksApi {
  final String dbPath;
  late Database db;
  final StoreRef<String, Map<String, dynamic>> store;

  BookmarksApi({
    required this.dbPath,
    required this.store,
  });

  Future init() async {
    db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<String> insertBookmark(Bookmark bookmark) {
    assert(bookmark.id == null, 'Id should be null');
    return db.transaction((txn) async {
      final id = await store.add(txn, bookmark.toJson());
      await store.record(id).update(txn, {'id': id});
      return id;
    });
  }

  Future<void> deleteBookmark(Bookmark bookmark) async {
    assert(bookmark.id != null, 'Id should be null');
    final record = store.record(bookmark.id!);
    await record.delete(db);
  }

  Future<Bookmark> fetchBookmark(String id) async {
    final record = await store.record(id).get(db);
    if (record == null) throw Exception('Book Not Found');
    return Bookmark.fromJson(record);
  }

  Future<List<Bookmark>> all() async =>
      _mapRecordsToEntries(await store.find(db));

  Future<List<Bookmark>> find(Finder finder) async =>
      _mapRecordsToEntries(await store.find(db, finder: finder));

  List<Bookmark> _mapRecordsToEntries(List<RecordSnapshot> records) =>
      records.map((e) => Bookmark.fromJson(e.value)).toList();
}
