import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:view_model_x/src/flow.dart';

/// [ViewModel] is an abstract class with an abstract method [dispose].
abstract class ViewModel {
  ViewModel() {
    init();
    if (this is PostFrameCallback) {
      WidgetsBinding.instance.addPostFrameCallback(
          (this as PostFrameCallback).onPostFrameCallback);
    }
  }

  final map2 = HashMap<ChangeNotifier, bool>();

  final map = HashMap<String, ChangeNotifier>();

  StateFlow<T> stateFlow<T>(String id, T value){
    if (map.containsKey(id)) return map[id] as StateFlow<T>;
    final sf = StateFlow(value);
    map[id] = sf;
    return sf;
  }

  void init() {}

  /// used to dispose all the flows.
  void dispose() {
    for (final element in map.entries) {
      map[element.key]?.dispose();
    }
    map.clear();
  }
}

/// This will help to easily implement PostFrameCallback event into ViewModel.
/// [onPostFrameCallback] will trigger after the ui build completed.
abstract class PostFrameCallback {
  void onPostFrameCallback(Duration timestamp);
}
