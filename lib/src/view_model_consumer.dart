
import 'package:flutter/widgets.dart';

import 'flow.dart';

class ViewModelConsumer<T> extends StatefulWidget {
  final StateFlow<T> stateFlow;
  final void Function(BuildContext context, T? value) listener;
  final Widget Function(BuildContext context, T? value) builder;

  const ViewModelConsumer(
      {super.key,
        required this.stateFlow,
        required this.listener,
        required this.builder});

  @override
  State<ViewModelConsumer<T>> createState() => _ViewModelConsumerState<T>();
}

class _ViewModelConsumerState<T> extends State<ViewModelConsumer<T>> {
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
  void didUpdateWidget(covariant ViewModelConsumer<T> oldWidget) {
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
