abstract class GeekChatTrackerInterface {
  Future<void> trackEvent(
    String eventName, [
    Map<String, dynamic>? props,
  ]) async {}
}
