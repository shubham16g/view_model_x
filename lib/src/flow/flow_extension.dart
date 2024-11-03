import 'package:view_model_x/src/flow/shared_flow.dart';
import 'package:view_model_x/src/flow/state_flow.dart';

/// Extension for [StateFlow], to make it easier to create [StateFlow]
extension StateFlowExt<T> on T {
  /// Create a [StateFlow] object easily just by adding `.stf()` after the value.
  StateFlow<T> stf({bool notifyOnSameValue = true}) =>
      StateFlow(this, notifyOnSameValue: notifyOnSameValue);
}

/// function for [SharedFlow], to make it easier to create [SharedFlow]
/// Just call `shf<T>()` to create a [SharedFlow] object.
SharedFlow<T> shf<T>() => SharedFlow<T>();
