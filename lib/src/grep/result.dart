part of 'grep.dart';

class GrepSectionResult extends GrepResult {
  final int start;
  final int end;

  GrepSectionResult({
    required this.start,
    required this.end,
    required int line,
    required String content,
    required String path,
  }) : super(
          line: line,
          content: content,
          path: path,
        );

  Position get position => Position(
        start: start,
        end: end,
        file: path,
      );
}

class GrepResult {
  final int line;
  final String content;
  final String path;

  GrepResult({
    required this.line,
    required this.content,
    required this.path,
  });
}
