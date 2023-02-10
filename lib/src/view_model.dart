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


  final _flowMap = HashMap<String, ChangeNotifier>();

  BaseStateFlow<T> stateFlow<T>(String id, T value){
    if (_flowMap.containsKey(id)) return _flowMap[id] as BaseStateFlow<T>;
    final sf = StateFlow<T>(value);
    _flowMap[id] = sf;
    return sf;
  }

  BaseSharedFlow<T> sharedFlow<T>(String id){
    if (_flowMap.containsKey(id)) return _flowMap[id] as BaseSharedFlow<T>;
    final sf = SharedFlow<T>();
    _flowMap[id] = sf;
    return sf;
  }

  void init() {}

  /// used to dispose all the flows.
  void dispose() {
    for (final element in _flowMap.entries) {
      _flowMap[element.key]?.dispose();
    }
    _flowMap.clear();
  }
}

/// This will help to easily implement PostFrameCallback event into ViewModel.
/// [onPostFrameCallback] will trigger after the ui build completed.
abstract class PostFrameCallback {
  void onPostFrameCallback(Duration timestamp);
}
