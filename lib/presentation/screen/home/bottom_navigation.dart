import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/bloc.dart';
import 'package:jam_app/app/user_bloc/user_bloc.dart';
import 'package:jam_app/main.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/presentation/router.dart';
import 'package:jam_app/presentation/screen/home/features/history/history_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/history/history_routes.dart';
import 'package:jam_app/presentation/screen/home/features/map/map_screen.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/profile_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/profile_route.dart';
import 'package:jam_app/presentation/screen/home/features/scan/scan_router.dart';
import 'package:jam_app/presentation/screen/home/features/shop/detail/product_detail_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/shop_router.dart';
import 'package:jam_app/utils/helpers.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:jam_app/widgets/dialog.dart';
import 'package:jam_app/widgets/dialogs/cold_brew_pop_up.dart';
import 'package:jam_app/widgets/dialogs/mark_order_dialog.dart';
import 'package:jam_app/widgets/info_dialog.dart';

import 'features/profile/bloc/sales_departments_bloc.dart';

enum TabItem { jameson, shop, scan, orders, profile, map }

class BottomNavigation extends StatefulWidget {
  final bool isAuth;
  BottomNavigation({this.isAuth});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  TabItem _currentTab = TabItem.jameson;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.jameson: GlobalKey<NavigatorState>(),
    TabItem.shop: GlobalKey<NavigatorState>(),
    TabItem.scan: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
    TabItem.map: GlobalKey<NavigatorState>(),
  };

  AuthenticationBloc _auth;
  String currentLang = "";
  UserBloc _user;

  @override
  void initState() {
    super.initState();

    _auth = BlocProvider.of<AuthenticationBloc>(context);
    if (widget.isAuth) {
      BlocProvider.of<ProfileBloc>(context).add(GetProfileDataEvent());
    }

    _user = UserBloc(RepositoryProvider.of<UserRepository>(context));
    _user.add(GetUsersOrdersMarkEvent());
  }

  void _getLocale() {
    if (context.locale == Locale("kk", "KZ")) {
      currentLang = "kz";
    } else {
      currentLang = "ru";
    }
  }

  void onPageSelected(TabItem item) {
    Analytics().doEventByItem(item);

    if (item == TabItem.orders) {
      if (context.locale == Locale("kk", "KZ")) {
        BlocProvider.of<HistoryBloc>(context)
          ..add(GetHistoryDataEvent(language: "kz"));
      } else {
        BlocProvider.of<HistoryBloc>(context)
          ..add(GetHistoryDataEvent(language: "ru"));
      }
    }

    if (!widget.isAuth && item != TabItem.shop && item != TabItem.jameson) {
      showBottomMenuDialog('check_out.sign_up_to_stash_bonus'.tr(), "",
          'check_out.sign_up'.tr(), "sign_up");
      // signUp();
    } else {
      if (_currentTab == item) {
        _navigatorKeys[item].currentState.popUntil((route) => route.isFirst);
      } else {
        setState(() {
          _currentTab = item;
        });
      }
    }
  }

  Future<void> showBottomMenuDialog(
      String title, String desc, String btnText, String doIt) async {
    return await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CustomDialogBox(
              title: title, descriptions: desc, text: btnText, doIt: doIt);
        });
  }

  void signUp() {
    Navigator.pop(context);
    _auth.add(GoRegisterPageEvent());
  }

  Future<bool> onWillPop() async {
    final isFirstRouteInTab =
        !await _navigatorKeys[_currentTab].currentState.maybePop();
    return isFirstRouteInTab;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _user),
        ],
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is GoScanToHistoryState) {
              onPageSelected(TabItem.orders);
            }
            if (state is ColdBrewModeState) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ColdBrewPopUpDialog();
                  }); //temporary
            }
            if (state is OrderMarkDialogState) {
              state.ids.forEach((element) async {
                await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return MarkOrderDialogBox(id: element);
                    });
              });
            }
          },
          listenWhen: (previous, current) {
            if (current is CleanUserState) {
              return false;
            }
            return true;
          },
          buildWhen: (previous, current) {
            if (current is GoScanToHistoryState) {
              return false;
            }
            if (current is CleanUserState) {
              return false;
            }
            if (current is OrderMarkDialogState) {
              return false;
            }
            if (current is ColdBrewModeState) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state is InitialUserState) {
              _getLocale();
              return Scaffold(
                body: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(coldBrew
                                ? backgroundImageHome
                                : backgroundImage),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: buildBody()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: buildBottomNavBar(),
                    )
                  ],
                ),
              );
            } else if (state is FetchedUserState) {}
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        buildPage(TabItem.jameson),
        buildPage(TabItem.shop),
        buildPage(TabItem.scan),
        buildPage(TabItem.orders),
        buildPage(TabItem.profile),
      ],
    );
  }

  Widget buildHomeItem(String text, Widget icon, TabItem item) {
    return Container(
        height: 70,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: GREEN_DARKER,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Center(
          child: ListTile(
            onTap: () {
              onPageSelected(item);
            },
            leading: Container(
              decoration: BoxDecoration(
                color: GREEN,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: icon,
            ),
            title: Text('$text', style: Theme.of(context).textTheme.headline3)
                .tr(),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: COLOR_CONST.DEFAULT,
              size: 14,
            ),
          ),
        ));
  }

  Widget buildMapItem(String text, Widget icon) {
    return Container(
        height: 70,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: GREEN_DARKER,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Center(
          child: ListTile(
            onTap: () {
              print("Map tapped");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
            leading: Container(
              decoration: BoxDecoration(
                color: GREEN,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: icon,
            ),
            title: Text('$text', style: Theme.of(context).textTheme.headline3)
                .tr(),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: COLOR_CONST.DEFAULT,
              size: 14,
            ),
          ),
        ));
  }

  Widget buildWelcomeBonusItem(bool initBonus) {
    return !initBonus
        ? Container(
            height: 70,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: GREEN_DARKER,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Center(
              child: ListTile(
                onTap: () async {
                  Analytics().doNamedEvent("tap_banner", "banner");

                  var waitPage = await locator<NavigationService>()
                      .navigateTo(AppRouter.EDIT_PROFILE);
                  if (waitPage != null) {
                    BlocProvider.of<ProfileBloc>(context)
                      ..add(GetProfileDataEvent());
                  }
                },
                title: Text('home.fill_profile_1'.tr(),
                        style: Theme.of(context).textTheme.headline3)
                    .tr(),
                subtitle: Text('home.fill_profile_2'.tr(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: COLOR_CONST.DEFAULT)),
                trailing: welcomeIcon,
              ),
            ))
        : Container();
  }

  Widget buildPage(TabItem tabItem) {
    Widget route;
    if (tabItem == TabItem.jameson) {
      return Center(
          child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(child: Container(width: 120, height: 60, child: logoIcon)),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "J coins",
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              width: 10,
            ),
            jjActiveIcon
          ]),
          SizedBox(
            height: 10,
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is FetchedProfileState) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                        bonusFormatted(state.name.bonus),
                        style:
                            TextStyle(color: COLOR_CONST.DEFAULT, fontSize: 38),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildWelcomeBonusItem(state.name.initialBonus),
                  ],
                );
              }
              return Center(
                child: Column(
                  children: [
                    Text(
                      'home.stash_bonus'.tr(),
                      style: TextStyle(
                          fontSize: 18,
                          color: COLOR_CONST.DEFAULT,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        _auth.add(GoRegisterPageEvent());
                      },
                      child: Text(
                        'home.do_register'.tr(),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: COLOR_CONST.DEFAULT,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          ),
          coldBrew
              ? GestureDetector(
                  onTap: () {
                    Analytics().doNamedEvent("cold_brew_banner", "banner");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ProductDetailScreen(
                                127))); //ID of cold brew
                  },
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 12, left: 24, right: 24),
                      child: Image.asset(
                        context.locale == Locale("kk", "KZ")
                            ? "assets/images/aa.png"
                            : "assets/images/cold_brew_promo.png",
                      )),
                )
              : Container(),
          buildHomeItem(
              'home.upload_check'.tr().toUpperCase(), scanIcon, TabItem.scan),
          buildHomeItem('home.exclusive_merch'.tr().toUpperCase(),
              shopYellowIcon, TabItem.shop),
          buildHomeItem('home.bonus_history'.tr().toUpperCase(),
              orderYellowIcon, TabItem.orders),
          // buildMapItem(
          //     'home.where_to_buy_jameson'.tr().toUpperCase(), mapYellowIcon),
          Container(
            margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
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
          SizedBox(
            height: 170,
          ),
        ],
      ));
    }

    if (tabItem == TabItem.shop)
      route = ShopRoutes(navigatorKey: _navigatorKeys[tabItem]);
    if (tabItem == TabItem.scan)
      route = ScanRoutes(navigatorKey: _navigatorKeys[tabItem]);
    if (tabItem == TabItem.orders)
      route = HistoryRoutes(navigatorKey: _navigatorKeys[tabItem]);
    if (tabItem == TabItem.profile)
      route = ProfileRoutes(navigatorKey: _navigatorKeys[tabItem]);

    return Offstage(offstage: _currentTab != tabItem, child: route);
  }

  Widget buildBottomNavBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: COLOR_CONST.DEFAULT,
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: barItems),
    );
  }

  List<Widget> get barItems {
    return [
      buildBarItemJJ(TabItem.jameson, jjActiveIcon),
      buildBarItemShop(TabItem.shop, shopIcon),
      buildScanButton(TabItem.scan),
      buildBarItemOrder(TabItem.orders, orderIcon),
      buildBarItemProfile(TabItem.profile, profileIcon),
    ];
  }

  Widget buildBarItemJJ(TabItem tabItem, SvgPicture icon) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(),
      child: IconButton(
        color: GREEN,
        onPressed: () {
          onPageSelected(tabItem);
        },
        icon: tabItem == _currentTab ? jjActiveIcon : jjPassiveIcon,
      ),
    );
  }

  Widget buildBarItemShop(
    TabItem tabItem,
    SvgPicture icon,
  ) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(),
      child: IconButton(
          onPressed: () {
            onPageSelected(tabItem);
          },
          icon: SvgPicture.asset(
            'assets/images/shop_icon.svg',
            semanticsLabel: '',
            color: tabItem != _currentTab ? GREEN : COLOR_CONST.RED2,
          )),
    );
  }

  Widget buildBarItemProfile(
    TabItem tabItem,
    SvgPicture icon,
  ) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(),
      child: IconButton(
          color: tabItem == _currentTab ? GREEN : COLOR_CONST.RED2,
          onPressed: () {
            onPageSelected(tabItem);
          },
          icon: SvgPicture.asset(
            'assets/images/profile_icon.svg',
            semanticsLabel: '',
            color: tabItem != _currentTab ? GREEN : COLOR_CONST.RED2,
          )),
    );
  }

  Widget buildBarItemOrder(TabItem tabItem, SvgPicture icon) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(),
      child: IconButton(
          color: tabItem == _currentTab ? GREEN : COLOR_CONST.RED2,
          onPressed: () {
            onPageSelected(tabItem);
          },
          icon: SvgPicture.asset(
            'assets/images/history_icon.svg',
            semanticsLabel: '',
            color: tabItem != _currentTab ? GREEN : COLOR_CONST.RED2,
          )),
    );
  }

  Widget buildScanButton(TabItem tabItem) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(13, 121, 76, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onPressed: () {
        onPageSelected(tabItem);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: scanIcon,
      ),
    );
  }

  final Widget jjActiveIcon =
      SvgPicture.asset('assets/images/jj_active_icon.svg', semanticsLabel: '');

  final Widget jjPassiveIcon = SvgPicture.asset(
    'assets/images/jj_passive_icon.svg',
    semanticsLabel: '',
    color: GREEN,
  );

  final Widget scanIcon =
      SvgPicture.asset('assets/images/scan_icon.svg', semanticsLabel: '');

  final Widget shopIcon =
      SvgPicture.asset('assets/images/shop_icon.svg', semanticsLabel: '');

  final Widget shopYellowIcon = SvgPicture.asset(
    'assets/images/shop_icon.svg',
    semanticsLabel: '',
    color: COLOR_CONST.DEFAULT,
  );

  final Widget orderYellowIcon = SvgPicture.asset(
    'assets/images/history_icon.svg',
    semanticsLabel: '',
    color: COLOR_CONST.DEFAULT,
  );

  final Widget mapYellowIcon = SvgPicture.asset(
    'assets/images/map_icon.svg',
    semanticsLabel: '',
    color: COLOR_CONST.DEFAULT,
  );

  Widget profileIcon =
      SvgPicture.asset('assets/images/profile_icon.svg', semanticsLabel: '');

  Widget welcomeIcon =
      SvgPicture.asset('assets/images/welcome_bonus.svg', semanticsLabel: '');

  Widget orderIcon =
      SvgPicture.asset('assets/images/history_icon.svg', semanticsLabel: '');

  final Widget logoIcon = SvgPicture.asset(
    logoImage,
    semanticsLabel: '',
  );
}
