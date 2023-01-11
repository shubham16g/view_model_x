import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';

abstract class BaseFlowListener extends SingleChildStatefulWidget {
  final ChangeNotifier changeNotifier;

  const BaseFlowListener({super.key, required this.changeNotifier, super.child});

  void onNotifyListener(BuildContext context);


  @override
  SingleChildState<BaseFlowListener> createState() => _BaseFlowListenerState();
}

class _BaseFlowListenerState extends SingleChildState<BaseFlowListener> {
  @override
  void initState() {
    super.initState();
    widget.changeNotifier.addListener(_stateListener);
  }

  @override
  void dispose() {
    widget.changeNotifier.removeListener(_stateListener);
    super.dispose();
  }

  void _stateListener() {
    if (mounted) {
      widget.onNotifyListener(context);
    }
  }

  @override
  void didUpdateWidget(covariant BaseFlowListener oldWidget) {
    if (widget.changeNotifier != oldWidget.changeNotifier) {
      _migrate(widget.changeNotifier, oldWidget.changeNotifier, _stateListener);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _migrate(Listenable a, Listenable b, void Function() listener) {
    b.removeListener(listener);
    a.addListener(listener);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(child != null,
        '''${widget.runtimeType} used outside of MultiBlocListener must specify a child''');
    return child!;
  }
}
