import 'package:flutter/material.dart';
import 'package:frooti/frooti.dart';
import 'package:prowords/src/api/providers.dart';
import 'package:prowords/src/api/words_api.dart';
import 'package:prowords/src/styles/styles.dart';
import 'package:prowords/src/widgets/widgets.dart';

class RecentWordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DrawerIcon(),
        title: Text('Recent Words'),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontSize: 16,
          color: Scheme.of(context).onBackground,
        ),
        child: FutureListBuilder<String>(
          padding: const EdgeInsets.all(16),
          future: Providers.of<WordsApi>(context).recentWords(),
          builder: (BuildContext context, model) {
            final splits = model.split(':');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(splits[1]),
                  const Spacer(),
                  Text(splits[0]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
