import 'package:provider/provider.dart';
import 'package:view_model_x/src/base_flow_listener.dart';
import 'shared_flow_listener.dart';
import 'state_flow_listener.dart';

/// [MultiFlowListener] converts the [StateFlowListener] and [SharedFlowListener] list into a tree of nested widgets.
/// As a result, the only advantage of using [MultiFlowListener] is improved
/// readability due to the reduction in nesting and boilerplate.
class MultiFlowListener extends MultiProvider {
  MultiFlowListener(
      {super.key,
      required List<BaseFlowListener> listeners,
      super.child})
      : super(providers: listeners);
}
