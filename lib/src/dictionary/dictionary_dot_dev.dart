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
      return data.map((e) => DotWordDefinition.fromJson(e)).toList();
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
  final List<Meaning> meanings;

  DotWordDefinition({
    required this.word,
    required this.meanings,
  });

  factory DotWordDefinition.fromJson(Map<String, dynamic> json) {
    final word = json['word'];
    final meanings = json['meanings'];
    return DotWordDefinition(
      word: word,
      meanings: meanings != null
          ? meanings.map((e) => Meaning.fromJson(e)).toList().cast<Meaning>()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'meanings': meanings.map((v) => v.toJson()).toList(),
      };
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(dynamic json) {
    final partOfSpeech = json['partOfSpeech'];
    final definitions = json['definitions'];
    return Meaning(
      partOfSpeech: partOfSpeech,
      definitions: definitions != null
          ? (definitions.map((e) => Definition.fromJson(e)))
              .toList()
              .cast<Definition>()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'partOfSpeech': partOfSpeech,
        'definitions': definitions.map((e) => e.toJson()).toList(),
      };
}

class Definition {
  final String definition;
  final List<String> synonyms;
  final String example;

  const Definition({
    required this.definition,
    required this.synonyms,
    required this.example,
  });

  factory Definition.fromJson(dynamic json) {
    final definition = json['definition'];
    final synonyms = json['synonyms'];
    final example = json['example'];

    return Definition(
      definition: definition,
      synonyms: synonyms != null ? synonyms.cast<String>() : [],
      example: example ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
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
          for (final meaning in definition.meanings)
            MeaningTile(meaning: meaning),
        ],
      ),
    );
  }
}

class MeaningTile extends StatelessWidget {
  final Meaning meaning;

  const MeaningTile({
    required this.meaning,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meaning.partOfSpeech,
          style: TextStyle(
            color: Theme.of(context).hintColor,
          ),
        ),
        ...meaning.definitions.map((e) => DefinitionTile(definition: e)),
      ],
    );
  }
}

class DefinitionTile extends StatelessWidget {
  final Definition definition;

  const DefinitionTile({
    required this.definition,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(definition.definition),
        const SizedBox(height: 4),
        if (definition.synonyms.isNotEmpty) ...[
          Text('Synnonyms : ${definition.synonyms.join(', ')}'),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}
