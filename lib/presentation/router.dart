import 'package:flutter/material.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/age_confirm_screen.dart';
import 'package:jam_app/presentation/screen/auth/registration/registration_page.dart';
import 'package:jam_app/presentation/screen/home/features/profile/edit_profile_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/check_out/check_out_screen.dart';
import 'package:jam_app/presentation/screen/splash/sc_splash.dart';

class AppRouter {
  static const String HOME = '/';
  static const String SPLASH = '/splash';
  static const String CONFIRM_AGE = '/confirm_age';
  static const String REGISTER = '/register';
  static const String LOGIN = '/login';

  static const String EDIT_PROFILE = "/edit_profile";

  static const String TEST = '/my_test';
  static const String CHECK_OUT = '/check_out_main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CONFIRM_AGE:
        return MaterialPageRoute(builder: (_) => AgeConfirmScreen());
      case SPLASH:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case TEST:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      // case LOGIN:
      //   return MaterialPageRoute(builder: (_) => LoginScreen());
      case REGISTER:
        return MaterialPageRoute(builder: (_) => RegistrationPage());
      //profile module
      case EDIT_PROFILE:
        return MaterialPageRoute(builder: (_) => EditProfile());
      case CHECK_OUT:
        return MaterialPageRoute(builder: (_) => CheckOutScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
