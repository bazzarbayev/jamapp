import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

import '../../router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

//    openLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImageHome),
            fit: BoxFit.fill
          ),
        ),
        child: Center(
          child: SizedBox(
            child: svgIcon,
          ),
        ),
      ),
    );
  }

  void openLogin() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(context, AppRouter.LOGIN);
    });
  }

  final Widget svgIcon =
      SvgPicture.asset(logoImage, semanticsLabel: '');
}
