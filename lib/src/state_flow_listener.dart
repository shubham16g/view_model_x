import 'package:flutter/widgets.dart';
import 'base_flow_listener_single_child_widget.dart';
import 'flow/state_flow.dart';


/// [StateFlowListener] is used to catch the change/update value event of a [stateFlow].
/// This requires [stateFlow], [listener] and [child].
/// Whenever [stateFlow]'s value changed/updated , [listener] will called.
class StateFlowListener<T> extends BaseFlowListenerSingleChildWidget {
  final StateFlow<T> stateFlow;
  final void Function(BuildContext context, T value) listener;

  const StateFlowListener(
      {super.key, required this.stateFlow, required this.listener, super.child})
      : super(changeNotifier: stateFlow);

  @override
  void onNotifyListener(BuildContext context) {
    listener(context, stateFlow.value);
  }
}
