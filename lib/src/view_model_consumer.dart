
import 'package:flutter/widgets.dart';

import 'flow.dart';

class ViewModelConsumer<T> extends StatefulWidget {
  final StateFlow<T> observeOn;
  final void Function(BuildContext context, T? value) listener;
  final Widget Function(BuildContext context, T? value) builder;

  const ViewModelConsumer(
      {super.key,
        required this.observeOn,
        required this.listener,
        required this.builder});

  @override
  State<ViewModelConsumer<T>> createState() => _ViewModelConsumerState<T>();
}

class _ViewModelConsumerState<T> extends State<ViewModelConsumer<T>> {
  @override
  void initState() {
    super.initState();
    widget.observeOn.addListener(_stateListener);
  }

  @override
  void dispose() {
    widget.observeOn.removeListener(_stateListener);
    super.dispose();
  }

  void _stateListener() {
    if (mounted) {
      widget.listener(context, widget.observeOn.value);
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ViewModelConsumer<T> oldWidget) {
    if (widget.observeOn != oldWidget.observeOn) {
      _migrate(widget.observeOn, oldWidget.observeOn, _stateListener);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _migrate(Listenable a, Listenable b, void Function() listener) {
    b.removeListener(listener);
    a.addListener(listener);
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.observeOn.value);
  }
}
