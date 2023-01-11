import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:view_model_x/src/view_model_provider.dart';

/// [MultiViewModelProvider] converts the [ViewModelProvider] list into a tree of nested
/// [ViewModelProvider] widgets.
/// As a result, the only advantage of using [MultiViewModelProvider] is improved
/// readability due to the reduction in nesting and boilerplate.
class MultiViewModelProvider extends MultiProvider {
  MultiViewModelProvider(
      {super.key, required List<ViewModelProviderSingleChildWidget> providers, required Widget child})
      : super(providers: providers, child: child);
}
