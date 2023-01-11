import 'package:flutter/widgets.dart';
import 'package:view_model_x/src/base_flow_listener_single_child_widget.dart';
import 'flow.dart';

/// [SharedFlowListener] is used to catch the emitted value from [sharedFlow].
/// This requires [sharedFlow], [listener] and [child].
/// Whenever [sharedFlow] emits a value, [listener] will called.

class SharedFlowListener<T> extends BaseFlowListenerSingleChildWidget {
  final SharedFlow<T> sharedFlow;
  final void Function(BuildContext context, T value) listener;

  const SharedFlowListener({super.key, required this.sharedFlow, required this.listener, super.child}) : super(changeNotifier: sharedFlow);

  @override
  void onNotifyListener(BuildContext context) {
    final value = sharedFlow.lastEmitValue;
    if (value != null) {
      listener(context, value);
    }
  }
}