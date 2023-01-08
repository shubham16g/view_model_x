import 'package:flutter/widgets.dart';

abstract class AnyFlow<T> extends ChangeNotifier {
  T _value;
  T get value => _value;

  AnyFlow(this._value);
}

class SharedFlow<T> extends AnyFlow<T?>{
  SharedFlow() : super(null);
}

class MutableSharedFlow<T> extends SharedFlow<T>{
  void emit(T data){
    _value = data;
    notifyListeners();
  }
}

class StateFlow<T> extends AnyFlow<T> {
  StateFlow(T value): super(value);
}

class MutableStateFlow<T> extends StateFlow<T> {
  MutableStateFlow(super.value);

  set value(T value) {
    _value = value;
    notifyListeners();
  }

  void update(void Function(T value) updater) {
    updater(value);
    notifyListeners();
  }
}





