import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'loading_indicator.dart';

class CustomStreamListBuilder<Model> extends StatelessWidget {
  final Stream<List<Model>> stream;
  final String? errorText;
  final String emptyText;
  final Widget loading;
  final Widget Function(
      BuildContext context, Model model, int index, int length) builder;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final Widget separator;

  const CustomStreamListBuilder({
    required this.stream,
    required this.builder,
    this.errorText,
    this.emptyText = 'Empty List',
    this.padding = const EdgeInsets.all(0),
    this.loading = const Center(
      child: BouncingDotsIndiactor(),
    ),
    this.separator = const SizedBox(height: 0),
    this.physics = const BouncingScrollPhysics(),
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Model>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) if (snapshot.data!.isEmpty)
          return Center(
            child: Text(
              emptyText,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        else
          return ListView.separated(
            physics: physics,
            padding: padding,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) => builder(
                context, snapshot.data![index], index, snapshot.data!.length),
            separatorBuilder: (BuildContext context, int index) => separator,
          );
        if (snapshot.hasError)
          return Center(
            child: Text(errorText ?? 'Something Went Wrong ${snapshot.error}'),
          );
        return loading;
      },
    );
  }
}

class StreamListBuilder<Model> extends StatelessWidget {
  final Stream<List<Model>> stream;
  final String? errorText;
  final String emptyText;
  final Widget loading;
  final Widget Function(BuildContext context, Model model, int index) builder;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final Widget divider;

  const StreamListBuilder({
    required this.stream,
    required this.builder,
    this.errorText,
    this.emptyText = 'Empty List',
    this.padding = const EdgeInsets.all(0),
    this.loading = const Center(
      child: BouncingDotsIndiactor(),
    ),
    this.divider = const SizedBox(height: 0),
    this.physics = const BouncingScrollPhysics(),
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Model>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) if (snapshot.data!.isEmpty)
          return Center(
            child: Text(
              emptyText,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        else
          return ListView.separated(
            physics: physics,
            padding: padding,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) =>
                builder(context, snapshot.data![index], index),
            separatorBuilder: (BuildContext context, int index) => divider,
          );
        if (snapshot.hasError)
          return Center(
            child: Text(
              snapshot.error is String
                  ? snapshot.error as String
                  : errorText ?? 'Something Went Wrong ${snapshot.error}',
            ),
          );
        return loading;
      },
    );
  }
}

class StreamGridBuilder<Model> extends StatelessWidget {
  final Stream<List<Model>> stream;
  final String? errorText;
  final String emptyText;
  final Widget loading;
  final Widget Function(BuildContext context, Model model, int index) builder;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final SliverGridDelegate gridDelegate;

  const StreamGridBuilder({
    required this.stream,
    required this.builder,
    this.errorText,
    this.emptyText = 'Empty List',
    this.padding = const EdgeInsets.all(0),
    this.loading = const Center(
      child: BouncingDotsIndiactor(),
    ),
    required this.gridDelegate,
    this.physics = const BouncingScrollPhysics(),
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Model>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) if (snapshot.data!.isEmpty)
          return Center(
            child: Text(
              emptyText,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        else
          return GridView.builder(
            gridDelegate: gridDelegate,
            physics: physics,
            padding: padding,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) =>
                builder(context, snapshot.data![index], index),
          );
        if (snapshot.hasError)
          return Center(
            child: Text(
              snapshot.error is String
                  ? snapshot.error as String
                  : errorText ?? 'Something Went Wrong ${snapshot.error}',
            ),
          );
        return loading;
      },
    );
  }
}

class StreamSliverListBuilder<Model> extends StatelessWidget {
  final Stream<List<Model>> stream;
  final String? errorText;
  final String emptyText;
  final Widget loading;
  final Widget Function(BuildContext context, Model model) builder;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final Widget separator;

  const StreamSliverListBuilder({
    required this.stream,
    required this.builder,
    this.errorText,
    this.emptyText = 'Empty List',
    this.padding = const EdgeInsets.all(0),
    this.loading = const Center(
      child: BouncingDotsIndiactor(),
    ),
    this.separator = const SizedBox(height: 0),
    this.physics = const BouncingScrollPhysics(),
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Model>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) if (snapshot.data!.isEmpty)
          return SliverPadding(
            padding: padding,
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  emptyText,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
          );
        else
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final int itemIndex = index ~/ 2;
                if (index.isEven)
                  return builder(context, snapshot.data![itemIndex]);
                return separator;
              },
              semanticIndexCallback: (Widget widget, int localIndex) {
                if (localIndex.isEven) {
                  return localIndex ~/ 2;
                }
                return null;
              },
              childCount: math.max(0, 2 * snapshot.data!.length - 1),
            ),
          );
        if (snapshot.hasError)
          return SliverToBoxAdapter(
            child: Padding(
              padding: padding,
              child: Center(
                child:
                    Text(errorText ?? 'Something Went Wrong ${snapshot.error}'),
              ),
            ),
          );
        return SliverPadding(
          padding: padding,
          sliver: SliverToBoxAdapter(
            child: Center(child: loading),
          ),
        );
      },
    );
  }
}
