import 'package:flutter/widgets.dart';
import 'flow.dart';

class ViewModelListener<T> extends StatefulWidget {
  final AnyFlow<T> observeOn;
  final void Function(BuildContext context, T? value) listener;
  final Widget child;

  const ViewModelListener(
      {super.key,
      required this.observeOn,
      required this.listener,
      required this.child});

  @override
  State<ViewModelListener<T>> createState() => _ViewModelListenerState<T>();
}

class _ViewModelListenerState<T> extends State<ViewModelListener<T>> {
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
    }
  }

  @override
  void didUpdateWidget(covariant ViewModelListener<T> oldWidget) {
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
    return widget.child;
  }
}
