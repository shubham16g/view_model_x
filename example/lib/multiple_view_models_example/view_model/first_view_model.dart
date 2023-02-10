import 'package:flutter/cupertino.dart';
import 'package:view_model_x/view_model_x.dart';

class FirstViewModel extends ViewModel {
  // initialize StateFlow
  BaseStateFlow<int> get counterStateFlow => stateFlow("counter", 1);

  void increment() {
    // by changing the value, listeners were notified
    counterStateFlow.value = counterStateFlow.value + 1;
    // counterStateFlow
  }
}
