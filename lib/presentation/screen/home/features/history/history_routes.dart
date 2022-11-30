import 'package:flutter/material.dart';
import 'package:jam_app/presentation/screen/home/features/history/history_screen.dart';

class HistoryRoutes extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const HistoryRoutes({@required this.navigatorKey});

  @override
  _HistoryRoutesState createState() => _HistoryRoutesState();
}

class _HistoryRoutesState extends State<HistoryRoutes> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: (settings) {
          Widget page;
          if (settings.name == '/') page = HistoryScreen();
          return MaterialPageRoute(builder: (context) => page);
        },
      ),
    );
  }
}
