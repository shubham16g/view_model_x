import 'package:flutter/widgets.dart';
import 'package:view_model_x/src/view_model.dart';
import 'package:view_model_x/src/view_model_provider.dart';

/// [SharedFlow] is used to send data to the listeners by emitting the value
class SharedFlow<T> extends ChangeNotifier {
  T? _value;

  /// get the last emitted value
  T? get lastEmitValue => _value;

  /// emit and notify listeners
  void emit(T data) {
    _value = data;
    notifyListeners();
  }
}

/// [StateFlow] stores value and notify listeners whenever it changes or updated.
class StateFlow<T> extends ChangeNotifier {
  T _value;
  final bool notifyOnSameValue;

  /// get the current value.
  T get value => _value;

  /// If [notifyOnSameValue] is set to false, whenever you call `stateFlow.value = newValue`
  /// where newValue is same as current value, it will not notify listeners. by default it is set to true.
  StateFlow(this._value, {this.notifyOnSameValue = true}) {
    addListener(_defaultListener);
  }

  /// watch is experimental for now, it will rebuild the widget of context when value is changed or updated.
  T watch(BuildContext context) {
    contexts[context] = true;
    return _value;
  }

  final Map<BuildContext, bool> contexts = {};

  @override
  void dispose() {
    contexts.clear();
    debugPrint("StateFlow Disposed");
    removeListener(_defaultListener);
    super.dispose();
  }

  void _defaultListener() {
    for (final context in contexts.keys) {
      try {
        if (context is Element) {
          (context).markNeedsBuild();
        }
      } catch (_) {}
    }
    contexts.clear();
  }

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
