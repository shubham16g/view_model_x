import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'view_model.dart';

/// Mixin which allows `MultiViewModelProvider` to infer the types
/// of multiple [ViewModelProvider]s.
mixin ViewModelProviderSingleChildWidget on SingleChildWidget {}

/// [ViewModelProvider] is used to wrap the widget with your custom [ViewModel].
/// This requires [create] which accepts custom [ViewModel] and [child] Widget.
class ViewModelProvider<T extends ViewModel> extends SingleChildStatelessWidget
    with ViewModelProviderSingleChildWidget {
  final T Function(BuildContext) _create;
  final bool _lazy;

  const ViewModelProvider(
      {super.key,
      required T Function(BuildContext) create,
      bool lazy = false,
      super.child})
      : _create = create,
        _lazy = lazy;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(child != null, "child must not be null");
    return Provider<T>(
      create: _create,
      dispose: (_, viewModel) => viewModel.dispose(),
      lazy: _lazy,
      child: _ViewStateWrapper<T>(child: child!),
    );
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

class _ViewStateWrapper<T extends ViewModel> extends StatefulWidget {
  final Widget _child;
  const _ViewStateWrapper({super.key, required Widget child}) : _child = child;

  @override
  State<_ViewStateWrapper<T>> createState() => _ViewStateWrapperState<T>();
}

class _ViewStateWrapperState<T extends ViewModel>
    extends State<_ViewStateWrapper<T>> {
  @override
  void initState() {
    super.initState();
    final vm = ViewModelProvider.of<T>(context);
    vm.init();
    if (vm is PostFrameCallback) {
      WidgetsBinding.instance
          .addPostFrameCallback((vm as PostFrameCallback).onPostFrameCallback);
    }
  }

  @override
  Widget build(BuildContext context) => widget._child;
}


extension ViewModelExtension on BuildContext {
  /// [vm] is an [BuildContext] extension method.
  /// This allows to get the custom [ViewModel] from anywhere nested inside [ViewModelProvider]'s [child]
  T vm<T extends ViewModel>() => ViewModelProvider.of<T>(this);
}
