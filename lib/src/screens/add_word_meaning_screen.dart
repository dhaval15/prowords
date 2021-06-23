import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../api/api.dart';

class AddWordMeaningScreen extends StatefulWidget {
  final WordMeaning meaning;

  const AddWordMeaningScreen({
    required this.meaning,
  });

  @override
  _AddWordMeaningScreenState createState() => _AddWordMeaningScreenState();
}

class _AddWordMeaningScreenState extends State<AddWordMeaningScreen> {
  late DictionaryEntry entry;
  late StreamController<int> _controller;

  @override
  void initState() {
    super.initState();
    entry = widget.meaning.toEntry([]);
    _controller = StreamController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  void add() async {
    FancyDialog.loading(context, label: 'Adding ...');
    await Providers.of<PersonalDictionaryApi>(context).insertEntry(entry);
    Navigator.of(context)..pop()..pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              entry.word,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            TagField(
              tags: {},
              onChanged: (tags) {
                entry = entry.copyWith(tags: tags.toList());
                _controller.add(tags.length);
              },
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
              text: entry.definition,
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
              text: entry.example,
              linkStyle: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<int>(
          stream: _controller.stream,
          initialData: entry.tags.length,
          builder: (context, snapshot) {
            return snapshot.data! > 0
                ? FloatingActionButton(
                    onPressed: add,
                    child: Icon(Icons.done),
                  )
                : SizedBox();
          }),
    );
  }
}
