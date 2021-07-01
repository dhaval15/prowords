import '../grep/grep.dart';

import '../api/api.dart';

class ReplaceFrequencyTask extends Task<int> {
  final String query;
  final String path;

  ReplaceFrequencyTask(this.query, this.path);

  @override
  Future<int> run() async {
    int frequency = 0;
    Grep<String>(
      collector: ReplaceLineCollector(
        query: query,
        onLineFound: (index, line) {
          final splits = line.split(':');
          frequency = int.parse(splits.first) + 1;
          return '$frequency:${splits.sublist(1).join()}';
        },
        foundNothing: () {
          return '0:$query';
        },
        doContinue: false,
        stack: true,
      ),
      paths: [path],
      recursion: false,
    ).find();
    return frequency;
  }
}
