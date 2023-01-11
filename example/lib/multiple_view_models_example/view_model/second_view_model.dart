import 'package:view_model_x/view_model_x.dart';

class SecondViewModel extends ViewModel with PostFrameCallback {
  // initialize SharedFlow
  final _messageSharedFlow = MutableSharedFlow<String>();

  SharedFlow<String> get messageSharedFlow => _messageSharedFlow;

  void showPopupMessage() {
    // by emitting the value, listeners were notified
    _messageSharedFlow.emit("Hello from MyViewModel!");
  }

  @override
  void dispose() {
    _messageSharedFlow.dispose();
  }

  @override
  void onPostFrameCallback(Duration timestamp) {
    _messageSharedFlow.emit("onPostFrameCallback from SecondViewModel");
  }
}
