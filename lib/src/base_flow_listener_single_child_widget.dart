import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

abstract class BaseFlowListenerSingleChildWidget extends SingleChildStatefulWidget {
  final ChangeNotifier changeNotifier;

  const BaseFlowListenerSingleChildWidget({super.key, required this.changeNotifier, super.child});

  void onNotifyListener(BuildContext context);


  @override
  SingleChildState<BaseFlowListenerSingleChildWidget> createState() => _BaseFlowListenerState();
}

class _BaseFlowListenerState extends SingleChildState<BaseFlowListenerSingleChildWidget> {
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
  void didUpdateWidget(covariant BaseFlowListenerSingleChildWidget oldWidget) {
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
