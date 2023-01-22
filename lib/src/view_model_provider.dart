import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'provider_single_child_widget.dart';
import 'view_model.dart';

/// [ViewModelProvider] is used to wrap the widget with your custom [ViewModel].
/// This requires [create] which accepts custom [ViewModel] and [child] Widget.
class ViewModelProvider<T extends ViewModel> extends Provider<T>
    with ProviderSingleChildWidget {
  ViewModelProvider(
      {super.key,
      required super.create,
      super.lazy,
      super.builder,
      super.child})
      : super(dispose: _dispose);

  static void _dispose<T extends ViewModel>(BuildContext context, T viewModel) {
    viewModel.dispose();
  }

  /// [ViewModelProvider].[of] method allows to get the custom [ViewModel] from anywhere nested inside [ViewModelProvider]'s [child]
  static F of<F extends ViewModel>(BuildContext context) {
    try {
      return Provider.of<F>(context, listen: false);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != F) rethrow;
      throw FlutterError('''
        ViewModelProvider.of() called with a context that does not contain a $F.
        No ancestor could be found starting from the context that was passed to ViewModelProvider.of<$F>().

        This can happen if the context you used comes from a widget above the ViewModelProvider.

        The context used was: $context
        ''');
    }
  }
}

extension ViewModelExtension on BuildContext {
  /// [vm] is an [BuildContext] extension method.
  /// This allows to get the custom [ViewModel] from anywhere nested inside [ViewModelProvider]'s [child]
  T vm<T extends ViewModel>() => ViewModelProvider.of<T>(this);
}
