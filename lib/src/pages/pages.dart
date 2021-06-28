export 'epub_config_page.dart';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prowords/src/utils/epub_config.dart';

import 'chapter_overview_page.dart';
import 'epub_config_page.dart';

export 'epub_config_page.dart';
export 'chapter_overview_page.dart';

class Pages {
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
}
