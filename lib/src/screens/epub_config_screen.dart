import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prowords/src/api/api.dart';
import 'package:prowords/src/pages/pages.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class EpubConfigScreen extends StatefulWidget {
  final EpubConfig config;

  const EpubConfigScreen({
    required this.config,
  });

  static Future<EpubConfig?> show(BuildContext context) async {
    final api = Providers.of<LibraryApi>(context);
    final config = await Navigator.of(context)
        .pushNamed(Screens.EPUB_CONFIG, arguments: await api.loadConfig());
    if (config is EpubConfig) {
      await api.saveConfig(config);
      return config;
    }
  }

  @override
  _EpubConfigScreenState createState() => _EpubConfigScreenState();
}

class _EpubConfigScreenState extends State<EpubConfigScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              Navigator.of(context).pop(_config);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<EpubConfig>(
              initialData: _config,
              stream: _controller.stream,
              builder: (context, snapshot) =>
                  LivePreview(config: snapshot.data!),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
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
                          indent:
                              List.generate(value, (index) => ' ').join(''));
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
                    max: 24,
                    onChanged: (value) {
                      _config =
                          _config.copyWith(paragraphSpacing: value.toDouble());
                      _controller.add(_config);
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownField(
                    label: 'Text Align',
                    options: TextAlign.values
                        .map((e) => e.toString().split('.')[1].toUpperCase())
                        .toList(),
                    value: _config.textAlign
                        .toString()
                        .split('.')[1]
                        .toUpperCase(),
                    onChanged: (value) {
                      switch (value) {
                        case 'START':
                          _config =
                              _config.copyWith(textAlign: TextAlign.start);
                          break;
                        case 'LEFT':
                          _config = _config.copyWith(textAlign: TextAlign.left);
                          break;
                        case 'CENTER':
                          _config =
                              _config.copyWith(textAlign: TextAlign.center);
                          break;
                        case 'END':
                          _config = _config.copyWith(textAlign: TextAlign.end);
                          break;
                        case 'RIGHT':
                          _config =
                              _config.copyWith(textAlign: TextAlign.right);
                          break;
                        case 'JUSTIFY':
                          _config =
                              _config.copyWith(textAlign: TextAlign.justify);
                          break;
                        default:
                          return;
                      }
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
                  const SizedBox(height: 8),
                  ColorField(
                    label: 'Font Color',
                    value: _config.fontColor,
                    onChanged: (value) {
                      _config = _config.copyWith(fontColor: value);
                      _controller.add(_config);
                    },
                  ),
                  const SizedBox(height: 8),
                  ColorField(
                    label: 'Background Color',
                    value: _config.backgroundColor,
                    onChanged: (value) {
                      _config = _config.copyWith(backgroundColor: value);
                      _controller.add(_config);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
