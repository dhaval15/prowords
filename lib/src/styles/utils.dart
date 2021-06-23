import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'scheme.dart';

class Messanger {
  final BuildContext context;

  const Messanger.of(this.context);

  void showWarning(String text) {
    ScaffoldMessenger.of(context).showSnackBar(_message(context, text));
  }

  SnackBar _message(BuildContext context, String text) {
    final scheme = Scheme.of(context);
    return SnackBar(
      elevation: 4,
      backgroundColor: scheme.brightness == Brightness.dark
          ? scheme.background.lighten(0.05)
          : scheme.background.darken(0.05),
      content: Text(
        text,
        style: TextStyle(color: scheme.onBackground),
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
