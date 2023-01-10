import 'package:flutter/widgets.dart';

import 'flow.dart';

/// [StateFlowConsumer] is used to rebuild the widgets inside of it and catch the event in [listener].
/// This requires [stateFlow] to listen on, [builder] and [listener].
/// Whenever [stateFlow]'s value changed/updated, [builder] will rebuild the widgets inside of it and [listener] will called.
class StateFlowConsumer<T> extends StatefulWidget {
  final StateFlow<T> stateFlow;
  final void Function(BuildContext context, T? value) listener;
  final Widget Function(BuildContext context, T? value) builder;

  const StateFlowConsumer(
      {super.key,
      required this.stateFlow,
      required this.listener,
      required this.builder});

  @override
  State<StateFlowConsumer<T>> createState() => _StateFlowConsumerState<T>();
}

class _StateFlowConsumerState<T> extends State<StateFlowConsumer<T>> {
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
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant StateFlowConsumer<T> oldWidget) {
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
    return widget.builder(context, widget.stateFlow.value);
  }
}
