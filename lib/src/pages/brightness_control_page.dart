import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import '../widgets/widgets.dart';

class BrightnessControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Brightness',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<double>(
          future: Screen.brightness,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return IntSlider(
                value: (snapshot.data! * 100).toInt().clamp(0, 100),
                min: 0,
                max: 100,
                onChanged: (value) {
                  Screen.setBrightness(value / 100);
                },
              );
            return Center(
              child: BouncingDotsIndiactor(),
            );
          },
        ),
      ],
    );
  }
}
