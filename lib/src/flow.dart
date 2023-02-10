import 'package:flutter/widgets.dart';

mixin BaseStateFlow<T> on Listenable {
  T get value;
  bool get notifyOnSameValue;
  set value(T value);
  void update(void Function(T value) updater);
  T watch(BuildContext context);
}

mixin BaseSharedFlow<T> on Listenable {
  T? get lastEmitValue;
  void emit(T value);
}

/// [SharedFlow] is used to send data to the listeners by emitting the value
class SharedFlow<T> extends ChangeNotifier with BaseSharedFlow<T> {
  T? _value;

  SharedFlow({void Function()? dispose});

  /// get the last emitted value
  @override
  T? get lastEmitValue => _value;

  /// emit and notify listeners
  @override
  void emit(T data) {
    _value = data;
    notifyListeners();
  }
}

/// [StateFlow] stores value and notify listeners whenever it changes or updated.
class StateFlow<T> extends ChangeNotifier with BaseStateFlow<T> {
  /// If [notifyOnSameValue] is set to false, whenever you call `stateFlow.value = newValue`
  /// where newValue is same as current value, it will not notify listeners. by default it is set to true.
  StateFlow(this._value, {this.notifyOnSameValue = true}) {
    addListener(_defaultListener);
  }

  T _value;
  @override
  final bool notifyOnSameValue;

  /// get the current value.
  @override
  T get value => _value;

  /// watch is experimental for now, it will rebuild the widget of context when value is changed or updated.
  @override
  T watch(BuildContext context) {
    _contexts[context] = true;
    return _value;
  }

  final Map<BuildContext, bool> _contexts = {};

  @override
  void dispose() {
    _contexts.clear();
    debugPrint("StateFlow Disposed");
    removeListener(_defaultListener);
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
  @override
  set value(T value) {
    if (_value != value || notifyOnSameValue) {
      _value = value;
      notifyListeners();
    }
  }

  /// update the value and notify listeners
  @override
  void update(void Function(T value) updater) {
    updater(value);
    notifyListeners();
  }
}
