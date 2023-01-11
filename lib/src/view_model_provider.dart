import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

import 'view_model.dart';

/// Mixin which allows `MultiViewModelProvider` to infer the types
/// of multiple [ViewModelProvider]s.
mixin ViewModelProviderSingleChildWidget on SingleChildWidget {}

/// [ViewModelProvider] is used to wrap the widget with your custom [ViewModel].
/// This requires [create] which accepts custom [ViewModel] and [child] Widget.
class ViewModelProvider<T extends ViewModel> extends SingleChildStatefulWidget
    with ViewModelProviderSingleChildWidget {
  final T Function(BuildContext context) create;

  const ViewModelProvider({super.key, required this.create, super.child});

  static F? maybeOf<F extends ViewModel>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_VMP<F>>()?.viewModel;

  /// [ViewModelProvider].[of] method allows to get the custom [ViewModel] from anywhere nested inside [ViewModelProvider]'s [child]
  static F of<F extends ViewModel>(BuildContext context) {
    final res = maybeOf<F>(context);
    assert(res != null, '''
        ViewModelProvider.of() called with a context that does not contain a $F.
        No ancestor could be found starting from the context that was passed to ViewModelProvider.of<$F>().

        This can happen if the context you used comes from a widget above the ViewModelProvider.

        The context used was: $context
        ''');
    return res!;
  }

  @override
  State<ViewModelProvider<T>> createState() => _ViewModelProviderState<T>();
}

class _ViewModelProviderState<T extends ViewModel>
    extends SingleChildState<ViewModelProvider<T>> {
  late final T _viewModel;

  @override
  void initState() {
    _viewModel = widget.create(context);
    super.initState();
    _viewModel.init();
    if (_viewModel is PostFrameCallback) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_viewModel as PostFrameCallback).onPostFrameCallback);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(child != null, "child must not be null");
    return _VMP(viewModel: _viewModel, child: child!);
  }
}

class _VMP<T extends ViewModel> extends InheritedWidget {
  final T viewModel;

  const _VMP({super.key, required this.viewModel, required super.child});

  @override
  bool updateShouldNotify(covariant _VMP oldWidget) {
    return viewModel != oldWidget.viewModel;
  }
}

extension ViewModelExtension on BuildContext {
  /// [vm] is an [BuildContext] extension method.
  /// This allows to get the custom [ViewModel] from anywhere nested inside [ViewModelProvider]'s [child]
  T vm<T extends ViewModel>() => ViewModelProvider.of<T>(this);
}
