import 'package:flutter/widgets.dart';
import 'flow.dart';

/// [SharedFlowListener] is used to catch the emitted value from [sharedFlow].
/// This requires [sharedFlow], [listener] and [child].
/// Whenever [sharedFlow] emits a value, [listener] will called.
class SharedFlowListener<T> extends StatefulWidget {
  final SharedFlow<T> sharedFlow;
  final void Function(BuildContext context, T value) listener;
  final Widget child;

  const SharedFlowListener(
      {super.key,
      required this.sharedFlow,
      required this.listener,
      required this.child});

  @override
  State<SharedFlowListener<T>> createState() => _SharedFlowListenerState<T>();
}

class _SharedFlowListenerState<T> extends State<SharedFlowListener<T>> {
  @override
  void initState() {
    super.initState();
    widget.sharedFlow.addListener(_stateListener);
  }

  @override
  void dispose() {
    widget.sharedFlow.removeListener(_stateListener);
    super.dispose();
  }

  void _stateListener() {
    if (mounted) {
      final value = widget.sharedFlow.lastEmitValue;
      if (value != null) {
        widget.listener(context, value);
      }
    }
  }

  @override
  void didUpdateWidget(covariant SharedFlowListener<T> oldWidget) {
    if (widget.sharedFlow != oldWidget.sharedFlow) {
      _migrate(widget.sharedFlow, oldWidget.sharedFlow, _stateListener);
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
