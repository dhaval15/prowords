import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frooti/frooti.dart';
import 'package:prowords/src/api/api.dart';
import 'package:prowords/src/utils/epub_config.dart';

import '../styles/styles.dart';
import 'screens.dart';

class AppDrawerScreen extends StatefulWidget {
  @override
  _AppDrawerScreenState createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  final controller = InnerDrawerController();

  @override
  Widget build(BuildContext context) {
    final color = Scheme.of(context).background.withOpacity(0.8);
    return Scaffold(
      backgroundColor: Scheme.of(context).primary,
      body: InnerDrawer(
        color: color,
        initialArguments: 0,
        drawer: Container(
          color: color,
          child: Builder(builder: (context) {
            return SafeArea(
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // _tile(context, 'Reading', Screens.EPUB),
                        _tile(context, 'Recents', Screens.RECENTS),
                        _tile(context, 'Library', Screens.LIBRARY),
                        // _tile(context, 'Words', Screens.WORDS),
                        ListTile(
                          title: Text('Options'),
                          onTap: () async {
                            final api = Providers.of<LibraryApi>(context);
                            final config = await Navigator.of(context)
                                .pushNamed(Screens.EPUB_CONFIG,
                                    arguments: await api.loadConfig());
                            if (config is EpubConfig)
                              await api.saveConfig(config);
                          },
                        ),
                        // _tile(context, 'Settings', Screens.SETTINGS),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        controller: controller,
        onGenerateRoute: Screens.onGenerateRoute,
        initialRoute: Screens.RECENTS,
      ),
    );
  }

  Widget _tile(BuildContext context, String label, String route) => ListTile(
        title: Text(label),
        onTap: () {
          InnerDrawer.of(context).pushNamed(route);
        },
      );

  Widget _rootTile(BuildContext context, String label, String route,
          [FutureOr? arguments]) =>
      ListTile(
        title: Text(label),
        onTap: arguments != null
            ? () async {
                Navigator.of(context)
                    .pushNamed(route, arguments: await arguments);
              }
            : () {
                Navigator.of(context).pushNamed(route);
              },
      );
}
