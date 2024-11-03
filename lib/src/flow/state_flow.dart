import 'package:flutter/widgets.dart';

/// [StateFlow] stores value and notify listeners whenever it changes or updated.
class StateFlow<T> extends ChangeNotifier {
  T _value;
  final bool notifyOnSameValue;
  bool _disposed = false;

  /// get the current value.
  T get value => _value;

  /// If [notifyOnSameValue] is set to false, whenever you call `stateFlow.value = newValue`
  /// where newValue is same as current value, it will not notify listeners. by default it is set to true.
  StateFlow(this._value, {this.notifyOnSameValue = true}) {
    addListener(_defaultListener);
  }

  /// watch is experimental for now, it will rebuild the widget of context when value is changed or updated.
  T bind(BuildContext context) {
    _contexts[context] = true;
    return _value;
  }

  final Map<BuildContext, bool> _contexts = {};

  @override
  void dispose() {
    _contexts.clear();
    removeListener(_defaultListener);
    _disposed = true;
    super.dispose();
  }

  void _defaultListener() {
    for (final context in _contexts.keys) {
      try {
        if (context is Element) {
          (context).markNeedsBuild();
        }
      } catch (_) {}
    }
    _contexts.clear();
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

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
