import 'base_state_flow_observer.dart';

/// [StateFlowBuilder] is used to rebuild the widgets inside of it.
/// This requires [stateFlow] to listen on and [builder] to which rebuilds when the [stateFlow]'s value changed/updated.
///
class StateFlowBuilder<T> extends BaseStateFlowObserver<T> {
  const StateFlowBuilder(
      {super.key, required super.stateFlow, required super.builder});
}
