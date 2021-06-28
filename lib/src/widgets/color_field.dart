import 'package:flutter/material.dart';

import 'color_picker_dialog.dart';

class ColorField extends StatefulWidget {
  final String label;
  final void Function(Color color) onChanged;
  final Color value;

  const ColorField({
    required this.label,
    required this.onChanged,
    required this.value,
  });

  @override
  _ColorFieldState createState() => _ColorFieldState();
}

class _ColorFieldState extends State<ColorField> {
  late Color value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            SizedBox(
              child: Text(widget.label),
              width: 64,
            ),
            const Spacer(),
            Text(toReadableString(value)),
            SizedBox(width: 4),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black87.withOpacity(0.5),
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(32),
                  color: value),
            ),
          ],
        ),
      ),
      onTap: () async {
        final color = await _onEdit(context);
        if (color != null) {
          setState(() {
            this.value = color;
          });
          widget.onChanged(color);
        }
      },
    );
  }

  Future _onEdit(BuildContext context) =>
      ColorPickerDialog.show(context, color: value);
}

String toReadableString(Color value) {
  final color = value.toString();
  final buffer = StringBuffer();
  buffer.write('#');
  final c = color.split('(0x')[1].split(')')[0];
  buffer.write(c.substring(2));
  buffer.write(c.substring(0, 2));
  return buffer.toString();
}
