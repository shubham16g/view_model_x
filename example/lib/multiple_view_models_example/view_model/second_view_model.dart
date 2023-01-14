import 'package:flutter/foundation.dart';
import 'package:view_model_x/view_model_x.dart';

class SecondViewModel extends ViewModel {
  // initialize SharedFlow
  final _messageSharedFlow = MutableSharedFlow<String>();

  SharedFlow<String> get messageSharedFlow => _messageSharedFlow;

  void showPopupMessage() {
    // by emitting the value, listeners were notified
    debugPrint("hi");
    _messageSharedFlow.emit("Hello from MyViewModel!");
  }

  @override
  void init() {
    debugPrint("init inside vm");
  }

  @override
  void dispose() {
    _messageSharedFlow.dispose();
    debugPrint("FirstViewModel disposed");
  }
}
