import 'dart:async';

class Debounce {
  final Duration duration;
  Timer? timer;

  Debounce(this.duration);

  void execute(void Function() func) {
    timer?.cancel();
    timer = Timer(duration, func);
  }
}
