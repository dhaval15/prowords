import 'dart:async';

import 'package:flutter/widgets.dart';
import 'replace_frequency_task.dart';

export 'dictionary_dot_dev.dart';
// export 'dictionary_dot_dev_v2.dart';
export 'urban_dictionary.dart';

class DictionaryApi {
  final List<DictionaryMixin> dictionaries;
  final String historyPath;

  DictionaryApi({
    required this.dictionaries,
    required this.historyPath,
  }) : assert(dictionaries.isNotEmpty, 'No dictionary defined');

  Future<DictionaryResult> define(String query) async {
    final results = <DefinitionResult<dynamic>>[];
    for (final dictionary in dictionaries) {
      final definitions = await dictionary.define(query);
      for (final item in definitions) {
        results.add(DefinitionResult(data: item, builder: dictionary.build));
      }
    }
    final frequency = results.isEmpty
        ? 0
        : await ReplaceFrequencyTask(query, historyPath).execute();
    return DictionaryResult(results: results, frequency: frequency);
  }
}

class DictionaryResult {
  final List<DefinitionResult> results;
  final int frequency;

  DictionaryResult({
    required this.results,
    required this.frequency,
  });
}

class DefinitionResult<T> {
  final T data;
  final Widget Function(T item) builder;

  const DefinitionResult({
    required this.data,
    required this.builder,
  });
}

class DictionaryException implements Exception {
  final String message;

  const DictionaryException(this.message);
}

mixin DictionaryMixin<T> {
  Future<List<T>> define(String query);
  Widget build(T item);
}
