import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:jam_app/presentation/screen/home/bottom_navigation.dart';

class Analytics {
  // FirebaseAnalytics _analytics = ;

  doTestEvent() {
    print("lopalopa");
    FirebaseAnalytics().logEvent(
        name: "test_event", parameters: <String, dynamic>{"action": "lol"});
  }

  doEventByItem(TabItem item) {
    if (item == TabItem.jameson) {
      _doEventView("main_screen");
    } else if (item == TabItem.shop){
      _doEventView("shop");
    } else if (item == TabItem.orders){
      _doEventView("my_history");
    } 
    else if (item == TabItem.scan){
      _doEventView("scan_upload");
    }
  }

  doEventCustom(String action){
    _doEventView(action);
  }

  doNamedEvent(String event, String param){
     FirebaseAnalytics().logEvent(
        name: event, parameters: <String, dynamic>{"action": param});
  }

  void _doEventView(String action) {
    FirebaseAnalytics().logEvent(
        name: action, parameters: <String, dynamic>{"action": action});
  }
}
