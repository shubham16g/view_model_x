

import 'package:flutter/widgets.dart';

import 'flow.dart';

class ViewModelBuilder<T> extends StatefulWidget {
  final StateFlow<T> observeOn;
  final Widget Function(BuildContext context, T? value) builder;

  const ViewModelBuilder({super.key, required this.observeOn, required this.builder});

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T> extends State<ViewModelBuilder<T>> {

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
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ViewModelBuilder<T> oldWidget) {
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