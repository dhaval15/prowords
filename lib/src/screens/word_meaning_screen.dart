import 'package:flutter/material.dart';

import '../api/api.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class WordMeaningScreen extends StatelessWidget {
  final WordMeaning meaning;

  const WordMeaningScreen({required this.meaning});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Text(
                  meaning.word,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                FutureBuilder<DictionaryEntry?>(
                    future: Providers.of<PersonalDictionaryApi>(context)
                        .checkWordForEntry(meaning),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return WarningSignal(
                            'You Visited This ${snapshot.data!.frequency} Times');
                      return IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              Screens.ADD_WORD_MEANING,
                              arguments: meaning);
                        },
                        icon: Icon(Icons.add),
                      );
                    }),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Definition',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            RichTextWidget(
              text: meaning.definition,
              linkStyle: TextStyle(color: Colors.blue),
              onTap: (link) {},
            ),
            const SizedBox(height: 4),
            const Text(
              'Example',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
            RichTextWidget(
              text: meaning.example,
              linkStyle: TextStyle(color: Colors.blue),
              onTap: (link) {
                Navigator.of(context).pushNamed(Screens.HOME, arguments: link);
              },
            ),
          ],
        ),
      ),
    );
  }
}
