import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prowords/src/models/models.dart';
import '../utils/utils.dart';

import 'add_bookmark_page.dart';
import 'bookmark_page.dart';
import 'brightness_control_page.dart';
import 'chapter_overview_page.dart';
import 'epub_config_page.dart';
import 'find_word_page.dart';

export 'chapter_overview_page.dart';
export 'epub_config_page.dart';
export 'epub_config_page.dart';

class Pages {
  static Future addBookmark(BuildContext context,
      {required Bookmark bookmark}) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.4,
        maxChildSize: 0.9,
        initialChildSize: 0.4,
        expand: false,
        builder: (context, controller) {
          return AddBookmarkPage(
            bookmark: bookmark,
            controller: controller,
          );
        },
      ),
    );
  }

  static Future showBookmark(BuildContext context,
      {required Bookmark bookmark}) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.35,
        maxChildSize: 0.9,
        initialChildSize: 0.35,
        expand: false,
        builder: (context, controller) {
          return BookmarkPage(
            bookmark: bookmark,
            controller: controller,
          );
        },
      ),
    );
  }

  static Future findWord(BuildContext context, {required String word}) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.4,
        maxChildSize: 0.9,
        initialChildSize: 0.4,
        expand: false,
        builder: (context, controller) {
          return FindWordPage(
            controller: controller,
            word: word,
          );
        },
      ),
    );
  }

  static Future<int?> showChapterOverViewPage(BuildContext context,
      {required List<EpubViewChapter> chapters}) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.4,
        maxChildSize: 0.9,
        initialChildSize: 0.4,
        expand: false,
        builder: (context, controller) {
          return ChapterViewPage(
            controller: controller,
            chapters: chapters,
          );
        },
      ),
    );
  }

  static Future<int?> showChapterOverViewPageV2(BuildContext context,
      {required ChapterMeta meta}) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.4,
        maxChildSize: 0.9,
        initialChildSize: 0.4,
        expand: false,
        builder: (context, controller) {
          return ChapterViewPageV2(
            controller: controller,
            meta: meta,
          );
        },
      ),
    );
  }

  static Future<EpubConfig?> showEpubConfigPage(BuildContext context,
      {required EpubConfig config}) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.4,
        maxChildSize: 0.9,
        initialChildSize: 0.4,
        expand: false,
        builder: (context, controller) {
          return EpubConfigPage(
            config: config,
            controller: controller,
          );
        },
      ),
    );
  }

  static Future<EpubConfig?> showBrightnessControlPage(
      BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.25,
        maxChildSize: 0.25,
        initialChildSize: 0.25,
        expand: false,
        builder: (context, controller) {
          return BrightnessControlPage();
        },
      ),
    );
  }
}
