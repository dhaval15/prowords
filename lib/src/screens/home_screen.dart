import 'package:flutter/material.dart';
import '../api/api.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class HomeScreen extends StatefulWidget {
  final String? word;

  const HomeScreen({
    required this.word,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String word;
  Future<WordDefineResult> fetchMeanings(BuildContext context) =>
      Future.microtask(() async {
        word = widget.word ?? await IntentPlugin.getWord() ?? 'Prose';
        return Providers.of<WordsApi>(context).define(word);
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.onBackground.withOpacity(0.04);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<WordDefineResult>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final meanings = snapshot.data!.meanings;
              final frequency = snapshot.data!.frequency;
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: meanings.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            word,
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$frequency',
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.hintColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    );
                  final meaning = meanings[index - 1];
                  return Container(
                    color: bg,
                    margin: EdgeInsets.only(bottom: 8),
                    child: WordMeaningTile(
                      meaning: meaning,
                      onTap: () {
                        Navigator.of(context).pushNamed(Screens.WORD_MEANING,
                            arguments: meaning);
                      },
                    ),
                  );
                },
              );
            }
            if (snapshot.hasError)
              return Center(
                child: Text(snapshot.error.toString()),
              );
            return Center(
              child: BouncingDotsIndiactor(),
            );
          },
          future: fetchMeanings(context),
        ),
      ),
    );
  }
}
