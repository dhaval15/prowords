import 'dart:math';

import 'package:epub_view/epub_view.dart';

class CurrentMeta {
  final int currentPageInChapter;
  final int currentPage;

  const CurrentMeta(this.currentPageInChapter, this.currentPage);

  factory CurrentMeta.from(
      EpubBook book, EpubChapterViewValue value, ChapterMeta meta) {
    final currentPageInChapter = _getPageCountAccurate(value
        .chapter!.HtmlContent!
        .split('<p')
        .take(value.paragraphNumber)
        .join('<p'));
    print('Chapter Number: ${value.chapterNumber}');
    print('Start : ${meta.find(value.chapterNumber)?.start}');
    final currentPage =
        (meta.find(value.chapterNumber)?.start ?? 0) + currentPageInChapter;
    return CurrentMeta(currentPageInChapter, currentPage);
  }
}

class ChapterMeta {
  final String title;
  final int index;
  final int pages;
  final int start;
  int? _totalPages;
  int get totalPages {
    if (_totalPages == null) _calculate();
    return _totalPages!;
  }

  int get lastIndex => sub.isEmpty ? index : sub.last.lastIndex;

  final List<ChapterMeta> sub;

  ChapterMeta({
    required this.title,
    required this.index,
    required this.start,
    required this.pages,
    required this.sub,
  });

  void _calculate() {
    _totalPages = pages +
        sub.fold<int>(
            0, (previousValue, element) => previousValue + element.totalPages);
  }

  int get end => start + totalPages;

  ChapterMeta? find(int index) {
    if (this.index == index) return this;
    for (final subMeta in sub) {
      final found = subMeta.find(index);
      if (found != null) return found;
    }
    return null;
  }

  factory ChapterMeta.fromEpub(EpubBook book) {
    int start = 0;
    int index = 0;
    final meta = ChapterMeta(
        title: book.Title ?? 'NA #0',
        start: start,
        index: 0,
        pages: 0,
        sub: []);
    index = index + 1;
    for (final subChapter in book.Chapters!) {
      final subMeta = buildChapterMeta(index, start, subChapter);
      start = subMeta.end;
      index = subMeta.lastIndex + 1;
      meta.sub.add(subMeta);
    }
    meta._calculate();
    print('Largest $index');
    return meta;
  }

  static ChapterMeta buildChapterMeta(
      int index, int start, EpubChapter chapter) {
    final pages = _getPageCountAccurate(chapter.HtmlContent ?? '');
    final meta = ChapterMeta(
        title: chapter.Title ?? 'NA #$index',
        index: index,
        start: start,
        pages: pages,
        sub: []);
    start = start + pages;
    index = index + 1;
    if (chapter.SubChapters != null)
      for (final subChapter in chapter.SubChapters!) {
        final subMeta = buildChapterMeta(index, start, subChapter);
        start = subMeta.end;
        index = subMeta.lastIndex + 1;
        meta.sub.add(subMeta);
      }
    meta._calculate();
    return meta;
  }
}

int _getPageCountAccurate(String epubHtml) {
  // Decide whether to split on <p> or <div> characters
  final numDivs = epubHtml.split('<div').length;
  final numParas = epubHtml.split('<p').length;
  final splitChar = numParas > numDivs ? 'p' : 'd';

  // States
  var inTag = false;
  var inP = false;
  var checkP = false;
  var closing = false;
  var pCharCount = 0;

  // Get positions of every line
  // A line is either a paragraph starting
  // or every 70 characters in a paragraph.
  final lines = [];
  int pos = -1;
  // We want this to be as fast as possible so we
  // are going to do one pass across the text. re
  // and string functions will parse the text each
  // time they are called.
  //
  // We can can use .lower() here because we are
  // not modifying the text. In this case the case
  // doesn't matter just the absolute character and
  // the position within the stream.
  final characters =
      epubHtml.toLowerCase().runes.map((e) => String.fromCharCode(e));
  for (final c in characters) {
    pos += 1;

    // Check if we are starting or stopping a p tag.
    if (checkP) {
      if (c == '/') {
        closing = true;
        continue;
      } else if (c == splitChar) {
        if (closing) {
          inP = false;
        } else {
          inP = true;
          lines.add(pos - 2);
        }
        checkP = false;
        closing = false;
        continue;
      }
    }

    if (c == '<') {
      inTag = true;
      checkP = true;
      continue;
    } else if (c == '>') {
      inTag = false;
      checkP = false;
      continue;
    }

    if (inP && !inTag) {
      pCharCount += 1;
      if (pCharCount == 70) {
        lines.add(pos);
        pCharCount = 0;
      }
    }
  }

  // Using 31 lines instead of 32 used by APNX to get the numbers similar
  final count = lines.length ~/ 31;
  // We could still have a really weird document and massively understate
  // As a backstop count the characters using the "fast count" algorithm
  // and use that number instead
  final fastCount = epubHtml.length ~/ 2400 + 1;
  return max(count, fastCount);
}
