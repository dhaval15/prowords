import 'package:flutter/material.dart';

class TapStack extends StatelessWidget {
  final Widget child;
  final Widget top;
  final Widget bottom;

  const TapStack({
    required this.child,
    required this.top,
    required this.bottom,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        top,
        bottom,
      ],
    );
  }
}
