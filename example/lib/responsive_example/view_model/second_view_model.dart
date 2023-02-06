import 'package:flutter/foundation.dart';
import 'package:view_model_x/view_model_x.dart';

class SecondViewModel extends ViewModel {
  // initialize SharedFlow
  final messageSharedFlow = SharedFlow<String>();

  void showPopupMessage() {
    // by emitting the value, listeners were notified
    debugPrint("hi");
    messageSharedFlow.emit("Hello from MyViewModel!");
  }

  @override
  void init() {
    debugPrint("init inside vm");
  }

  @override
  void dispose() {
    messageSharedFlow.dispose();
    debugPrint("SecondViewModel disposed");
  }
}
