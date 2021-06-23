part of 'grep.dart';

class Position {
  final int start;
  final int end;
  final String file;

  Position({
    required this.start,
    required this.end,
    required this.file,
  });
}
