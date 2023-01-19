import 'package:flutter/widgets.dart';

/// [SharedFlow] is used to send data to the listeners.
class SharedFlow<T> extends ChangeNotifier {
  T? _value;

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
class StateFlow<T> extends ChangeNotifier {
  T _value;
  final bool notifyOnSameValue;

  /// get the current value.
  T get value => _value;

  /// If [notifyOnSameValue] is set to false, whenever you call `stateFlow.value = newValue`
  /// where newValue is same as current value, it will not notify listeners. by default it is set to true.
  StateFlow(this._value, {this.notifyOnSameValue = true});
}

/// [MutableStateFlow] is inherited from [StateFlow]. It can change/update the value.
class MutableStateFlow<T> extends StateFlow<T> {
  MutableStateFlow(super.value, {super.notifyOnSameValue});

  /// change the value and notify listeners
  set value(T value) {
    if (_value != value || notifyOnSameValue) {
      _value = value;
      notifyListeners();
    }
  }

  /// update the value and notify listeners
  void update(void Function(T value) updater) {
    updater(value);
    notifyListeners();
  }
}
