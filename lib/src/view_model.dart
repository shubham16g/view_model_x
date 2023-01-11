/// [ViewModel] is an abstract class with an abstract method [dispose].
abstract class ViewModel {
  void init() {}

  /// used to dispose all the flows.
  void dispose();
}

/// This will help to easily implement PostFrameCallback event into ViewModel.
/// [onPostFrameCallback] will trigger after the ui build completed.
abstract class PostFrameCallback {
  void onPostFrameCallback(Duration timestamp);
}
