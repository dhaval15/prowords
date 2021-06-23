part of 'grep.dart';

abstract class FileFilter {
  const FileFilter();
  bool filter(FileSystemEntityType type, String path);

  static bool evaluate(
      List<FileFilter> filters, FileSystemEntityType type, String path) {
    for (final filter in filters) {
      if (!filter.filter(type, path)) {
        return false;
      }
    }
    return true;
  }
}

class IgnoreHiddenFilter extends FileFilter {
  const IgnoreHiddenFilter();

  @override
  bool filter(FileSystemEntityType type, String path) {
    return !path.split('/').last.startsWith('.');
  }
}

class ExtensionFilter extends FileFilter {
  final List<String> extensions;

  const ExtensionFilter(this.extensions);
  @override
  bool filter(FileSystemEntityType type, String path) {
    if (type == FileSystemEntityType.directory) return true;
    final ext = path.split('/').last.split('.').last;
    return extensions.contains(ext);
  }
}
