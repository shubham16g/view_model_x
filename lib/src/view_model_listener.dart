import 'package:flutter/widgets.dart';
import 'flow.dart';

/// [ViewModelListener] is used to rebuild the widgets inside of it and call the listener.
/// This requires [flow] (which can be [SharedFlow] or [StateFlow]), [listener] and [child].
/// Whenever [flow]'s value changed/updated (if it is StateFlow) or emit value (it it is StateFlow), [listener] will called.
class ViewModelListener<T> extends StatefulWidget {
  final AnyFlow<T> flow;
  final void Function(BuildContext context, T? value) listener;
  final Widget child;

  const ViewModelListener(
      {super.key,
      required this.flow,
      required this.listener,
      required this.child});

  @override
  State<ViewModelListener<T>> createState() => _ViewModelListenerState<T>();
}

class _ViewModelListenerState<T> extends State<ViewModelListener<T>> {
  @override
  void initState() {
    super.initState();
    widget.flow.addListener(_stateListener);
  }

  @override
  void dispose() {
    widget.flow.removeListener(_stateListener);
    super.dispose();
  }

  void _stateListener() {
    if (mounted) {
      if (widget.flow is SharedFlow<T>) {
        widget.listener(context, (widget.flow as SharedFlow<T>).lastEmitValue);
      } else if (widget.flow is StateFlow<T>) {
        widget.listener(context, (widget.flow as StateFlow<T>).value);
      }
    }
  }

  @override
  void didUpdateWidget(covariant ViewModelListener<T> oldWidget) {
    if (widget.flow != oldWidget.flow) {
      _migrate(widget.flow, oldWidget.flow, _stateListener);
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
