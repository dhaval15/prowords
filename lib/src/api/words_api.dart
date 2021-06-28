import 'dart:io';

import 'compute.dart';

import 'urban_dictionary.dart';
import '../grep/grep.dart';

class WordsApi {
  final String historyPath;
  static final client =
      UrbanDictionary(client: OfficialUrbanDictionaryClient());

  const WordsApi(this.historyPath);

  Future<WordDefineResult> define(String word) async {
    final definitions = await client.define(word);
    final frequency = await _ReplaceFrequencyTask(word, historyPath).execute();
    final meanings = definitions.map((e) => WordMeaning.from(e)).toList();
    return WordDefineResult(meanings, frequency);
  }

  Future<List<String>> recentWords() async {
    final file = File(historyPath);
    if (await file.exists()) return file.readAsLines();
    return [];
  }
}

class WordDefineResult {
  final List<WordMeaning> meanings;
  final int frequency;

  WordDefineResult(this.meanings, this.frequency);
}

class _ReplaceFrequencyTask extends Task<int> {
  final String query;
  final String path;

  _ReplaceFrequencyTask(this.query, this.path);

  @override
  Future<int> run() async {
    int frequency = 0;
    Grep<String>(
      collector: ReplaceLineCollector(
        query: query,
        onLineFound: (index, line) {
          final splits = line.split(':');
          frequency = int.parse(splits.first) + 1;
          return '$frequency:${splits.sublist(1).join()}';
        },
        foundNothing: () {
          return '0:$query';
        },
        doContinue: false,
        stack: true,
      ),
      paths: [path],
      recursion: false,
    ).find();
    return frequency;
  }
}

class WordMeaning {
  final String word;
  final String definition;
  final String example;

  WordMeaning({
    required this.word,
    required this.definition,
    required this.example,
  });

  factory WordMeaning.from(Definition definition) => WordMeaning(
        word: definition.word!,
        definition: definition.definition!.trim(),
        example: definition.example!.trim(),
      );

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
        'example': example,
      };

  @override
  String toString() => '* $word\n** Meaning\n$definition\n** Example\n$example';
}
