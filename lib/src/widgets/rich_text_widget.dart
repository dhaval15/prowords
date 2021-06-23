import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RichTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? normal;
  final TextStyle linkStyle;
  final void Function(String link)? onTap;
  static final regexp = RegExp('\[[A-Za-z]+\]');

  const RichTextWidget({
    Key? key,
    required this.text,
    this.normal,
    required this.linkStyle,
    this.onTap,
  }) : super(key: key);

  List<TextSpan> buildSpan(String text) {
    final matches = regexp.allMatches(text);
    final spans = <TextSpan>[];
    var start = 0;
    for (final match in matches) {
      if (start != match.start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      final link = text.substring(match.start + 1, match.end - 1);
      spans.add(TextSpan(
        text: link,
        style: linkStyle,
        recognizer: onTap != null
            ? (TapGestureRecognizer()
              ..onTap = () {
                onTap!(link);
              })
            : null,
      ));
      start = match.end;
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: buildSpan(text),
        style: normal ?? Theme.of(context).textTheme.bodyText2,
        // style: normal,
      ),
    );
  }
}
