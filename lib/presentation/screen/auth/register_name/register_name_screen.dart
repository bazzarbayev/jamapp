import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jam_app/widgets/dialog.dart';
import 'package:jam_app/widgets/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

//const
String cityGlobal = "";
String cityStatusGlobal = "";
var isAvailable = false;
var isSelected = false;

class RegisterNameScreen extends StatefulWidget {
  const RegisterNameScreen({
    Key key,
    @required AuthenticationBloc registerNameBloc,
    List<CityResponse> list,
    String phone,
  })  : _registerNameBloc = registerNameBloc,
        _list = list,
        _phone = phone,
        super(key: key);

  final AuthenticationBloc _registerNameBloc;
  final List<CityResponse> _list;
  final String _phone;

  @override
  RegisterNameScreenState createState() {
    return RegisterNameScreenState();
  }
}

class RegisterNameScreenState extends State<RegisterNameScreen> {
  RegisterNameScreenState();

  var city = "";
  var isAvailable = false;
  var isSelected = false;

  var isAgreeWithRules = false;

  var _isLoading = false;

  var nameContr = TextEditingController();
  var instagramContr = TextEditingController();
  var facebookContr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // widget._registerNameBloc.add(GetCitiesAuthEvent());
    super.initState();
  }

  @override
  void dispose() {
    nameContr.dispose();
    instagramContr.dispose();
    facebookContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "register_name.enter_city".tr(),
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: nameContr,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.headline2,
                    validator: (str) {
                      if (str.isEmpty) {
                        return "register_name.error_name_empty".tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
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
                        hintText: "register_name.name".tr(),
                        hintStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 55.0,
                        margin: EdgeInsets.symmetric(horizontal: 30.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: COLOR_CONST.DEFAULT, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                  child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text(
                                    city.isEmpty
                                        ? "register_name.city".tr()
                                        : city,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              )),
                            ),
                            VerticalDivider(
                              thickness: 0.8,
                              color: COLOR_CONST.DEFAULT,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 6),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: COLOR_CONST.DEFAULT,
                                ),
                                onPressed: () => _showCityPicker(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: instagramContr,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.headline2,
                    validator: (str) {
                      if (str.isEmpty) {
                        return "register_name.error_instagram_empty".tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
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
                        hintText: 'Instagram',
                        hintStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: facebookContr,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.headline2,
                    // validator: (str) {
                    //   if (str.isEmpty) {
                    //     return "register_name.error_instagram_empty".tr();
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
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
                        hintText: 'Facebook',
                        hintStyle: TextStyle(color: COLOR_CONST.DEFAULT)),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                !isAvailable && isSelected
                    ? Text("register_name.error_loyalty".tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5)
                    : Container(),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isAgreeWithRules) {
                              isAgreeWithRules = false;
                            } else {
                              isAgreeWithRules = true;
                            }
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: COLOR_CONST.DEFAULT, width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: isAgreeWithRules
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                  )
                                : Container(
                                    width: 24,
                                    height: 24,
                                  )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          var url = 'http://irishluck.kz/terms';
                          print(url);

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            // throw 'Could not launch $url';
                          }
                        },
                        child: spans,
                      )),
                    ],
                  ),
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
                              text: "register_name.register".tr(),
                              function: isAgreeWithRules ? _load : null)),
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
      ),
    );
  }

  final spans = Text('register_name.personality_confirm_3'.tr(),
      style: TextStyle(
          color: COLOR_CONST.DEFAULT,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline));

  void _load() async {
    if (_formKey.currentState.validate()) {
      if (city.isEmpty) {
        final snackBar =
            SnackBar(content: Text('register_name.error_city'.tr()));
        // ignore: deprecated_member_use
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          _isLoading = true;
        });
        widget._registerNameBloc.add(FinishRegisterEvent(
            new FinishRegisterData(
                city: city,
                name: nameContr.text,
                phone: widget._phone,
                instagram: instagramContr.text,
                facebook: facebookContr.text),
            isAvailable,
            localizationText: {
              "main_text": 'register_name.city_loyalty'.tr(),
              "yes_thanks": 'register_name.city_loyalty_yes'.tr(),
              "no_thanks": 'register_name.city_loyalty_no'.tr(),
            },
            loyalty: ""));

        await Future.delayed(Duration(seconds: 2)).then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  void _showCityPicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: COLOR_CONST.YELLOW_LIGHT,
              child: Column(
                children: [
                  Container(height: 400, child: _picker()),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        city = cityGlobal;
                        if (cityStatusGlobal == "yes") {
                          isAvailable = true;
                        } else if (cityStatusGlobal == "no") {
                          isAvailable = false;
                        }
                      });
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  Widget _picker() {
    cityGlobal = widget._list[0].name;
    cityStatusGlobal = widget._list[0].status;

    return CupertinoPicker(
      looping: false,
      scrollController: FixedExtentScrollController(initialItem: 0),
      magnification: 1.3,
      backgroundColor: COLOR_CONST.DEFAULT_2,
      children: <Widget>[
        for (int i = 0; i < widget._list.length; i++)
          Text(
            widget._list[i].name,
            style: TextStyle(color: Colors.black, fontSize: 20),
          )
      ],
      itemExtent: 44, //height of each item
      onSelectedItemChanged: (int index) {
        setState(() {
          cityGlobal = widget._list[index].name;
          cityStatusGlobal = widget._list[index].status;

          isSelected = true;
        });
      },
    );
  }
}

class CityPicker extends StatefulWidget {
  final Function(String city, String cityStatus) notifyParent;
  final Function(String city, String cityStatus) notifyParentInit;

  List<CityResponse> list;

  CityPicker(
      {Key key,
      @required this.notifyParent,
      @required this.notifyParentInit,
      @required this.list})
      : super(key: key);

  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  @override
  void initState() {
    // widget.notifyParentInit(widget.list[0].name, widget.list[0].status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      looping: false,
      magnification: 1.3,
      backgroundColor: COLOR_CONST.DEFAULT_2,
      children: <Widget>[
        for (int i = 0; i < widget.list.length; i++)
          Text(
            widget.list[i].name,
            style: TextStyle(color: Colors.black, fontSize: 20),
          )
      ],
      itemExtent: 44, //height of each item
      onSelectedItemChanged: (int index) {
        cityGlobal = widget.list[index].name;
        cityStatusGlobal = widget.list[index].status;
        // widget.notifyParent(widget.list[index].name, widget.list[index].status);
      },
    );
  }
}
