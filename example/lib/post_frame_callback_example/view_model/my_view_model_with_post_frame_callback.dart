import 'package:flutter/foundation.dart';
import 'package:view_model_x/view_model_x.dart';

class MyViewModelWithPostFrameCallback extends ViewModel
    with PostFrameCallback {
  // initialize SharedFlow
  final messageSharedFlow = SharedFlow<String>();

  @override
  void init() {
    // do stuff on create of view model, (equivalent to constructor)
    debugPrint("on init");

    messageSharedFlow.emit(
        "on init"); // this emit will not received by listener because it emitted before ui build.
  }

  @override
  void onPostFrameCallback(Duration timestamp) {
    messageSharedFlow.emit(
        "onPostFrameCallback"); // this emit will be received because it is emitted after the ui build completed.
  }

  @override
  void dispose() {
    messageSharedFlow.dispose();
    debugPrint("MyViewModelWithPostFrameCallback disposed");
  }
}
