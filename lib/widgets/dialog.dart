import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/bloc.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final String doIt;
  final VoidCallback callback;
  final Image img;

  const CustomDialogBox(
      {Key key,
      this.title,
      this.doIt,
      this.descriptions,
      this.text,
      this.img,
      this.callback})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  AuthenticationBloc _auth;

  @override
  void initState() {
    _auth = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: COLOR_CONST.DEFAULT,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          margin: EdgeInsets.only(top: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'roboto'),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: COLOR_CONST.TIPA_GREY,
                    fontFamily: 'roboto'),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: [
                  Expanded(
                      child: JJGreenButton(
                    text: widget.text,
                    function: () {
                      if (widget.doIt == "sign_up") {
                        print("sign_up_bttn");
                        _auth.add(GoRegisterPageEvent());
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )),
                ],
              ),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
        Positioned(
          child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop()),
          right: 0,
          top: 20,
          height: 50,
        ),
      ],
    );
  }
}

class FinishRegisterData {
  final String name, city, phone, instagram, facebook;
  FinishRegisterData(
      {this.name, this.city, this.phone, this.instagram, this.facebook});
}

class NoLoyaltyDialogBox extends StatefulWidget {
  final String title, descriptions, text, cancel;

  final FinishRegisterData data;
  final VoidCallback callback;
  final Image img;

  const NoLoyaltyDialogBox(
      {Key key,
      this.title,
      this.descriptions,
      this.text,
      this.img,
      this.data,
      this.cancel,
      this.callback})
      : super(key: key);

  @override
  _NoLoyaltyDialogBoxState createState() => _NoLoyaltyDialogBoxState();
}

class _NoLoyaltyDialogBoxState extends State<NoLoyaltyDialogBox> {
  AuthenticationBloc _auth;

  @override
  void initState() {
    _auth = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: COLOR_CONST.DEFAULT,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          margin: EdgeInsets.only(top: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'roboto'),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: COLOR_CONST.TIPA_GREY,
                    fontFamily: 'roboto'),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 8,
                    child: JJGreenNoLoyaltyButton(
                        text: widget.text,
                        function: () {
                          Navigator.pop(context);
                          _auth.add(FinishRegisterEvent(widget.data, true,
                              loyalty: "yes"));
                        }),
                  ),
                  Flexible(
                    child: Container(),
                    flex: 1,
                  ),
                  Flexible(
                    flex: 8,
                    child: JJFlatButton(
                        text: widget.cancel,
                        function: () {
                          print("lol");
                          Navigator.pop(context);
                          _auth.add(FinishRegisterEvent(widget.data, true,
                              loyalty: "no"));
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
        Positioned(
          child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop()),
          right: 0,
          top: 20,
          height: 50,
        ),
      ],
    );
  }
}
