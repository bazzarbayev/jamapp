import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/widgets/jj_day_widget.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/widgets/jj_year_widget.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/city_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/profile_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/widgets/jj_text.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:easy_localization/easy_localization.dart';

//const
String cityGlobal = "";
String cityStatusGlobal = "";

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ProfileBloc _bloc;

  @override
  void initState() {
    Analytics().doEventCustom("profile_edit");

    _bloc = BlocProvider.of<ProfileBloc>(context)..add(GetProfileDataEvent());
    BlocProvider.of<CityBloc>(context)..add(GetCityDataEvent());
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
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: COLOR_CONST.DEFAULT),
              title: Text(
                "edit_profile.title".tr().toUpperCase(),
                style: Theme.of(context).textTheme.headline6,
              ),
              backgroundColor: Colors.transparent,
            ),
            body: EditProfileBody()));
  }
}

class EditProfileBody extends StatefulWidget {
  @override
  _EditProfileBodyState createState() => _EditProfileBodyState();
}

enum Gender { MALE, FEMALE }

class _EditProfileBodyState extends State<EditProfileBody> {
  var name = TextEditingController();
  var surname = TextEditingController();
  var street = TextEditingController();
  var dom = TextEditingController();
  var kv = TextEditingController();
  var blok = TextEditingController();
  var podezd = TextEditingController();
  var comments = TextEditingController();
  var instagram = TextEditingController();
  var facebook = TextEditingController();
  var email = TextEditingController();
  var _city = "";
  var _oldCity = "";

  final _monthContr = TextEditingController();
  final _dayContr = TextEditingController();
  final _yearContr = TextEditingController();

  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();

  ProfileBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _monthContr.dispose();
    _dayContr.dispose();
    _yearContr.dispose();

