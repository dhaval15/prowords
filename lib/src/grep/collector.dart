part of 'grep.dart';

abstract class LineCollector<T> {
  Iterable<T> collect(String path, List<String> lines);
}

class SimpleLineCollector extends LineCollector<GrepResult> {
  final String query;

  SimpleLineCollector(this.query);

  @override
  Iterable<GrepResult> collect(String path, List<String> lines) sync* {
    for (int index = 0; index < lines.length; index++) {
      final line = lines[index];
      if (line.toLowerCase().contains(query.toLowerCase())) {
        yield GrepResult(line: index, content: line, path: path);
      }
    }
  }
}

class ReplaceLineCollector extends LineCollector<String> {
  final String query;
  final String? Function(int index, String line) onLineFound;
  final String Function()? foundNothing;
  final bool doContinue;
  final bool stack;

  ReplaceLineCollector({
    required this.query,
    required this.onLineFound,
    this.foundNothing,
    this.doContinue = true,
    this.stack = false,
  });

  @override
  Iterable<String> collect(String path, List<String> lines) sync* {
    bool found = false;
    for (int index = 0; index < lines.length; index++) {
      final line = lines[index];
      if (line.toLowerCase().contains(query.toLowerCase())) {
        found = true;
        final newLine = onLineFound(index, line);
        yield line;
        if (newLine != null) {
          if (stack) {
            lines.removeAt(index);
            lines.insert(0, newLine);
          } else {
            lines[index] = newLine;
          }
        }
        if (!doContinue) {
          File(path).writeAsStringSync(lines.join('\n'));
          return;
        }
      }
    }
    if (!found) {
      final newLine = foundNothing?.call();
      if (newLine != null) {
        if (stack)
          lines.insert(0, newLine);
        else
          lines.add(newLine);
      }
    }
    if (!found || doContinue) File(path).writeAsStringSync(lines.join('\n'));
  }
}

class SectionLineCollector extends LineCollector<GrepSectionResult> {
  final String query;
  final String startQuery;

  SectionLineCollector(this.query, this.startQuery);

  @override
  Iterable<GrepSectionResult> collect(String path, List<String> lines) sync* {
    int start = 0;
    int match = -1;
    bool started = false;
    final buffer = StringBuffer();
    for (int index = 0; index < lines.length; index++) {
      final line = lines[index];
      if (line.startsWith(startQuery)) {
        started = true;
        if (buffer.isNotEmpty && match > -1) {
          yield GrepSectionResult(
            start: start,
            end: index - 1,
            content: buffer.toString(),
            line: match,
            path: path,
          );
          match = -1;
        }
        start = index;
        buffer.clear();
      }
      if (started) buffer.write('$line\n');
      if (line.toLowerCase().contains(query.toLowerCase())) match = index;
      if (index == lines.length - 1 && match > -1 && buffer.isNotEmpty) {
        yield GrepSectionResult(
          start: start,
          end: index,
          content: buffer.toString(),
          line: match,
          path: path,
        );
      }
    }
  }
}
