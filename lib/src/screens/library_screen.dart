import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:frooti/frooti.dart';
import 'package:path_provider/path_provider.dart';

import '../api/api.dart';
import '../models/models.dart';
import '../styles/styles.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late LibraryLoader loader;
  @override
  void initState() {
    super.initState();
    loader = LibraryLoader(Providers.of<LibraryApi>(context));
  }

  void _importBook(BuildContext context) async {
    final dir = await getExternalStorageDirectory();
    final path = dir!.parent.parent.parent.parent.path;
    final result = await FilesystemPicker.open(
      context: context,
      pickText: 'Open A Book',
      title: 'Open A Book',
      fsType: FilesystemType.file,
      folderIconColor: Scheme.of(context).onBackground,
      rootDirectory: Directory(path),
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      allowedExtensions: ['.epub'],
    );
    if (result != null) {
      final book = await EpubReader.readBook(File(result).readAsBytes());
      final bookdata = BookData(title: book.Title!, filePath: result);
      loader.insert(bookdata);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Scheme.of(context).onBackground.withOpacity(0.1);
    return Scaffold(
      appBar: AppBar(
        leading: DrawerIcon(),
        title: Text('Library'),
      ),
      body: StreamListBuilder<BookData>(
        padding: const EdgeInsets.all(16),
        stream: loader.books,
        builder: (context, book, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            tileColor: color,
            title: Text(book.title),
            trailing: IconButton(
              onPressed: () {
                loader.delete(index, book);
              },
              icon: Icon(Icons.cancel),
            ),
            onTap: () async {
              final readingBook = await Providers.of<LibraryApi>(context)
                  .fetchBookFromRecents(book.id!);
              Navigator.of(context).pushNamed(Screens.EPUB,
                  arguments: {#book: readingBook ?? book});
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _importBook(context),
        mini: true,
        child: Icon(Icons.add),
      ),
    );
  }
}
