import 'src/api/urban_dictionary.dart';

void main(List<String> args) async {
  final word = args.first;
  final client = UrbanDictionary(client: OfficialUrbanDictionaryClient());
  client.define(word);
}
