import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final List<String> options;
  final String value;
  final String label;
  final void Function(String option) onChanged;

  const DropdownField({
    required this.options,
    required this.value,
    this.label = '',
    required this.onChanged,
  });
  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        border: Theme.of(context).inputDecorationTheme.border,
        labelText: widget.label,
      ),
      child: DropdownButton<String>(
        onChanged: (text) {
          setState(() {
            _value = text!;
          });
          widget.onChanged(_value);
        },
        underline: SizedBox(),
        value: _value,
        selectedItemBuilder: (context) => widget.options
            .map((option) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(option),
                ))
            .toList(),
        isExpanded: true,
        items: widget.options
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
      ),
    );
  }
}
