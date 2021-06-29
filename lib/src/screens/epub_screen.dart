import 'dart:async';
import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prowords/src/pages/pages.dart';
import 'package:prowords/src/screens/epub_config_screen.dart';
import 'package:screen/screen.dart';

import '../api/api.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class EpubScreen extends StatefulWidget {
  final RecentsLoader? loader;
  final BookData book;

  const EpubScreen({
    required this.book,
    required this.loader,
  });
  @override
  _EpubScreenState createState() => _EpubScreenState();
}

class _EpubScreenState extends State<EpubScreen> {
  late EpubController _controller;
  late StreamController<EpubConfig> _configController;
  late StreamSubscription _subscription;
  late EpubConfig _config;
  final debounce = Debounce(Duration(milliseconds: 300));
  late LibraryApi libraryApi;
  late ChapterMeta meta;
  late BookData _book;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _configController.close();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Screen.restore();
    super.dispose();
  }

  void _init() async {
    _book = widget.book;
    libraryApi = Providers.of<LibraryApi>(context);
    final bytes = File(_book.filePath).readAsBytes();
    _configController = StreamController<EpubConfig>();
    final book = await EpubReader.readBook(bytes);
    meta = ChapterMeta.fromEpub(book);
    _controller = EpubController(document: book, position: _book.position);
    _config = await libraryApi.loadConfig();
    _configController.add(_config);
    _subscription = _controller.currentValueStream.listen((event) {
      debounce.execute(() {
        final position = event!.position.index;
        _book = _book.copyWith(
          position: position,
          readAt: DateTime.now(),
        );
        if (widget.loader != null)
          widget.loader!.update(_book);
        else
          libraryApi.updateBook(_book);
      });
    });
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void goToPage() async {
    FancyDialog.field(context, label: 'Page Number');
  }

  void showMeaning(String word) {
    Pages.findWord(context, word: word);
  }

  void showChapters() async {
    final chapters = await _controller.tableOfContentsStream.first;
    final position = await Pages.showChapterOverViewPage(
      context,
      chapters: chapters!,
    );
    if (position is int) {
      _controller.jumpTo(index: position);
    }
  }

  void showConfig() async {
    final config = await EpubConfigScreen.show(context);
    if (config is EpubConfig) {
      _config = config;
      _configController.add(config);
    }
  }

  void addProse(String text) async {
    addBookmark(text, ['PROSE']);
  }

  void addWord(String word) async {
    addBookmark(word, ['WORD']);
  }

  void addBookmark(String text, [List<String> tags = const []]) async {
    Pages.addBookmark(
      context,
      bookmark: Bookmark(
        position: _controller.position!,
        text: text,
        tags: tags,
        title: _book.title,
        path: _book.filePath,
        bookId: _book.id!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<EpubConfig>(
          stream: _configController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return StyledEpubView(
                controller: _controller,
                config: snapshot.data!,
                onTapBattery: showConfig,
                onTapChapter: showChapters,
                onTapProgress: () => Pages.showBrightnessControlPage(context),
                actionsBuilder: (selection) => [
                  ActionButton(
                    label: 'Search',
                    onTap: () => showMeaning(selection),
                  ),
                  ActionButton(
                    label: 'Bookmark',
                    onTap: () => addBookmark(selection),
                  ),
                  if (selection.contains(' '))
                    ActionButton(
                      label: 'Prose',
                      onTap: () => addProse(selection),
                    ),
                  if (!selection.contains(' '))
                    ActionButton(
                      label: 'Word',
                      onTap: () => addWord(selection),
                    ),
                ],
                meta: meta,
              );
            return Center(
              child: BouncingDotsIndiactor(),
            );
          },
        ),
      ),
    );
  }
}
