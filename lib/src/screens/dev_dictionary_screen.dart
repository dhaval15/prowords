import 'package:flutter/material.dart';
import 'package:prowords/src/widgets/word_definition_tile.dart';
import '../api/api.dart';

class DevDictionaryScreen extends StatefulWidget {
  @override
  _DevDictionaryScreenState createState() => _DevDictionaryScreenState();
}

class _DevDictionaryScreenState extends State<DevDictionaryScreen> {
  var result = <WordDefinition>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              onChanged: (text) async {
                result = await DictionaryDevApi().define(text);
                setState(() {});
              },
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: result.length,
                separatorBuilder: (context, _) => Divider(),
                itemBuilder: (BuildContext context, int index) =>
                    WordDefinitionTile(definition: result[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
