import 'package:flutter/widgets.dart';
import 'flow.dart';

/// [StateFlowListener] is used to catch the change/update value event of a [stateFlow].
/// This requires [stateFlow], [listener] and [child].
/// Whenever [stateFlow]'s value changed/updated , [listener] will called.
class StateFlowListener<T> extends StatefulWidget {
  final StateFlow<T> stateFlow;
  final void Function(BuildContext context, T value) listener;
  final Widget child;

  const StateFlowListener(
      {super.key,
      required this.stateFlow,
      required this.listener,
      required this.child});

  @override
  State<StateFlowListener<T>> createState() => _StateFlowListenerState<T>();
}

class _StateFlowListenerState<T> extends State<StateFlowListener<T>> {
  @override
  void initState() {
    super.initState();
    widget.stateFlow.addListener(_stateListener);
  }

  @override
  void dispose() {
    widget.stateFlow.removeListener(_stateListener);
    super.dispose();
  }

  void _stateListener() {
    if (mounted) {
      widget.listener(context, widget.stateFlow.value);
    }
  }

  @override
  void didUpdateWidget(covariant StateFlowListener<T> oldWidget) {
    if (widget.stateFlow != oldWidget.stateFlow) {
      _migrate(widget.stateFlow, oldWidget.stateFlow, _stateListener);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _migrate(Listenable a, Listenable b, void Function() listener) {
    b.removeListener(listener);
    a.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