    name.dispose();
    email.dispose();
    surname.dispose();
    street.dispose();
    dom.dispose();
    kv.dispose();
    blok.dispose();
    podezd.dispose();
    comments.dispose();
    instagram.dispose();
    facebook.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Gender _character = null;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is FetchedProfileState) {
          // selectGender(state.name.sex);

          var user = state.name;
          _city = state.name.city;

          SharedPreferences.getInstance()
              .then((value) => value.setString("city", state.name.city));

          name.text = state.name.name;
          surname.text = state.name.surname;
          street.text = state.name.street;
          dom.text = state.name.house;
          kv.text = state.name.apartment;
          blok.text = state.name.block;
          podezd.text = state.name.entrance;
          comments.text = state.name.comment;
          email.text = state.name.email;
          instagram.text = state.name.instagram;
          facebook.text = state.name.facebook;

          if (state.name.date_of_birth.isNotEmpty) {
            try {
              var dd = DateFormat('dd-MM-yyyy').parse(state.name.date_of_birth);
              _dayContr.text = dd.day.toString();
              _monthContr.text = dd.month.toString();
              _yearContr.text = dd.year.toString();
            } catch (e) {
              try {
                SharedPreferences.getInstance().then((value) {
                  var s = value.getString("userAge");
                  var dd = DateFormat('dd-MM-yyyy').parse(s);
                  _dayContr.text = dd.day.toString();
                  _monthContr.text = dd.month.toString();
                  _yearContr.text = dd.year.toString();
                });
              } catch (e) {}
            }
          } else {
            try {
              SharedPreferences.getInstance().then((value) {
                var s = value.getString("userAge");
                var dd = DateFormat('dd-MM-yyyy').parse(s);
                _dayContr.text = dd.day.toString();
                _monthContr.text = dd.month.toString();
                _yearContr.text = dd.year.toString();
              });
            } catch (e) {}
          }

          return ListView(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 32, 12),
                        child: Text(
                          "edit_profile.cancel".tr(),
                          style: TextStyle(
                              color: COLOR_CONST.DEFAULT,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (name.text.length <= 1) {
                        final snackBar = SnackBar(
                            content: Text("edit_profile.fill_name".tr()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      if (surname.text.length <= 1) {
                        final snackBar = SnackBar(
                            content: Text("edit_profile.fill_surname".tr()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      if (email.text.length <= 1) {
                        final snackBar = SnackBar(
                            content: Text("edit_profile.fill_email".tr()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      if (street.text.length <= 1) {
                        final snackBar = SnackBar(
                            content: Text("edit_profile.fill_street".tr()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      if (dom.text.length <= 1) {
                        final snackBar = SnackBar(
                            content: Text("edit_profile.fill_house".tr()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      // if (kv.text.length <= 1) {
                      //   final snackBar =
                      //       SnackBar(content: Text("edit_profile.fill_kv".tr()));
                      //   Scaffold.of(context).showSnackBar(snackBar);
                      //   return;
                      // }

                      var cityPref =
                          await SharedPreferences.getInstance().then((value) {
                        return value.getString("city");
                      });

                      if (cityPref.isEmpty) {
                        final snackBar = SnackBar(
                            content: Text("edit_profile.fill_city".tr()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      try {
                        user.name = name.text;
                        user.surname = surname.text;
                        user.street = street.text;
                        user.house = dom.text;
                        user.apartment = kv.text;
                        user.block = blok.text;
                        user.entrance = podezd.text;
                        user.comment = comments.text;
                        user.city = _city;
                        user.email = email.text;
                        user.instagram = instagram.text;
                        user.facebook = facebook.text;

                        user.date_of_birth =
                            "${_dayContr.text}-${_monthContr.text}-${_yearContr.text}";

                        if (_character == Gender.FEMALE) {
                          user.sex = "female";
                        } else {
                          user.sex = "male";
                        }

                        print(user.toString());

                        _bloc.add(UpdateProfileEvent(user));
                        Navigator.pop(context, "data");
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 32, 12),
                        child: Text(
                          "edit_profile.ready".tr(),
                          style: TextStyle(
                              color: COLOR_CONST.DEFAULT,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(48)),
                    color: GREEN_DARKER),
                padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Text("edit_profile.personal_data".tr(),
                        style: Theme.of(context).textTheme.headline3),
                    SizedBox(
                      height: 24,
                    ),
                    JJTextLabelWidget(
                        controller: name, text: "edit_profile.name".tr()),
                    SizedBox(
                      height: 12,
                    ),
                    JJTextLabelWidget(
                        controller: surname, text: "edit_profile.surname".tr()),
                    SizedBox(
                      height: 12,
                    ),
                    JJTextEmailWidget(controller: email, text: "Email*"),
                    SizedBox(
                      height: 12,
                    ),
                    Text("edit_profile.gender".tr(),
                        style: TextStyle(fontSize: 12, color: GREEN)),
                    ProfileGenderWidget(gen: state.name.sex),
                    SizedBox(
                      height: 14,
                    ),
                    birthDateRow(),
                    SizedBox(
                      height: 14,
                    ),
                    Text("edit_profile.nomer_phone".tr(),
                        style: TextStyle(fontSize: 12, color: GREEN)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(state.name.phone,
                        style: Theme.of(context).textTheme.headline3),
                    SizedBox(
                      height: 24,
                    ),
                    Text("edit_profile.city".tr() + "*",
                        style: TextStyle(fontSize: 12, color: GREEN)),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileCityWidget(state.name.city),
                    SizedBox(
                      height: 12,
                    ),
                    JJTextLabelWidget(
                        controller: street, text: "edit_profile.street".tr()),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: JJTextLabelWidget(
                              controller: dom, text: "edit_profile.house".tr()),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: JJTextLabelWidget(
                              controller: kv, text: "edit_profile.kv".tr()),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: JJTextLabelWidget(
                              controller: blok,
                              text: "edit_profile.block".tr()),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: JJTextLabelWidget(
                              controller: podezd,
                              text: "edit_profile.podezd".tr()),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    JJTextLabelWidget(
                        controller: instagram, text: 'Instagram'),
                    SizedBox(
                      height: 12,
                    ),
                    JJTextLabelWidget(
                        controller: facebook, text: 'Facebook'),
                    SizedBox(
                      height: 12,
                    ),
                    JJTextLabelWidget(
                        controller: comments,
                        text: "edit_profile.comments".tr()),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  birthDateRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("edit_profile.birthday".tr(),
            style: TextStyle(fontSize: 12, color: GREEN)),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
          ],
        ),
      ],
    );
  }
}

class ProfileGenderWidget extends StatefulWidget {
  final String gen;
  ProfileGenderWidget({Key key, this.gen}) : super(key: key);
  @override
  _ProfileGenderWidgetState createState() => _ProfileGenderWidgetState();
}

class _ProfileGenderWidgetState extends State<ProfileGenderWidget> {
  Gender _character;

  ProfileBloc _bloc;

  @override
  void initState() {
    _character = _selectGender(widget.gen);
    print(_character.toString());
    _bloc = BlocProvider.of<ProfileBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<Gender>(
            activeColor: GREEN,
            title: Text(
              "edit_profile.male".tr(),
              style: TextStyle(color: COLOR_CONST.DEFAULT, fontSize: 12),
            ),
            value: Gender.MALE,
            groupValue: _character,
            onChanged: (Gender value) {
              _bloc.add(SetGenderEvent("male"));

              setState(() {
                _character = value;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile<Gender>(
            activeColor: GREEN,
            title: Text(
              "edit_profile.female".tr(),
              style: TextStyle(color: COLOR_CONST.DEFAULT, fontSize: 12),
            ),
            value: Gender.FEMALE,
            groupValue: _character,
            onChanged: (Gender value) {
              _bloc.add(SetGenderEvent("female"));

              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Gender _selectGender(String str) {
    if (str == "male") {
      return Gender.MALE;
    } else if (str == "female") {
      return Gender.FEMALE;
    } else {
      return null;
    }
  }
}

class ProfileCityWidget extends StatefulWidget {
  final String city;
  ProfileCityWidget(this.city);

  @override
  _ProfileCityWidgetState createState() => _ProfileCityWidgetState();
}

class _ProfileCityWidgetState extends State<ProfileCityWidget> {
  var _city = "";
  var _cityStatus = "";
  ProfileBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<ProfileBloc>(context);
    _city = widget.city;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 55.0,
            decoration: BoxDecoration(
              border: Border.all(color: COLOR_CONST.DEFAULT, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      _city.isEmpty ? "edit_profile.city".tr() : _city,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
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
                      onPressed: () => _showCityPicker(context)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void setCity(String city, String cityStatus) {
    setState(() {
      _city = city;
      _cityStatus = cityStatus;
    });
    _bloc.add(SetCityProfileEvent(
      _city,
      _cityStatus,
    ));
  }

  void setCityInit(String city, String cityStatus) {
    _city = city;
    _cityStatus = cityStatus;

    _bloc.add(SetCityProfileEvent(
      _city,
      _cityStatus,
    ));
  }

  void _showCityPicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: COLOR_CONST.YELLOW_LIGHT,
              child: Column(
                children: [
                  Container(
                      height: 400,
                      child: BlocBuilder<CityBloc, CityState>(
                          builder: (context, state) {
                        if (state is FetchedCityState) {
                          return CityPicker(
                            list: state.response,
                          );
                        }
                        return Container();
                      })),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        setCity(cityGlobal, cityStatusGlobal);
                      });
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }
}

class CityPicker extends StatefulWidget {
  List<CityResponse> list;

  CityPicker({Key key, @required this.list}) : super(key: key);

  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  @override
  void initState() {
    cityGlobal = widget.list[0].name;
    cityStatusGlobal = widget.list[0].status;
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
      },
    );
  }
}
