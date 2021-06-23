import 'package:dio/dio.dart';

/// Urban Dictionary API instance.
///
/// Note that fetch methods might throw. Possible exceptions are
/// [InvalidDataException] (cannot parse data) and [InvalidResponseException]
/// (server does not returns data).
class UrbanDictionary {
  final UrbanDictionaryClient client;
  final Dio _dio;

  UrbanDictionary({required this.client}) : _dio = Dio(client.options);

  /// Get definition for given [query].
  Future<List<Definition>> define(String query) async {
    Response response;

    try {
      response = await _dio.get(
        '/define',
        queryParameters: {'term': query},
      );
    } catch (e) {
      throw InvalidResponseException(e.toString());
    }

    try {
      final raw = response.data['list'] as List<dynamic>;
      return raw
          .where((e) => e != null)
          .map((e) => Definition.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
      throw const InvalidDataException();
    }
  }

  /// Get list of random word definitions.
  Future<List<Definition>> random() async {
    Response response;

    try {
      response = await _dio.get('/random');
    } catch (e) {
      throw InvalidResponseException(e.toString());
    }

    try {
      print(response.data);
      final raw = response.data['list'] as List<dynamic>;
      return raw.map((e) => Definition.fromJson(e)).toList();
    } catch (e) {
      throw const InvalidDataException();
    }
  }
}

abstract class UrbanDictionaryClient {
  String get baseUrl;

  BaseOptions get options;
}

/// Official internal Urban Dictionary API.
class OfficialUrbanDictionaryClient implements UrbanDictionaryClient {
  @override
  final String baseUrl;

  @override
  final BaseOptions options;

  OfficialUrbanDictionaryClient({
    this.baseUrl = 'http://api.urbandictionary.com/v0',
  }) : options = BaseOptions(
          responseType: ResponseType.json,
          baseUrl: baseUrl,
        );
}

/// Alternative API for accessing Urban Dictionary. Requires registration.
///
/// https://rapidapi.com/community/api/urban-dictionary/
class RapidApiUrbanDictionaryClient extends UrbanDictionaryClient {
  @override
  final String baseUrl;

  @override
  final BaseOptions options;

  /// Create RapidAPI client instance.
  ///
  /// [key] is required. You can obtain one after registration.
  RapidApiUrbanDictionaryClient({
    this.baseUrl = 'https://mashape-community-urban-dictionary.p.rapidapi.com',
    required String key,
  }) : options = BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'x-rapidapi-host': baseUrl.split('//')[1],
            'x-rapidapi-key': key,
          },
          responseType: ResponseType.json,
        );
}

String _dateToJson(DateTime input) => input.toIso8601String();

DateTime _dateFromJson(String input) => DateTime.parse(input);

class Definition {
  final String? word;

  final String? definition;

  final int? id;

  final String? permalink;

  final Map<String, dynamic>? soundsUrls;

  final String? author;

  final DateTime writtenOn;

  final String? example;

  final int? thumbsUp;

  final int? thumbsDown;

  final String? currentVote;

  Definition({
    this.word,
    this.definition,
    this.id,
    this.permalink,
    this.soundsUrls,
    this.author,
    required this.writtenOn,
    this.example,
    this.thumbsUp,
    this.thumbsDown,
    this.currentVote,
  });

  @override
  String toString() {
    return 'Definition{word: $word, id: $id, writtenOn: $writtenOn}';
  }

  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Definition &&
          runtimeType == other.runtimeType &&
          word == other.word &&
          definition == other.definition &&
          id == other.id &&
          permalink == other.permalink &&
          soundsUrls == other.soundsUrls &&
          author == other.author &&
          writtenOn == other.writtenOn &&
          example == other.example &&
          thumbsUp == other.thumbsUp &&
          thumbsDown == other.thumbsDown &&
          currentVote == other.currentVote;

  @override
  int get hashCode =>
      word.hashCode ^
      definition.hashCode ^
      id.hashCode ^
      permalink.hashCode ^
      soundsUrls.hashCode ^
      author.hashCode ^
      writtenOn.hashCode ^
      example.hashCode ^
      thumbsUp.hashCode ^
      thumbsDown.hashCode ^
      currentVote.hashCode;
}

Definition _$DefinitionFromJson(Map<String, dynamic> json) {
  return Definition(
    word: json['word'],
    definition: json['definition'],
    id: json['defid'],
    permalink: json['permalink'],
    soundsUrls: json['sounds_urls'],
    author: json['author'],
    writtenOn: _dateFromJson(json['written_on']),
    example: json['example'],
    thumbsUp: json['thumbs_up'],
    thumbsDown: json['thumbs_down'],
    currentVote: json['current_vote'],
  );
}

Map<String, dynamic> _$DefinitionToJson(Definition instance) =>
    <String, dynamic>{
      'word': instance.word,
      'definition': instance.definition,
      'defid': instance.id,
      'permalink': instance.permalink,
      'sounds_urls': instance.soundsUrls,
      'author': instance.author,
      'written_on': _dateToJson(instance.writtenOn),
      'example': instance.example,
      'thumbs_up': instance.thumbsUp,
      'thumbs_down': instance.thumbsDown,
      'current_vote': instance.currentVote,
    };

class InvalidDataException implements Exception {
  const InvalidDataException();
}

class InvalidResponseException implements Exception {
  final String message;

  const InvalidResponseException([this.message = '']);

  @override
  String toString() => 'InvalidResponseException{message: $message}';
}
