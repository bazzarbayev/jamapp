import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/bloc.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jam_app/widgets/loading_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    Key key,
    @required AuthenticationBloc registrationBloc,
  })  : _registrationBloc = registrationBloc,
        super(key: key);

  final AuthenticationBloc _registrationBloc;

  @override
  RegistrationScreenState createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  RegistrationScreenState();

  var textEditingController =
      TextEditingController(text: "+7 " + "Номер телефона");

  var loading = false;
  var _isFill = false;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '+7(###)###-##-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ShowAlert) {
          setState(() {
            loading = false;
          });
        }
      },
      child: LoadingOverlay(
        isLoading: loading,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "phone_register.register_for_bonus".tr(),
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    maxLines: 1,
                    controller: textEditingController,
                    onChanged: (str) {
                      if (maskFormatter.isFill()) {
                        setState(() {
                          _isFill = true;
                        });
                      } else {
                        setState(() {
                          _isFill = false;
                        });
                      }
                    },
                    inputFormatters: [maskFormatter],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.,
                        suffixIcon: _isFill
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : null,
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: COLOR_CONST.DEFAULT),
                        ),
                        border: OutlineInputBorder(),
                        labelText: "",
                        labelStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "phone_register.5_symbol_code_text".tr(),
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
                              text: "phone_register.continue".tr(),
                              function: _load)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                GestureDetector(
                  onTap: () {
                    Analytics().doEventCustom("signup_later");

                    widget._registrationBloc.add(LogInNotAuthEvent());
                  },
                  child: Text(
                    "phone_register.sign_up_later".tr(),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _load() {
    FocusScope.of(context).unfocus();

    if (maskFormatter.getUnmaskedText().length != 10) {
      final snackBar = SnackBar(content: Text('Заполни номер'));
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        loading = true;
      });

      widget._registrationBloc
          .add(RegisterPhoneEvent(maskFormatter.getUnmaskedText()));
    }
  }
}
