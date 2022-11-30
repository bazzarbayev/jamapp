import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/analytics.dart';

import 'package:jam_app/app/auth_bloc/bloc.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';

import 'package:jam_app/presentation/screen/auth/age_confirm/widgets/jj_day_widget.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/widgets/jj_year_widget.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Languages { KZ, RU }

class AgeConfirmScreen extends StatefulWidget {
  @override
  AgeConfirmScreenState createState() {
    return AgeConfirmScreenState();
  }
}

class AgeConfirmScreenState extends State<AgeConfirmScreen> {
  AgeConfirmScreenState();

  final _monthContr = TextEditingController();
  final _dayContr = TextEditingController();
  final _yearContr = TextEditingController();

  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();

  AuthenticationBloc _auth;

  @override
  void initState() {
    _auth = BlocProvider.of<AuthenticationBloc>(context);

    Analytics().doEventCustom("agegate");
    super.initState();
  }

  @override
  void dispose() {
    _monthContr.dispose();
    _dayContr.dispose();
    _yearContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'age_confirm.enter_your_birth_date'.tr().toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: COLOR_CONST.DEFAULT),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    VerticalDivider(),
                    Expanded(
                      child: JJDayWidget(
                        focusNode: _f1,
                        dayContr: _dayContr,
                        daytext: 'age_confirm.day'.tr(),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: JJDayWidget(
                          focusNode: _f2,
                          dayContr: _monthContr,
                          daytext: 'age_confirm.month'.tr()),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: JJYearWidget(
                          focusNode: _f3,
                          dayContr: _yearContr,
                          daytext: 'age_confirm.year'.tr()),
                    ),
                    VerticalDivider(),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: JJGreenButton(
                              text: "age_confirm.confirm".tr(),
                              function: _func)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _func() async {
    var event = CheckAgeEvent(
        day: _dayContr.text, month: _monthContr.text, year: _yearContr.text);
    if (!event.isOlder) {
      _auth.add(event);
      _auth.add(ClearAuthEvent());
    } else {
      try {
        var prefs = await SharedPreferences.getInstance();
        var format = DateFormat('dd-MM-yyyy');
        var dd = format.parse(event.toString());

        var str = format.format(dd);
        prefs.setString("userAge", str);
      } catch (e) {
        var prefs = await SharedPreferences.getInstance();
        print(e);

        prefs.setString("userAge", "01-01-0001");
      }

      _auth.add(GoRegisterPageEvent());
    }
  }
}
