import 'package:flutter/material.dart';

class IntSlider extends StatefulWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final void Function(int value)? onChanged;

  const IntSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
  });
  @override
  _IntSliderState createState() => _IntSliderState();
}

class _IntSliderState extends State<IntSlider> {
  late int _value;
  late int _divisions;
  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _divisions = (widget.max - widget.min) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Text(widget.label),
          width: 64,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(trackHeight: 1),
            child: Slider(
              label: _value.toString(),
              divisions: _divisions,
              min: widget.min.toDouble(),
              max: widget.max.toDouble(),
              value: _value.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _value = value.toInt();
                });
                widget.onChanged?.call(_value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
