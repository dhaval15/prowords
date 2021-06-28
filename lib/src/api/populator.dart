import 'package:rxdart/rxdart.dart';

class Populater<T> {
  bool _isPopulated = false;
  final Future<T> Function() onPopulate;
  late T data;
  final BehaviorSubject<T> _subject = BehaviorSubject<T>();

  Populater({
    required this.onPopulate,
    required this.data,
  });

  Stream<T> get stream {
    populate().then((_) {
      if (_) notify();
    });
    return _subject.stream;
  }

  void mutate(T Function(T old) modifier) {
    this.data = modifier(data);
    notify();
  }

  void modify(void Function(T data) modifier) {
    modifier(data);
    notify();
  }

  Future<bool> populate() async {
    if (!_isPopulated) {
      try {
        data = await onPopulate();
        _isPopulated = true;
        return true;
      } catch (e) {
        _subject.addError(e);
      }
    }
    return false;
  }

  void populateWithData(T data) {
    this.data = data;
    _isPopulated = true;
  }

  void notify() {
    _subject.add(data);
  }

  void dispose() {
    _subject.close();
  }
}
