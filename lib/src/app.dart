import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prowords/src/widgets/widgets.dart';
import 'package:sembast/sembast.dart';
import 'screens/screens.dart';
import 'styles/styles.dart';
import 'api/api.dart';

class ProwordsApp extends StatelessWidget {
  Future<List> get initializedApis => Future.microtask(() async {
        if (Platform.isAndroid) {
          return [];
        } else {
          final wordsApi =
              WordsApi('/home/dhaval/Dev/space/prowords/recents.txt');
          final dictonaryApi = PersonalDictionaryApi(
            dbPath: 'dictionary.db',
            store: stringMapStoreFactory.store('mywords'),
          );
          await dictonaryApi.init();
          return [
            dictonaryApi,
            wordsApi,
          ];
        }
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
                  initialRoute: Screens.HOME,
                  onGenerateRoute: Screens.onGenerateRoute,
                  debugShowCheckedModeBanner: false,
                ),
              );
            if (snapshot.hasError)
              return Center(
                child: Text(snapshot.error.toString()),
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
