import 'package:flutter/widgets.dart';

class Providers extends StatelessWidget {
  final List _data;
  final Widget child;

  Providers({
    required List data,
    required this.child,
  }) : this._data = data;

  static T of<T>(BuildContext context) => context
      .findAncestorWidgetOfExactType<Providers>()!
      ._data
      .whereType<T>()
      .first;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
