import 'package:provider/provider.dart';

/// [MultiViewModelProvider] converts the [ViewModelProvider] list into a tree of nested
/// [ViewModelProvider] widgets.
/// As a result, the only advantage of using [MultiViewModelProvider] is improved
/// readability due to the reduction in nesting and boilerplate.
class MultiViewModelProvider extends MultiProvider {
  MultiViewModelProvider({super.key, required super.providers, super.child, super.builder});
}
