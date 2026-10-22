import 'dart:async';

/// A simple global event bus used to notify listeners when company-related data
/// should be refreshed (e.g. after create/update/delete operations, profile changes,
/// subscription updates, etc.).
///
/// This is a broadcast stream — multiple widgets/screens can listen to it.
///
/// Usage example:
/// ```dart
/// // Trigger refresh from anywhere (e.g. after API success)
/// CompanyRefreshBus.notify();
///
/// // Listen in a widget (usually in initState)
/// CompanyRefreshBus.stream.listen((_) {
///   setState(() {
///     // refresh UI or reload data
///   });
/// });
///
/// // Don't forget to cancel the subscription when widget is disposed:
/// _subscription?.cancel();
/// ```
class CompanyRefreshBus {
  static final _controller = StreamController<void>.broadcast();
  static Stream<void> get stream => _controller.stream;

  /// Triggers a refresh event to all listeners of [stream].
  ///
  /// Call this method after any operation that should cause company-related
  /// data to be reloaded (e.g. company created/updated/deleted, user left/joined company,
  /// settings changed, etc.).
  static void notify() {
    _controller.add(null);
  }
}
