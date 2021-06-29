import 'package:flutter/material.dart';
import 'package:frooti/frooti.dart';

import '../api/api.dart';
import '../models/models.dart';
import '../styles/styles.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class ReadingScreen extends StatefulWidget {
  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late RecentsLoader loader;
  @override
  void initState() {
    super.initState();
    loader = RecentsLoader(Providers.of<LibraryApi>(context));
  }

  @override
  Widget build(BuildContext context) {
    final color = Scheme.of(context).onBackground.withOpacity(0.1);
    return Scaffold(
      appBar: AppBar(
        leading: DrawerIcon(),
        title: Text('Reading'),
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
            onTap: () {
              Navigator.of(context).pushNamed(Screens.EPUB, arguments: {
                #book: book,
                #loader: loader,
              });
            },
          ),
        ),
      ),
    );
  }
}
