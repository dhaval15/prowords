import 'package:flutter/material.dart';
import 'package:frooti/frooti.dart';
import '../dictionary/dictionary.dart';
import '../widgets/widgets.dart';
import '../api/api.dart';
import 'screens.dart';

class SavedMeaningsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.onBackground.withOpacity(0.04);
    return Scaffold(
      appBar: AppBar(
        leading: DrawerIcon(),
        title: Text('Saved Words'),
      ),
      body: SafeArea(
        child: FutureListBuilder<dynamic>(
          padding: const EdgeInsets.all(8),
          future: Providers.of<PersonalDictionaryApi>(context).all(),
          builder: (context, meaning) => Container(
            color: bg,
            margin: EdgeInsets.only(bottom: 8),
            child: UrbanWordDefinitionTile(
              definition: meaning,
              onTap: () {
                Navigator.of(context)
                    .pushNamed(Screens.WORD_MEANING, arguments: meaning);
              },
            ),
          ),
        ),
      ),
    );
  }
}
