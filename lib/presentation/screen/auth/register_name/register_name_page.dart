import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/presentation/screen/auth/register_name/register_name_screen.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class RegisterNamePage extends StatefulWidget {
  static const String routeName = '/registerName';

  final List<CityResponse> list;
  final String phone;

  RegisterNamePage(this.list, this.phone);

  @override
  _RegisterNamePageState createState() => _RegisterNamePageState();
}

class _RegisterNamePageState extends State<RegisterNamePage> {
  AuthenticationBloc _auth;

  @override
  void initState() {
    _auth = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            _auth.add(GoRegisterPageEvent());
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: COLOR_CONST.DEFAULT,
            size: 12,
          ),
        ),
      ),
      body: RegisterNameScreen(
        registerNameBloc: _auth,
        list: widget.list,
        phone: widget.phone,
      ),
    );
  }
}
