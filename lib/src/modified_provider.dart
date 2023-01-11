import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' as p;

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

class MultiProvider extends p.MultiProvider {
  MultiProvider(
      {super.key, required List<ProviderSingleChildWidget> super.providers, super.child});
}

extension ReadWatchContext on BuildContext {
  T read<T extends ChangeNotifier>() => p.Provider.of<T>(this, listen: false);

  T watch<T extends ChangeNotifier>() => p.Provider.of<T>(this, listen: true);
}
