import 'package:flutter/material.dart';

class ApplicationRoutes extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ApplicationRoutes({@required this.navigatorKey});

  @override
  _ApplicationRoutesState createState() => _ApplicationRoutesState();
}

class _ApplicationRoutesState extends State<ApplicationRoutes> {
  @override
  void initState() {
    // BlocProvider.of<ApplicationBloc>(context).add(GetApplicationsEvent());
    super.initState();
  }

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
          if (settings.name == '/')
            page = Scaffold(
              body: Container(),
            );
          if (settings.name == '/map_page')
            page = Scaffold(
              body: Container(),
            );
          if (settings.name == '/files_page') {
            page = Scaffold(
              body: Container(),
            );
          }
          return MaterialPageRoute(builder: (context) => page);
        },
      ),
    );
  }
}
