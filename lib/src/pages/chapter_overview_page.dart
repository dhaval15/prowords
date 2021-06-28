import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';

class ChapterViewPage extends StatelessWidget {
  final List<EpubViewChapter> chapters;
  final ScrollController? controller;

  const ChapterViewPage({
    required this.chapters,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: BouncingScrollPhysics(),
      itemCount: chapters.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return ListTile(
            title: Text(
              'Chapters',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        final chapter = chapters[index - 1];
        return ListTile(
          title: Text(chapter.title ?? '#$index'),
          onTap: () {
            Navigator.of(context).pop(chapter.startIndex);
          },
        );
      },
    );
  }
}
