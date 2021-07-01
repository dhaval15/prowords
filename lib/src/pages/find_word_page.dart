import 'package:flutter/material.dart';
import '../dictionary/dictionary.dart';

import '../api/api.dart';
import '../widgets/widgets.dart';

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
  DictionaryResult? result;
  Future<DictionaryResult> fetchDictionaryResult(BuildContext context) async {
    if (result == null) {
      result = await Providers.of<DictionaryApi>(context).define(widget.word);
    }
    return result!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.onBackground.withOpacity(0.04);
    return FutureBuilder<DictionaryResult>(
      future: fetchDictionaryResult(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data!.results;
          final frequency = snapshot.data!.frequency;
          return ListView(
            controller: widget.controller,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(8),
            children: [
              Padding(
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
              ),
              for (final result in results)
                Container(
                  color: bg,
                  margin: EdgeInsets.only(bottom: 8),
                  child: result.builder(result.data),
                ),
            ],
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
