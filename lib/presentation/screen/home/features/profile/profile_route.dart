
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jam_app/presentation/screen/home/features/profile/detail/my_order_detail_screen.dart';
import 'package:jam_app/presentation/screen/home/features/profile/my_orders_screen.dart';
import 'package:jam_app/presentation/screen/home/features/profile/profile_screen.dart';

class ProfileRoutes extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ProfileRoutes({@required this.navigatorKey});

  @override
  _ProfileRoutesState createState() => _ProfileRoutesState();
}

class _ProfileRoutesState extends State<ProfileRoutes> {
  var locator = GetIt.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    locator<FirebaseMessaging>().requestNotificationPermissions();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
    // if (Platform.isIOS) {
    //       if (message.data["action"] == "history") {
    //         BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
    //       }
    //     } else {
    //       if (message.data["data"]["action"] == "history") {
    //         BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
    //       }
    //     }
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { 
    //   //  RemoteNotification notification = message.notification;
    //   // AndroidNotification android = message.notification?.android;
    //    print('mc2 $message');
    //    print('onResume called: ${message}');
    //     if (Platform.isIOS) {
    //       if (message.data["action"] == "history") {
    //         BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
    //       }
    //     } else {
    //       if (message.data["data"]["action"] == "history") {
    //         BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
    //       }
    //     }
    // });
    locator<FirebaseMessaging>().configure(
      onMessage: (Map<String, dynamic> message) {
        // print('mc2 $message');

        // if (Platform.isIOS) {
        //   if (message["action"] == "history") {
        //     BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
        //   }
        // } else {
        //   if (message["data"]["action"] == "history") {
        //     BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
        //   }
        // }

        return;
      },
      onResume: (Map<String, dynamic> message) {
        // print('onResume called: ${message}');
        // if (Platform.isIOS) {
        //   if (message["action"] == "history") {
        //     BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
        //   }
        // } else {
        //   if (message["data"]["action"] == "history") {
        //     BlocProvider.of<UserBloc>(context)..add(GoScanToHistoryEvent());
        //   }
        // }
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
        return;
      },
    );
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: (settings) {
          Widget page;
          if (settings.name == '/') page = ProfileScreen();
          if (settings.name == '/my_orders') page = MyOrdersScreen();
          if (settings.name == '/my_orders/detail') {
            Map object = settings.arguments;
            page = MyOrderDetailScreen(object["id"]);
          }
          return MaterialPageRoute(builder: (context) => page);
        },
      ),
    );
  }
}
