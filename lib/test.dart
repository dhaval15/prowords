import 'package:sembast/sembast.dart';

import 'src/api/words_api.dart';
import 'src/api/dictionary_store_api.dart';

void main(List<String> args) async {
  final word = args.first;
  final api = PersonalDictionaryApi(
      dbPath: 'dictionary.db', store: stringMapStoreFactory.store('words'));
  await api.init();
  final entries = await api.find(Finder(filter: Filter.equals('word', word)));
  if (entries.isNotEmpty) {
    print('Offline');
    print(entries.map((e) => e.toString()).cast<String>().join('\n'));
    return;
  }
  final meanings = await WordsApi.define(args.first);
  await api.insertEntry(meanings.first.toEntry(<String>[]));
  if (meanings.isNotEmpty) {
    print(meanings.map((e) => e.toString()).cast<String>().join('\n'));
    return;
  }
}
