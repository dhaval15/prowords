import 'dart:io';
part 'result.dart';
part 'collector.dart';
part 'filter.dart';
part 'position.dart';

class Grep<T> {
  final LineCollector<T> collector;
  final List<FileFilter> filters;
  final List<String> paths;
  final bool recursion;

  Grep({
    required this.collector,
    required this.paths,
    this.filters = const [],
    this.recursion = true,
  });

  List<T> find() {
    return _visit(paths).toList();
  }

  Iterable<T> _visit(
    Iterable<String> paths,
  ) sync* {
    for (final path in paths) {
      final file = File(path);
      final stat = file.statSync();
      if (recursion && stat.type == FileSystemEntityType.directory) {
        if (!FileFilter.evaluate(filters, FileSystemEntityType.directory, path))
          break;
        final directory = Directory(path);
        yield* _visit(directory.listSync().map((e) => e.path));
      } else if (stat.type == FileSystemEntityType.file) {
        if (!FileFilter.evaluate(filters, FileSystemEntityType.file, path))
          break;
        final file = File(path);
        final lines = file.readAsLinesSync();
        yield* collector.collect(path, lines);
      }
    }
  }
}

void main(List<String> args) {
  final file = '/home/dhaval/Dev/space/habbit/test_dir/notes';
  final grep = Grep(
    collector: SectionLineCollector(args.first, '* '),
    // collector: SimpleLineCollector(args.first),
    paths: [file],
    filters: [
      IgnoreHiddenFilter(),
      // ExtensionFilter(['org'])
    ],
  );
  final results = grep.find();
  for (final result in results) {
    print(result.content);
  }
}
