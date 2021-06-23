import 'package:flutter/widgets.dart';

class Providers extends StatelessWidget {
  final Map<Type, dynamic> _data;
  final Widget child;

  Providers({
    required List data,
    required this.child,
  }) : this._data =
            Map.fromEntries(data.map((e) => MapEntry(e.runtimeType, e)));

  static T of<T>(BuildContext context) =>
      context.findAncestorWidgetOfExactType<Providers>()!._data[T];

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
