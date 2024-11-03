import 'package:flutter/widgets.dart';

/// [SharedFlow] is used to send data to the listeners by emitting the value
class SharedFlow<T> extends ChangeNotifier {
  T? _value;
  bool _disposed = false;

  /// get the last emitted value
  T? get lastEmitValue => _value;

  /// emit and notify listeners
  void emit(T data) {
    _value = data;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}