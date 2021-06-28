import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../styles/styles.dart';
import '../widgets/widgets.dart';
import '../utils/utils.dart';

class EpubConfigPage extends StatefulWidget {
  final EpubConfig config;
  final ScrollController? controller;

  const EpubConfigPage({
    required this.config,
    this.controller,
  });

  @override
  _EpubConfigPageState createState() => _EpubConfigPageState();
}

class _EpubConfigPageState extends State<EpubConfigPage> {
  late StreamController<EpubConfig> _controller;
  late EpubConfig _config;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<EpubConfig>();
    _config = widget.config;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      'NONE',
      ...GoogleFonts.asMap().keys,
    ];
    return SingleChildScrollView(
      controller: widget.controller,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Visual Options',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  Navigator.of(context).pop(_config);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<EpubConfig>(
              initialData: _config,
              stream: _controller.stream,
              builder: (context, snapshot) {
                return LivePreview(config: snapshot.data!);
              }),
          IntSlider(
            label: 'Font Size',
            value: _config.fontSize.toInt(),
            min: 10,
            max: 24,
            onChanged: (value) {
              _config = _config.copyWith(fontSize: value.toDouble());
              _controller.add(_config);
            },
          ),
          IntSlider(
            label: 'Indent',
            value: _config.indent.length,
            min: 0,
            max: 12,
            onChanged: (value) {
              _config = _config.copyWith(
                  indent: List.generate(value, (index) => ' ').join(''));
              _controller.add(_config);
            },
          ),
          IntSlider(
            label: 'Padding',
            value: _config.padding.toInt(),
            min: 0,
            max: 24,
            onChanged: (value) {
              _config = _config.copyWith(padding: value.toDouble());
              _controller.add(_config);
            },
          ),
          IntSlider(
            label: 'Height',
            value: ((_config.lineHeight - 1) * 10).toInt(),
            min: 0,
            max: 10,
            onChanged: (value) {
              _config = _config.copyWith(lineHeight: (value / 10) + 1);
              _controller.add(_config);
            },
          ),
          IntSlider(
            label: 'Paragraph Spacing',
            value: _config.paragraphSpacing.toInt(),
            min: 0,
            max: 16,
            onChanged: (value) {
              _config = _config.copyWith(paragraphSpacing: value / 2);
              _controller.add(_config);
            },
          ),
          const SizedBox(height: 8),
          DropdownField(
            label: 'Font',
            options: options,
            value: _config.fontFace,
            onChanged: (value) {
              _config = _config.copyWith(fontFace: value);
              _controller.add(_config);
            },
          ),
        ],
      ),
    );
  }
}

class LivePreview extends StatelessWidget {
  final EpubConfig config;

  const LivePreview({
    required this.config,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: config.backgroundColor,
          border: Border.all(color: Scheme.of(context).onBackground)),
      padding: EdgeInsets.symmetric(horizontal: config.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            generatedText1,
            style: config.textStyle,
            textAlign: config.textAlign,
          ),
          SizedBox(
            height: config.paragraphSpacing,
          ),
          Text(
            generatedText2,
            style: config.textStyle,
            textAlign: config.textAlign,
          ),
        ],
      ),
    );
  }

  String get generatedText1 => '${config.indent}"Hola Amigos" The Dev said.';
  String get generatedText2 =>
      '${config.indent}With android in his hand the user gave the Dev a mocking glance and got back to reading.';
}
