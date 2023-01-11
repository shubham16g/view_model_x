import 'package:flutter/widgets.dart';

import 'flow.dart';

abstract class BaseStateFlowObserver<T> extends StatefulWidget {
  final StateFlow<T> stateFlow;
  final Widget Function(BuildContext context, T value) builder;
  final void Function(BuildContext context, T value)? listener;

  const BaseStateFlowObserver(
      {super.key, required this.stateFlow, required this.builder, this.listener});

  @override
  State<BaseStateFlowObserver<T>> createState() => _StateFlowBuilderState<T>();
}

class _StateFlowBuilderState<T> extends State<BaseStateFlowObserver<T>> {
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
      if (widget.listener != null) {
        widget.listener!(context, widget.stateFlow.value);
      }
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant BaseStateFlowObserver<T> oldWidget) {
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