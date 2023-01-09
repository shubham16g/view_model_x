import 'package:flutter/widgets.dart';

/// Abstract generic class which extends [ChangeNotifier] and stores value
abstract class AnyFlow<T> extends ChangeNotifier {
  T _value;

  AnyFlow(this._value);
}

/// [SharedFlow] is used to send data to the listeners.
class SharedFlow<T> extends AnyFlow<T?> {
  SharedFlow() : super(null);

  /// get the last emitted value
  T? get lastEmitValue => _value;
}

/// [MutableSharedFlow] is inherited from [SharedFlow]. It can emit the value.
class MutableSharedFlow<T> extends SharedFlow<T> {
  /// emit and notify listeners
  void emit(T data) {
    _value = data;
    notifyListeners();
  }
}

/// [StateFlow] stores value and notify listeners whenever it changes.
class StateFlow<T> extends AnyFlow<T> {
  /// get the current value.
  T get value => _value;

  StateFlow(T value) : super(value);
}

/// [MutableStateFlow] is inherited from [StateFlow]. It can change/update the value.
class MutableStateFlow<T> extends StateFlow<T> {
  MutableStateFlow(super.value);

  /// change the value and notify listeners
  set value(T value) {
    _value = value;
    notifyListeners();
  }

  /// update the value and notify listeners
  void update(void Function(T value) updater) {
    updater(value);
    notifyListeners();
  }
}
