import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// This class is exactly same with Provider's [ChangeNotifierProvider]. It have extra static [of] method.
/// Listens to a [ChangeNotifier], expose it to its descendants and rebuilds
/// dependents whenever [ChangeNotifier.notifyListeners] is called.
class ChangeNotifierProvider<T extends ChangeNotifier?>
    extends ListenableProvider<T> {
  /// Creates a [ChangeNotifier] using `create` and automatically
  /// disposes it when [ChangeNotifierProvider] is removed from the widget tree.
  ///
  /// `create` must not be `null`.
  ChangeNotifierProvider({
    Key? key,
    required Create<T> create,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          create: create,
          dispose: _dispose,
          lazy: lazy,
          builder: builder,
          child: child,
        );

  /// Provides an existing [ChangeNotifier].
  ChangeNotifierProvider.value({
    Key? key,
    required T value,
    TransitionBuilder? builder,
    Widget? child,
  }) : super.value(
          key: key,
          builder: builder,
          value: value,
          child: child,
        );

  static void _dispose(BuildContext context, ChangeNotifier? notifier) {
    notifier?.dispose();
  }

  static F of<F extends ChangeNotifier>(BuildContext context) =>
      Provider.of<F>(context);
}
