import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: COLOR_CONST.DEFAULT),
            title: Text(
              "scan.send_check".tr().toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "scan.upload_check".tr(),
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(
                  height: 20,
                ),
                DottedBorder(
                  dashPattern: [8, 4],
                  color: COLOR_CONST.DEFAULT,
                  strokeWidth: 2,
                  padding: EdgeInsets.all(42),
                  child: SvgPicture.asset("assets/images/photo.svg"),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "scan.add_until_5_photo".tr(),
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                JJGreenButton(
                    text: "scan.choose".tr(),
                    function: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      var isLoyal = preferences.getString("isLoyal");
                      if (isLoyal != null) {
                        _authenticationBloc.add(ShowCustomAlert(
                            "scan.error_loyalty".tr(), "", "ok", ""));
                      } else {
                        Navigator.pushNamed(context, "/send_checks");
                      }
                    }),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          )),
    );
  }
}
