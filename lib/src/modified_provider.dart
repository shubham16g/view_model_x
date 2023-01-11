import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' as p;

import 'provider_single_child_widget.dart';
import 'view_model_provider.dart';

/// This class is exactly same with Provider's [ChangeNotifierProvider]. It have extra static [of] method.
/// Listens to a [ChangeNotifier], expose it to its descendants and rebuilds
/// dependents whenever [ChangeNotifier.notifyListeners] is called.
class ChangeNotifierProvider<T extends ChangeNotifier>
    extends p.ChangeNotifierProvider<T> with ProviderSingleChildWidget {
  ChangeNotifierProvider(
      {super.key, required super.create, super.child, super.lazy});

  static F of<F extends ChangeNotifier>(BuildContext context,
          {bool listen = true}) =>
      p.Provider.of<F>(context, listen: true);
}

/// [MultiProvider] is a Widget that merges multiple [ViewModelProvider] and [ChangeNotifierProvider] widgets into one.
/// This [MultiProvider] is slightly different from one in Provider package. Here [providers] can only be [ViewModelProvider] or [ChangeNotifierProvider].
class MultiProvider extends p.MultiProvider {
  MultiProvider(
      {super.key,
      required List<ProviderSingleChildWidget> super.providers,
      super.child});
}

extension ReadWatchContext on BuildContext {
  /// Get the instance of [ChangeNotifier] of exact type.
  T read<T extends ChangeNotifier>() => p.Provider.of<T>(this, listen: false);

  /// Get the instance of [ChangeNotifier] of exact type and listen for `notifyListeners()`
  T watch<T extends ChangeNotifier>() => p.Provider.of<T>(this, listen: true);
}
