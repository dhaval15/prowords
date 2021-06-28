import 'package:flutter/material.dart';

import '../api/api.dart';
import '../widgets/widgets.dart';
import '../screens/screens.dart';

class FindWordPage extends StatefulWidget {
  final String word;
  final ScrollController? controller;

  const FindWordPage({
    required this.word,
    this.controller,
  });

  @override
  _FindWordPageState createState() => _FindWordPageState();
}

class _FindWordPageState extends State<FindWordPage> {
  WordDefineResult? result;
  Future<WordDefineResult> fetchMeanings(BuildContext context) async {
    if (result == null) {
      result = await Providers.of<WordsApi>(context).define(widget.word);
    }
    return result!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.onBackground.withOpacity(0.04);
    return FutureBuilder<WordDefineResult>(
      future: fetchMeanings(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final meanings = snapshot.data!.meanings;
          final frequency = snapshot.data!.frequency;
          return ListView.builder(
            controller: widget.controller,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(8),
            itemCount: meanings.length + 1,
            itemBuilder: (context, index) {
              if (index == 0)
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.word,
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
                    Navigator.of(context)
                        .pushNamed(Screens.WORD_MEANING, arguments: meaning);
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
    );
  }
}
