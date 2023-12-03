import 'package:geek_chat/util/tracker/tracker_interface.dart';
import 'package:get/get.dart';

class TrackerController extends GetxController {
  List<GeekChatTrackerInterface> trackers = [];

  addTracker(GeekChatTrackerInterface tracker) {
    trackers.add(tracker);
  }

  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? props]) async {
    if (trackers.isNotEmpty) {
      for (GeekChatTrackerInterface tracker in trackers) {
        tracker.trackEvent(eventName, props);
      }
    }
  }
}
