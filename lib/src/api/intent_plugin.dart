import 'dart:io';

import 'package:flutter/services.dart';

class IntentPlugin {
  static const _channel = MethodChannel('com.bluebird.prowords.intent');

  static Future<String?> getWord() async => Platform.isAndroid
      ? _channel.invokeMethod('getWord') as String?
      : 'stumbled';
}
