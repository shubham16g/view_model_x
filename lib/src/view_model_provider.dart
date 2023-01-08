

import 'package:flutter/widgets.dart';

import 'view_model.dart';

class ViewModelProvider<T extends ViewModel> extends StatefulWidget {
  final T Function(BuildContext context) create;
  final Widget child;

  const ViewModelProvider(
      {super.key, required this.create, required this.child});

  static F? maybeOf<F extends ViewModel>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_VMP<F>>()?.viewModel;

  static F of<F extends ViewModel>(BuildContext context) {
    final res = maybeOf<F>(context);
    assert(res != null, 'No ViewModel found in context');
    return res!;
  }

  @override
  State<ViewModelProvider<T>> createState() => _ViewModelProviderState<T>();
}

extension ViewModelExtension on BuildContext {
  T vm<T>() => ViewModelProvider.of(this);
}

class _ViewModelProviderState<T extends ViewModel>
    extends State<ViewModelProvider<T>> {

  late final T _viewModel;

  @override
  void initState() {
    _viewModel = widget.create(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _VMP(viewModel: _viewModel, child: widget.child);
  }

  @override
  void dispose() {
    debugPrint('viewModel disposed');
    _viewModel.dispose();
    super.dispose();
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