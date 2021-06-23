import 'package:flutter/material.dart';
import '../styles/styles.dart';

class WarningSignal extends StatelessWidget {
  final String? message;

  const WarningSignal([this.message]);
  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: 6,
      height: 6,
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
    if (message != null)
      return InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () {
          Messanger.of(context).showWarning(message!);
        },
        child: child,
      );
    return child;
  }
}
