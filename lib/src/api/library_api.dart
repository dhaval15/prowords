import 'dart:convert';
import 'dart:io';

import 'package:prowords/src/models/models.dart';
import 'package:prowords/src/utils/epub_config.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LibraryApi {
  final String configPath;
  final String dbPath;
  late Database db;
  final StoreRef<String, Map<String, dynamic>> store;
  final StoreRef<String, Map<String, dynamic>> recentStore;

  LibraryApi({
    required this.configPath,
    required this.dbPath,
    required this.store,
    required this.recentStore,
  });

  Future init() async {
    db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<EpubConfig> loadConfig() async {
    final file = File(configPath);
    if (!await file.exists()) {
      final config = EpubConfig.defaultDark;
      final data = JsonEncoder().convert(config.toJson());
      await file.writeAsString(data);
      return config;
    }
    final data = await file.readAsString();
    final config = EpubConfig.fromJson(JsonDecoder().convert(data));
    return config;
  }

  Future<void> saveConfig(EpubConfig config) async {
    final file = File(configPath);
    final data = JsonEncoder().convert(config.toJson());
    await file.writeAsString(data);
  }

  Future<String> insertBook(BookData book) {
    assert(book.id == null, 'Id should be null');
    return db.transaction((txn) async {
      final id = await store.add(txn, book.toJson());
      await store.record(id).update(txn, {'id': id});
      return id;
    });
  }

  Future<void> deleteBook(BookData book) async {
    assert(book.id != null, 'Id should be null');
    final record = store.record(book.id!);
    await record.delete(db);
  }

  Future<void> deleteBookFromRecents(BookData book) async {
    assert(book.id != null, 'Id should be null');
    final record = recentStore.record(book.id!);
    await record.delete(db);
  }

  Future<BookData> updateBook(BookData book) async {
    assert(book.id != null, 'Id should not be null');
    final record = recentStore.record(book.id!);
    await record.put(db, book.toJson());
    return book;
  }

  Future<BookData> fetchBook(String id) async {
    final record = await store.record(id).get(db);
    if (record == null) throw Exception('Book Not Found');
    return BookData.fromJson(record);
  }

  Future<BookData?> fetchBookFromRecents(String id) async {
    final record = await recentStore.record(id).get(db);
    if (record != null) return BookData.fromJson(record);
  }

  Future<List<BookData>> all() async =>
      _mapRecordsToEntries(await store.find(db));

  Future<List<BookData>> recents() async =>
      _mapRecordsToEntries(await recentStore.find(
        db,
        finder: Finder(sortOrders: [
          SortOrder('readAt', false),
        ]),
      ));

  Future<List<BookData>> find(Finder finder) async =>
      _mapRecordsToEntries(await store.find(db, finder: finder));

  List<BookData> _mapRecordsToEntries(List<RecordSnapshot> records) =>
      records.map((e) => BookData.fromJson(e.value)).toList();
}
