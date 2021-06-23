import 'package:flutter/material.dart';
import '../api/api.dart';

class WordMeaningTile extends StatelessWidget {
  final WordMeaning meaning;
  final GestureTapCallback? onTap;

  const WordMeaningTile({
    Key? key,
    required this.meaning,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(meaning.word),
      subtitle: Text(meaning.definition),
      onTap: onTap,
    );
  }
}
