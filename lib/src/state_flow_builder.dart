import 'base_state_flow_builder.dart';

/// [StateFlowBuilder] is used to rebuild the widgets inside of it.
/// This requires [stateFlow] to listen on and [builder] to which rebuilds when the [stateFlow]'s value changed/updated.
///
class StateFlowBuilder<T> extends BaseStateFlowBuilder<T> {
  const StateFlowBuilder({super.key, required super.stateFlow, required super.builder});
}
