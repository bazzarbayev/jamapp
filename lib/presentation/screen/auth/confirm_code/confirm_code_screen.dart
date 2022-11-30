import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:jam_app/widgets/loading_overlay.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfirmCodeScreen extends StatefulWidget {
  const ConfirmCodeScreen({
    Key key,
    @required AuthenticationBloc confirmCodeBloc,
    String phone,
    bool isNewUser,
  })  : _confirmCodeBloc = confirmCodeBloc,
        _phone = phone,
        _isNewUser = isNewUser,
        super(key: key);

  final AuthenticationBloc _confirmCodeBloc;
  final String _phone;
  final bool _isNewUser;

  @override
  ConfirmCodeScreenState createState() {
    return ConfirmCodeScreenState();
  }
}

class ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  ConfirmCodeScreenState();

  Timer _timer;
  int _start = 50;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  var _isLoading = false;
  var _pinContr = TextEditingController();

  var code = "";

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Text(
                "confirm_code.sended_code"
                    .tr(args: ["${widget._phone.toString()}"]),
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: _pinContr,
                  maxLines: 1,
                  // keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                  cursorColor: COLOR_CONST.DEFAULT,
                  maxLength: 5,
                  onChanged: (str) {
                    setState(() {
                      code = str;
                    });
                    if (str.length == 5) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
                      ),
                      labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              _start == 0
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _start = 50;
                        });
                        startTimer();
                        widget._confirmCodeBloc
                            .add(SendCodeAgainEvent(widget._phone));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "confirm_code.send_again".tr(),
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xFFF3E3B4),
                              fontFamily: "roboto",
                              fontSize: 14.0),
                        ),
                      ),
                    )
                  : Text(
                      "confirm_code.get_code_when"
                          .tr(args: [_start.toString()]),
                      style: Theme.of(context).textTheme.headline5,
                    ),
              SizedBox(
                height: 60.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Expanded(
                        child: JJGreenButton(
                            text: "confirm_code.continue".tr(),
                            function: _load)),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _load() async {
    setState(() {
      _isLoading = true;
    });

    widget._confirmCodeBloc
        .add(CheckCodeEvent(code, widget._phone, widget._isNewUser));

    await Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
