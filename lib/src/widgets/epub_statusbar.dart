import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'swiper.dart';

class EpubStatusbar extends StatelessWidget {
  final EpubController controller;
  final EpubBook book;
  final Color textColor;
  final ChapterMeta meta;

  final GestureTapCallback? onTapChapter;
  final GestureTapCallback? onTapBattery;
  final GestureTapCallback? onTapProgress;

  const EpubStatusbar({
    required this.controller,
    required this.book,
    required this.textColor,
    required this.meta,
    this.onTapChapter,
    this.onTapBattery,
    this.onTapProgress,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EpubChapterViewValue?>(
      stream: controller.currentValueStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cv = snapshot.data!;
          CurrentMeta? currentMeta;
          String percentage;
          String? chapterHint;
          try {
            currentMeta = CurrentMeta.from(book, cv, meta);
            percentage = ((currentMeta.currentPage / meta.totalPages) * 100)
                .toStringAsFixed(1);
            // percentage = '${currentMeta.currentPage}/${meta.totalPages}';
            chapterHint =
                ' (${currentMeta.currentPageInChapter}/${meta.find(cv.chapterNumber)?.totalPages})';
          } catch (e) {
            percentage = 'NA';
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            child: DefaultTextStyle(
              style: TextStyle(color: textColor, fontSize: 11),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onTapBattery,
                    child: Row(
                      children: [
                        BatteryWidget(),
                        const SizedBox(width: 4),
                        TimeWidget(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onTapChapter,
                    child: Row(
                      children: [
                        Text(
                          trim(cv.chapter?.Title ?? '', 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (chapterHint != null)
                          Text(chapterHint, textScaleFactor: 0.9),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onTapProgress,
                    child: Row(
                      children: [
                        Text(
                          '$percentage',
                        ),
                        Text(
                          '%',
                          textScaleFactor: 0.8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

String trim(String text, int length) {
  if (text.length <= length) return text;
  final mid = length ~/ 2;
  return '${text.substring(0, mid)}...${text.substring(text.length - mid)}';
}

class BatteryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: Battery().batteryLevel,
      builder: (context, snapshot) => snapshot.hasData
          ? Row(
              children: [
                Text('${snapshot.data}'),
                Text(
                  '%',
                  textScaleFactor: 0.8,
                )
              ],
            )
          : SizedBox(),
    );
  }
}

class TimeWidget extends StatefulWidget {
  @override
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 30), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final time = generateTime();
    return Row(
      children: [
        Text(time[0]),
        const SizedBox(width: 1),
        Text(
          time[1],
          textScaleFactor: 0.8,
        ),
      ],
    );
  }

  List<String> generateTime() {
    final date = DateTime.now();
    final hour = date.hour == 0
        ? '12'
        : date.hour == 12
            ? '12'
            : fix(date.hour % 12);
    final minute = fix(date.minute);
    return ['$hour:$minute', date.hour < 12 ? 'AM' : 'PM'];
  }

  String fix(int number) => number < 10 ? '0$number' : '$number';
}
