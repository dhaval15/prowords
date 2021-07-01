import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dictionary.dart';
import 'package:flutter/material.dart';

class DictionaryDotDev with DictionaryMixin<DotWordDefinition> {
  static const BASE_URL = 'https://api.dictionaryapi.dev/api/v2/entries/en_US';

  Future<List<DotWordDefinition>> define(String word) async {
    final url = _buildUrl(word);
    final response = await http.get(Uri.parse(url));
    final data = JsonDecoder().convert(response.body);
    if (data is List) {
      return data
          .map((e) => DotWordDefinition.fromJson(e))
          .fold<List<DotWordDefinition>>(
              [], (previousValue, element) => [...previousValue, ...element]);
    }
    throw DictionaryException('No Meanings Found');
  }

  String _buildUrl(String query) {
    final formatedQuery = query.trim().split('\\s+').join('%20');
    return '$BASE_URL/$formatedQuery';
  }

  @override
  Widget build(DotWordDefinition item) {
    return DotWordDefinitionTile(definition: item);
  }
}

class DotWordDefinition {
  final String word;
  final String partOfSpeech;
  final String definition;
  final List<String> synonyms;
  final String example;

  DotWordDefinition({
    required this.word,
    required this.partOfSpeech,
    required this.definition,
    required this.synonyms,
    required this.example,
  });

  static List<DotWordDefinition> fromJson(Map<String, dynamic> json) {
    final word = json['word'];
    final meanings = json['meanings'] ?? [];
    final list = <DotWordDefinition>[];
    for (final meaning in meanings) {
      final partOfSpeech = meaning['partOfSpeech'] ?? '';
      final definitions = meaning['definitions'] ?? [];
      for (final definition in definitions) {
        list.add(DotWordDefinition(
          word: word,
          partOfSpeech: partOfSpeech,
          definition: definition['definition'],
          synonyms: definition['synonyms'],
          example: definition['example'],
        ));
      }
    }
    return list;
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'partOfSpeech': partOfSpeech,
        'definition': definition,
        'synonyms': synonyms,
        'example': example,
      };
}

class DotWordDefinitionTile extends StatelessWidget {
  final DotWordDefinition definition;

  const DotWordDefinitionTile({
    required this.definition,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.word,
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            definition.partOfSpeech,
            style: TextStyle(
              color: Theme.of(context).hintColor,
            ),
          ),
          Text(definition.definition),
          const SizedBox(height: 4),
          if (definition.synonyms.isNotEmpty) ...[
            Text('Synnonyms : ${definition.synonyms.join(', ')}'),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}
