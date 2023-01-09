import 'package:flutter/widgets.dart';

import 'flow.dart';

/// [ViewModelBuilder] is used to rebuild the widgets inside of it.
/// This requires [stateFlow] to listen on and [builder] to which rebuilds when the [stateFlow]'s value changed/updated.
class ViewModelBuilder<T> extends StatefulWidget {
  final StateFlow<T> stateFlow;
  final Widget Function(BuildContext context, T? value) builder;

  const ViewModelBuilder(
      {super.key, required this.stateFlow, required this.builder});

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T> extends State<ViewModelBuilder<T>> {
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
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ViewModelBuilder<T> oldWidget) {
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
