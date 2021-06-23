import 'dart:async';
import 'dart:isolate';

Future<T> compute<T>(T Function() task) {
  final completer = Completer<T>();
  Isolate.spawn((message) {
    task();
  }, null);
  return completer.future;
}

abstract class Task<T> {
  Future<T> run();

  Future<T> execute() async {
    final completer = Completer<T>();
    final recievePort = ReceivePort();
    final isolate =
        await Isolate.spawn(_C._compute, _C(recievePort.sendPort, this));
    recievePort.listen((message) {
      if (message is T)
        completer.complete(message);
      else
        print(message);
    });
    final result = completer.future;
    isolate.kill();
    return result;
  }
}

class _C<T> {
  final SendPort port;
  final Task<T> task;

  _C(this.port, this.task);
  static void _compute(_C c) async {
    final result = await c.task.run();
    c.port.send(result);
  }
}
