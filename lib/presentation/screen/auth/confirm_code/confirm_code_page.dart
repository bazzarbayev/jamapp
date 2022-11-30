import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

import 'confirm_code_screen.dart';

// ignore: must_be_immutable
class ConfirmCodePage extends StatefulWidget {
  static const String routeName = '/confirmCode';

  String phone;
  bool isNewUser;

  ConfirmCodePage(this.phone, this.isNewUser);

  @override
  _ConfirmCodePageState createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  AuthenticationBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<AuthenticationBloc>(context);
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: COLOR_CONST.DEFAULT,
            size: 12,
          ),
          onPressed: () => _bloc.add(GoRegisterPageEvent()),
        ),
      ),
      body: ConfirmCodeScreen(
        phone: widget.phone,
        isNewUser: widget.isNewUser,
        confirmCodeBloc: _bloc,
      ),
    );
  }
}
