import 'dart:convert';

import 'package:flutter/material.dart';

import 'dictionary.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class UrbanDictionary with DictionaryMixin<UrbanWordDefinition> {
  static const BASE_URL = 'http://api.urbandictionary.com/v0/define';

  @override
  Future<List<UrbanWordDefinition>> define(String word) async {
    final url = _buildUrl(word);
    final response = await http.get(Uri.parse(url));
    final data = JsonDecoder().convert(response.body);
    if (data['list'] != null) {
      return data['list']
          .map((e) => UrbanWordDefinition.fromJson(e))
          .toList()
          .cast<UrbanWordDefinition>();
    }
    throw DictionaryException('No Meanings Found');
  }

  String _buildUrl(String query) {
    final formatedQuery = query.trim().split('\\s+').join('%20');
    return '$BASE_URL?term=$formatedQuery';
  }

  @override
  Widget build(UrbanWordDefinition item) {
    return UrbanWordDefinitionTile(definition: item);
  }
}

class UrbanWordDefinition implements Comparable {
  final String word;
  final String definition;
  final String example;
  final int thumbsUp;
  final int thumbsDown;

  UrbanWordDefinition({
    required this.word,
    required this.definition,
    required this.example,
    required this.thumbsUp,
    required this.thumbsDown,
  });

  factory UrbanWordDefinition.fromJson(dynamic json) => UrbanWordDefinition(
        word: json['word'] ?? '',
        definition: json['definition'] ?? '',
        example: json['example'] ?? '',
        thumbsUp: json['thumbs_up'] ?? 0,
        thumbsDown: json['thumbs_down'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
        'example': example,
        'thumbsUp': thumbsUp,
        'thumbsDown': thumbsDown,
      };

  @override
  int compareTo(other) {
    if (other is UrbanWordDefinition) {
      return thumbsUp - thumbsDown - other.thumbsUp + other.thumbsDown;
    }
    return 0;
  }

  @override
  String toString() => '* $word\n** Meaning\n$definition\n** Example\n$example';
}

class UrbanWordDefinitionTile extends StatelessWidget {
  final UrbanWordDefinition definition;
  final GestureTapCallback? onTap;

  const UrbanWordDefinitionTile({
    Key? key,
    required this.definition,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(definition.word),
      subtitle: Text(definition.definition),
      onTap: onTap,
    );
  }
}
