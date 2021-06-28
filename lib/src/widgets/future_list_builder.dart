import 'package:flutter/material.dart';

class FutureListBuilder<Model> extends StatelessWidget {
  final Future<List<Model>> future;
  final String? errorText;
  final String emptyText;
  final Widget loading;
  final Widget Function(BuildContext context, Model model) builder;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final Widget divider;

  const FutureListBuilder({
    required this.future,
    required this.builder,
    this.errorText,
    this.emptyText = 'Empty List',
    this.padding = const EdgeInsets.all(0),
    this.divider = const SizedBox(),
    this.loading = const Center(
      child: CircularProgressIndicator(),
    ),
    this.physics = const BouncingScrollPhysics(),
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Model>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isEmpty)
          return Center(
            child: Text(
              emptyText,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        if (snapshot.hasData && snapshot.data!.isNotEmpty)
          return ListView.separated(
            physics: physics,
            padding: padding,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) =>
                builder(context, snapshot.data![index]),
            separatorBuilder: (BuildContext context, int index) => divider,
          );
        if (snapshot.hasError)
          return Center(
            child: Text(errorText ?? '${snapshot.error}'),
          );
        return loading;
      },
    );
  }
}
