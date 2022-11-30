import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/bloc.dart';
import 'package:jam_app/main.dart';
import 'package:jam_app/presentation/router.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/age_confirm_screen.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/profile_bloc.dart';
import 'package:jam_app/utils/helpers.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:jam_app/widgets/info_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var locator = GetIt.instance;

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

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              "profile.profile".tr().toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(right: 16),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: COLOR_CONST.DEFAULT, width: 2),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(Icons.edit_outlined,
                                color: COLOR_CONST.DEFAULT),
                          ),
                        ),
                        onTap: () async {
                          var waitPage = await locator<NavigationService>()
                              .navigateTo(AppRouter.EDIT_PROFILE);
                          if (waitPage != null) {
                            BlocProvider.of<ProfileBloc>(context)
                              ..add(GetProfileDataEvent());
                            setState(() {});
                          }
                        }),
                    Expanded(child: Container()),
                    GestureDetector(
                        onTap: () {
                          Analytics()
                              .doEventCustom("kz_language_change_profile_page");
                          setState(() {
                            _currentLang = Languages.KZ;
                          });
                          EasyLocalization.of(context).locale =
                              Locale("kk", "KZ");
                        },
                        child: Container(
                          width: 60,
                          height: 40,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: _currentLang == Languages.KZ
                              ? BoxDecoration(
                                  border: Border.all(color: GREEN, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)))
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
                        Analytics()
                            .doEventCustom("ru_language_change_profile_page");

                        setState(() {
                          _currentLang = Languages.RU;
                        });
                        EasyLocalization.of(context).locale =
                            Locale("ru", "RU");
                      },
                      child: Container(
                        width: 60,
                        height: 40,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: _currentLang == Languages.RU
                            ? BoxDecoration(
                                border: Border.all(color: GREEN, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)))
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
                      width: 24,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(32),
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                    if (state is FetchedProfileState) {
                      return Table(
                        children: [
                          _buildProfileRow(
                              "profile.name".tr(), state.name.name),
                          _buildTableRowSpace(),
                          _buildProfileRow(
                              "profile.phone".tr(), state.name.phone),
                          _buildTableRowSpace(),
                          _buildProfileRow(
                              "profile.city".tr(), state.name.city),
                          _buildTableRowSpace(),
                          _buildProfileRow(
                              "profile.address".tr(), state.name.street),
                          _buildTableRowSpace(),
                          _buildProfileRow('Instagram', state.name.instagram),
                          _buildTableRowSpace(),
                          _buildProfileRow('Facebook', state.name.facebook),
                          _buildTableRowSpace(),
                          _buildTableRowSpace(),
                          _buildTableRowSpace(),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "profile.my_bonus".tr(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: COLOR_CONST.DEFAULT,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    bonusFormatted(state.name.bonus),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: COLOR_CONST.DEFAULT,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  jjActiveIcon
                                ]),
                          ]),
                        ],
                      );
                    }
                    return Container();
                  }),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(32, 16, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InfoDialog();
                          });
                    },
                    child: Text(
                      'home.how_to_stash_bonus'.tr(),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          color: COLOR_CONST.DEFAULT,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(32, 32, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
                      var url = "";
                      if (_currentLang == Languages.KZ) {
                        url =
                            "http://jameson.ibec.systems/Mehanika_Jameson_J-Family_dlya_publikatsii_1_%D0%BA%D0%B0%D0%B7.pdf";
                      } else {
                        url = "https://admin.jameson.kz/rules.pdf";
                      }

                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      'profile.full_activity_rules'.tr(),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          color: COLOR_CONST.DEFAULT,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                buildProfileItem(
                    "profile.my_orders".tr().toUpperCase(), listIcon, true),
                SizedBox(
                  height: 2,
                ),
                buildProfileItem("profile.contact_with_us".tr().toUpperCase(),
                    instaIcon, false),
                SizedBox(
                  height: 12,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(32, 16, 0, 0),
                  child: GestureDetector(
                    onTap: exitApp,
                    child: Text(
                      "exit".tr(),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          color: COLOR_CONST.DEFAULT,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ));
  }

  void exitApp() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setString("userAge", "12-01-1200");
    await prefs.setString("older_21", "yes");

    BlocProvider.of<AuthenticationBloc>(context)..add(GoRegisterPageEvent());
  }

  TableRow _buildProfileRow(String field, String value) {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          field,
          style: TextStyle(
              fontSize: 16,
              color: COLOR_CONST.DEFAULT,
              fontWeight: FontWeight.bold),
        )
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              color: COLOR_CONST.DEFAULT,
              fontWeight: FontWeight.bold),
        )
      ]),
    ]);
  }

  Widget buildProfileItem(String text, Widget icon, bool top) {
    return Container(
        height: 70,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: GREEN_DARKER,
            borderRadius: top
                ? BorderRadius.vertical(top: Radius.circular(20.0))
                : BorderRadius.vertical(bottom: Radius.circular(20.0))),
        child: Center(
          child: ListTile(
            onTap: () async {
              if (top) {
                _openOrdersPage();
              } else {
                var url = 'https://www.instagram.com/jamesonkz';
                print(url);

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  // throw 'Could not launch $url';
                }
              }
            },
            leading: Container(
              decoration: BoxDecoration(
                color: GREEN,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: icon,
            ),
            title: Text('$text', style: Theme.of(context).textTheme.headline3),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: COLOR_CONST.DEFAULT,
              size: 14,
            ),
          ),
        ));
  }

  void _openOrdersPage() => Navigator.pushNamed(context, "/my_orders");

  final Widget jjActiveIcon =
      SvgPicture.asset('assets/images/jj_active_icon.svg', semanticsLabel: '');

  final Widget listIcon =
      SvgPicture.asset('assets/images/list_icon.svg', semanticsLabel: '');

  final Widget instaIcon =
      SvgPicture.asset('assets/images/insta_icon.svg', semanticsLabel: '');

  TableRow _buildTableRowSpace() {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
        )
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
        )
      ]),
    ]);
  }
}
