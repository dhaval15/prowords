import 'dart:math';

import 'package:epub_view/epub_view.dart';

class EpubCurrentMeta {
  final int currentPageInChapter;
  final int currentPage;

  const EpubCurrentMeta(this.currentPageInChapter, this.currentPage);

  factory EpubCurrentMeta.from(
      EpubBook book, EpubChapterViewValue value, EpubMeta meta) {
    final currentPageInChapter = EpubMeta._getPageCountAccurate(value
        .chapter!.HtmlContent!
        .split('<p')
        .take(value.paragraphNumber)
        .join('<p'));
    final currentPage = meta.chapterPages
            .take(value.chapterNumber - 1)
            .fold<int>(0, (previousValue, element) => element + previousValue) +
        currentPageInChapter;
    return EpubCurrentMeta(currentPageInChapter, currentPage);
  }
}

class EpubMeta {
  final int totalPages;
  final List<int> chapterPages;

  const EpubMeta({
    required this.totalPages,
    required this.chapterPages,
  });

  factory EpubMeta.fromEpub(EpubBook book) {
    int total = 0;
    final chapterPages = <int>[];
    book.Chapters?.forEach((element) {
      final pages = _getPageCountAccurate(element.HtmlContent ?? '');
      total += pages;
      chapterPages.add(pages);
    });
    return EpubMeta(totalPages: total, chapterPages: chapterPages);
  }

  static int _getPageCountAccurate(String epubHtml) {
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
}
