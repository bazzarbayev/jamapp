import 'package:flutter/material.dart';
import 'package:jam_app/presentation/screen/home/features/profile/detail/my_order_detail_screen.dart';
import 'package:jam_app/presentation/screen/home/features/scan/camera/camera_screen.dart';
import 'package:jam_app/presentation/screen/home/features/scan/camera/check_view_screen.dart';
import 'package:jam_app/presentation/screen/home/features/scan/check_sender.dart';
import 'package:jam_app/presentation/screen/home/features/scan/scan_screen.dart';

class ScanRoutes extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ScanRoutes({@required this.navigatorKey});

  @override
  _ScanRoutesState createState() => _ScanRoutesState();
}

class _ScanRoutesState extends State<ScanRoutes> {
  @override
  void initState() {
    // BlocProvider.of<ScanBloc>(context).add(GetScansEvent());
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
          if (settings.name == '/') page = CameraScreen();
          if (settings.name == '/check_view') {
            Map object = settings.arguments;
            page = new CheckViewScreen(object["path"]);
          }

          if (settings.name == '/upload_photos') page = ScanScreen();

          if (settings.name == '/send_checks') page = CheckSenderScreen();

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
