import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../api/api.dart';
import 'bookmarks_screen.dart';
import 'epub_config_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'reading_screen.dart';
import 'saved_meanings_screen.dart';
import 'word_meaning_screen.dart';
import 'add_word_meaning_screen.dart';
import 'epub_screen.dart';
import 'app_drawer_screen.dart';
import 'recent_words_screen.dart';

class Screens {
  // Root
  static const APP_DRAWER = '/';
  static const HOME = '/home';
  static const LIBRARY = '/library';
  static const READING = '/reading';
  static const WORD_MEANING = '/word_meaning';
  static const ADD_WORD_MEANING = '/add_word_meaning';
  static const EPUB = '/epub';
  static const EPUB_CONFIG = '/epub_config';
  static const SETTINGS = '/settings';
  static const WORDS = '/words';
  static const RECENT_WORDS = '/recent_words';
  static const SAVED_MEANINGS = '/saved_meanings';
  static const BOOKMARKS = '/bookmarks';

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
    APP_DRAWER: (context, args) => AppDrawerScreen(),
    HOME: (context, args) => HomeScreen(word: args as String?),
    LIBRARY: (context, args) => LibraryScreen(),
    READING: (context, args) => ReadingScreen(),
    WORDS: (context, args) => SavedMeaningsScreen(),
    RECENT_WORDS: (context, args) => RecentWordsScreen(),
    BOOKMARKS: (context, args) => BookmarksScreen(),
    WORD_MEANING: (context, args) => WordMeaningScreen(meaning: args),
    ADD_WORD_MEANING: (context, args) => AddWordMeaningScreen(meaning: args),
    EPUB: (context, args) {
      final map = args as Map<Symbol, dynamic>;
      return EpubScreen(
        book: map[#book],
        loader: map[#loader],
      );
    },
    EPUB_CONFIG: (context, args) =>
        EpubConfigScreen(config: args as EpubConfig),
  };
}

extension NavigatorStateExtension on NavigatorState {
  void popTo(String routeName) => popUntil(ModalRoute.withName(routeName));
}
