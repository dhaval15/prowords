import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prowords/src/widgets/widgets.dart';
import 'package:sembast/sembast.dart';
import 'dictionary/dictionary.dart';
import 'models/models.dart';
import 'screens/screens.dart';
import 'styles/styles.dart';
import 'api/api.dart';

class ProwordsApp extends StatelessWidget {
  Future<List> get initializedApis => Future.microtask(() async {
        if (Platform.isAndroid)
          return _initializeAndroidApis();
        else if (Platform.isLinux) return _initializeLinuxApis();
        throw 'Platform not supported yet';
      });

  @override
  Widget build(BuildContext context) {
    return SchemeProvider(
      scheme: Schemes.gruvboxDark,
      builder: (context, scheme) {
        return FutureBuilder<List>(
          future: initializedApis,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Providers(
                data: snapshot.data!,
                child: MaterialApp(
                  theme: scheme.theme,
                  initialRoute: Screens.APP_DRAWER,
                  onGenerateRoute: Screens.onGenerateRoute,
                  debugShowCheckedModeBanner: false,
                ),
              );
            if (snapshot.hasError)
              return MaterialApp(
                home: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            return Center(
              child: BouncingDotsIndiactor(),
            );
          },
        );
      },
    );
  }
}

Future<List> _initializeLinuxApis() async {
  final dictonaryApi = PersonalDictionaryApi(
    dbPath: 'dictionary.db',
    store: stringMapStoreFactory.store('mywords'),
  );
  await dictonaryApi.init();
  final libraryApi = LibraryApi(
    configPath: '/home/dhaval/Dev/space/prowords/config.json',
    store: stringMapStoreFactory.store('books'),
    recentStore: stringMapStoreFactory.store('recents'),
    dbPath: 'books.db',
  );
  await libraryApi.init();
  final bookmarksApi = BookmarksApi(
    store: stringMapStoreFactory.store('bookmarks'),
    dbPath: 'bookmarks.db',
  );
  await bookmarksApi.init();
  return [
    DictionaryApi(
      historyPath: 'recents.txt',
      dictionaries: [
        DictionaryDotDev(),
        UrbanDictionary(),
      ],
    ),
    dictonaryApi,
    libraryApi,
    bookmarksApi,
  ];
}

Future<List> _initializeAndroidApis() async {
  if (await Permission.storage.isGranted ||
      (await Permission.storage.request() == PermissionStatus.granted)) {
    final dir = await getExternalStorageDirectory();
    final path = join(dir!.parent.parent.parent.parent.path, 'Prowords');
    final dictonaryApi = PersonalDictionaryApi(
      dbPath: join(path, 'dictionary.db'),
      store: stringMapStoreFactory.store('mywords'),
    );
    await dictonaryApi.init();
    final libraryApi = LibraryApi(
      configPath: join(path, 'config.json'),
      store: stringMapStoreFactory.store('books'),
      recentStore: stringMapStoreFactory.store('recents'),
      dbPath: join(path, 'books.db'),
    );
    await libraryApi.init();
    final bookmarksApi = BookmarksApi(
      store: stringMapStoreFactory.store('bookmarks'),
      dbPath: join(path, 'bookmarks.db'),
    );
    await bookmarksApi.init();
    return [
      DictionaryApi(
        historyPath: join(path, 'recents.txt'),
        dictionaries: [
          DictionaryDotDev(),
          UrbanDictionary(),
        ],
      ),
      dictonaryApi,
      libraryApi,
      bookmarksApi,
    ];
  }
  throw 'You have denied Access';
}

class DummyLibraryApi = LibraryApi with DummyLibraryMixin;

mixin DummyLibraryMixin on LibraryApi {
  @override
  Future<List<BookData>> all() async => [
        BookData(
          id: '-MdAV_cXxlG5VZjOFLUw',
          title: 'Death On The Nile',
          filePath:
              '/home/dhaval/Downloads/Agatha_Christie_-_Death_On_The_Nile.epub',
        ),
        BookData(
          id: '-MdAVksiPZPnasYAz9eh',
          title: 'The Stand',
          filePath:
              '/home/dhaval/Downloads/The Stand by King Stephen (z-lib.org).epub',
        ),
      ];
}
