import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/age_confirm_screen.dart';
import 'package:jam_app/presentation/screen/auth/registration/registration_screen.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  AuthenticationBloc _auth;

  @override
  void initState() {
    _auth = BlocProvider.of<AuthenticationBloc>(context);
    Analytics().doEventCustom("loginscreen_phone_input");
    super.initState();
  }

  var _currentLang = Languages.RU;

  void _getLocale() {
    if (context.locale == Locale("kk", "KZ")) {
      _currentLang = Languages.KZ;
    } else {
      _currentLang = Languages.RU;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLocale();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
              onTap: () {
                Analytics().doEventCustom("kz_language_registration_page");
                setState(() {
                  _currentLang = Languages.KZ;
                });
                EasyLocalization.of(context).locale = Locale("kk", "KZ");
              },
              child: Container(
                width: 60,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: _currentLang == Languages.KZ
                    ? BoxDecoration(
                        border: Border.all(color: GREEN, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))
                    : null,
                child: Center(
                  child: Text(
                    "Қаз",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              )),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Analytics().doEventCustom("ru_language_registration_page");

              setState(() {
                _currentLang = Languages.RU;
              });
              EasyLocalization.of(context).locale = Locale("ru", "RU");
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: _currentLang == Languages.RU
                  ? BoxDecoration(
                      border: Border.all(color: GREEN, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))
                  : null,
              child: Center(
                child: Text(
                  "Рус",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: RegistrationScreen(registrationBloc: _auth),
    );
  }
}
