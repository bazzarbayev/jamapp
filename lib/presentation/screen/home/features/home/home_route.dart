import 'package:flutter/material.dart';

class HomeRoutes extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const HomeRoutes({@required this.navigatorKey});

  @override
  _HomeRoutesState createState() => _HomeRoutesState();
}

class _HomeRoutesState extends State<HomeRoutes> {
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
            page = Container(
              color: Colors.amber,
              // ignore: deprecated_member_use
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/map_page',
                  );
                },
                child: Text("go 2 "),
              ),
            );
          if (settings.name == '/map_page')
            page = Scaffold(
              body: Container(
                color: Colors.blue,
              ),
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
