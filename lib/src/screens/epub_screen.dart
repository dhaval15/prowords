import 'dart:async';
import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:prowords/src/pages/pages.dart';
import 'package:prowords/src/screens/epub_config_screen.dart';
import 'package:prowords/src/styles/styles.dart';

import '../api/api.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

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
    super.dispose();
  }

  void _init() async {
    libraryApi = Providers.of<LibraryApi>(context);
    final bytes = File(widget.book.filePath).readAsBytes();
    _configController = StreamController<EpubConfig>();
    final book = await EpubReader.readBook(bytes);
    print('Book Loaded');
    meta = ChapterMeta.fromEpub(book);
    _controller =
        EpubController(document: book, position: widget.book.position);
    _config = await libraryApi.loadConfig();
    print('Config Loaded');
    _configController.add(_config);
    _subscription = _controller.currentValueStream.listen((event) {
      debounce.execute(() {
        final position = event!.position.index;
        if (widget.loader != null)
          widget.loader!.update(widget.book.copyWith(
            position: position,
            readAt: DateTime.now(),
          ));
        else
          libraryApi.updateBook(widget.book.copyWith(
            position: position,
            readAt: DateTime.now(),
          ));
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
                actions: [
                  ActionButton(
                    label: 'Meaning',
                    onTap: showMeaning,
                  ),
                  ActionButton(
                    label: 'Bookmark',
                    onTap: (text) {},
                  ),
                  ActionButton(
                    label: 'Save Word',
                    onTap: (text) {},
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
