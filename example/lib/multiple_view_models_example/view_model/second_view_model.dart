import 'package:flutter/foundation.dart';
import 'package:view_model_x/view_model_x.dart';

class SecondViewModel extends ViewModel {
  // initialize SharedFlow
  BaseSharedFlow<String> get messageSharedFlow => sharedFlow("unique");

  void showPopupMessage() {
    // by emitting the value, listeners were notified
    debugPrint("hi");
    messageSharedFlow.emit("Hello from MyViewModel!");
  }

  @override
  void init() {
    debugPrint("init inside vm");
  }
}
