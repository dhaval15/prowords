import 'package:epub_view/epub_view.dart';

import 'package:flutter/material.dart';
import 'package:prowords/src/pages/pages.dart';
import '../utils/utils.dart';
import 'custom_text_selection_controls.dart';
import 'epub_statusbar.dart';

class StyledEpubView extends StatelessWidget {
  final EpubController controller;
  final EpubConfig config;
  final List<ActionButton> actions;
  final void Function(EpubBook? document)? onDocumentLoaded;
  final EpubMeta meta;
  final GestureTapCallback? onTapBattery;
  final GestureTapCallback? onTapChapter;
  final GestureTapCallback? onTapProgress;

  const StyledEpubView({
    required this.controller,
    required this.config,
    required this.meta,
    required this.actions,
    this.onDocumentLoaded,
    this.onTapBattery,
    this.onTapChapter,
    this.onTapProgress,
  });

  void showChapters(BuildContext context) async {
    final chapters = await controller.tableOfContentsStream.first;
    final position = await Pages.showChapterOverViewPage(
      context,
      chapters: chapters!,
    );
    if (position is int) {
      controller.jumpTo(index: position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: config.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: config.padding),
              child: EpubView(
                controller: controller,
                textAlign: config.textAlign,
                textStyle: config.textStyle,
                onDocumentLoaded: onDocumentLoaded,
                paragraphPadding: EdgeInsets.zero,
                selectionControls: CustomTextSelectionControls(
                  actions: actions,
                ),
                dividerBuilder: (chapter) => ChapterTitle(
                  title: chapter.Title ?? '',
                  textColor: config.fontColor,
                ),
                indent: config.indent,
                paragraphGap: config.paragraphSpacing / 2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FutureBuilder<EpubBook>(
            future: Future.microtask(() => controller.document),
            builder: (context, snapshot) => snapshot.hasData
                ? EpubStatusbar(
                    meta: meta,
                    controller: controller,
                    book: snapshot.data!,
                    textColor: config.fontColor.withOpacity(0.6),
                    onTapChapter: onTapChapter,
                    onTapBattery: onTapBattery,
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class ChapterTitle extends StatelessWidget {
  final String title;
  final Color textColor;

  const ChapterTitle({
    required this.title,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: textColor.withOpacity(0.6)))),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: textColor.withOpacity(0.8)),
        ),
      ),
    );
  }
}
