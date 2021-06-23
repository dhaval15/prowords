import 'package:flutter/material.dart';
import '../api/api.dart';
import 'home_screen.dart';
import 'word_meaning_screen.dart';
import 'add_word_meaning_screen.dart';

class Screens {
  // Root
  static const HOME = '/';
  static const WORD_MEANING = '/word_meaning';
  static const ADD_WORD_MEANING = '/add_word_meaning';

  static Route? onGenerateRoute(RouteSettings settings) {
    print(
        'Screen Changed : ${settings.name} with arguments (${settings.arguments.runtimeType})');
    final builder = _builders[settings.name];
    if (builder != null)
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => builder(context, settings.arguments),
      );
    return null;
  }

  static Map<String, Widget Function(BuildContext context, Object? data)>
      _builders = {
    // Root
    HOME: (context, args) => HomeScreen(word: args as String?),
    WORD_MEANING: (context, args) =>
        WordMeaningScreen(meaning: args as WordMeaning),
    ADD_WORD_MEANING: (context, args) =>
        AddWordMeaningScreen(meaning: args as WordMeaning),
  };
}

extension NavigatorStateExtension on NavigatorState {
  void popTo(String routeName) => popUntil(ModalRoute.withName(routeName));
}
