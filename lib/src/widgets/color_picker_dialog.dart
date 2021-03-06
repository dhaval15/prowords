import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color color;

  static Future<Color> show(BuildContext context, {Color? color}) async {
    final pickedColor = await showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        color: color ?? Colors.white,
      ),
    );
    return pickedColor;
  }

  const ColorPickerDialog({this.color = Colors.white});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _color;

  static List<Color> _colors = [];

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorPicker(
            pickerColor: _color,
            onColorChanged: (color) {
              _color = color;
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
          SizedBox(height: 12),
          ColorHistory(
            colors: _colors,
            onColorChanged: (color) {
              setState(() {
                _color = color;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Select'),
          onPressed: () {
            final index =
                _colors.indexWhere((color) => color.value == _color.value);
            if (index > -1) _colors.removeAt(index);
            _colors.insert(0, _color);
            Navigator.of(context).pop(_color);
          },
        ),
      ],
    );
  }
}

class ColorHistory extends StatelessWidget {
  final List<Color> colors;
  final Function(Color) onColorChanged;

  const ColorHistory({
    required this.colors,
    required this.onColorChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: colors
          .map(
            (color) => GestureDetector(
              onTap: () {
                onColorChanged(color);
              },
              child: Container(
                width: 24,
                height: 24,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
