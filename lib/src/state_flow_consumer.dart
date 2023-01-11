import 'package:flutter/widgets.dart';

import 'base_state_flow_builder.dart';

/// [StateFlowConsumer] is used to rebuild the widgets inside of it and catch the event in [listener].
/// This requires [stateFlow] to listen on, [builder] and [listener].
/// Whenever [stateFlow]'s value changed/updated, [builder] will rebuild the widgets inside of it and [listener] will called.
class StateFlowConsumer<T> extends BaseStateFlowBuilder<T> {
  const StateFlowConsumer(
      {super.key,
      required super.stateFlow,
      required void Function(BuildContext context, T value) listener,
      required super.builder})
      : super(listener: listener);
}