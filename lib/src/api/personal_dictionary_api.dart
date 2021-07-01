import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class PersonalDictionaryApi {
  final String dbPath;
  late Database db;
  final StoreRef<String, Map<String, dynamic>> store;

  PersonalDictionaryApi({
    required this.dbPath,
    required this.store,
  });

  Future init() async {
    db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<String> insertEntry(DictionaryEntry entry) {
    assert(entry.id == null, 'Id should be null');
    return db.transaction((txn) async {
      final id = await store.add(txn, entry.toJson());
      await store.record(id).update(txn, {'id': id});
      return id;
    });
  }

  Future<String> updateEntry(DictionaryEntry entry) async {
    assert(entry.id != null, 'Id should not be null');
    final record = store.record(entry.id!);
    await record.update(db, entry.toJson());
    return entry.id!;
  }

  Future<DictionaryEntry> fetchEntry(String id) async {
    final record = await store.record(id).get(db);
    if (record == null) throw Exception('Entry Not Found');
    return DictionaryEntry.from(record);
  }

  Future<List<DictionaryEntry>> all() async =>
      _mapRecordsToEntries(await store.find(db));

  Future<List<DictionaryEntry>> find(Finder finder) async =>
      _mapRecordsToEntries(await store.find(db, finder: finder));

  List<DictionaryEntry> _mapRecordsToEntries(List<RecordSnapshot> records) =>
      records.map((e) => DictionaryEntry.from(e.value)).toList();

  Future<DictionaryEntry?> checkWordForEntry(dynamic meaning) async {
    final records = await store.find(
      db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('word', meaning.word),
          Filter.equals('definition', meaning.definition),
        ]),
      ),
    );
    if (records.isNotEmpty) {
      final entry = DictionaryEntry.from(records.first.value);
      await updateEntry(entry.visit());
      return entry;
    }
  }
}

class DictionaryEntry {
  final String? id;
  final String word;
  final String definition;
  final String example;
  final int frequency;
  final List<String> tags;

  DictionaryEntry({
    this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.frequency,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'frequency': frequency,
        'word': word,
        'definition': definition,
        'example': example,
        'tags': tags,
      };

  factory DictionaryEntry.from(Map<String, dynamic> json) => DictionaryEntry(
        id: json['id'],
        frequency: json['frequency'],
        word: json['word'],
        definition: json['definition'],
        example: json['example'],
        tags: json['tags'].cast<String>(),
      );

  DictionaryEntry copyWith({
    String? id,
    String? word,
    String? definition,
    String? example,
    int? frequency,
    List<String>? tags,
  }) =>
      DictionaryEntry(
        id: id ?? this.id,
        word: word ?? this.word,
        definition: definition ?? this.definition,
        example: example ?? this.example,
        frequency: frequency ?? this.frequency,
        tags: tags ?? this.tags,
      );

  DictionaryEntry visit() => DictionaryEntry(
        id: id,
        word: word,
        definition: definition,
        example: example,
        frequency: frequency + 1,
        tags: tags,
      );
}
