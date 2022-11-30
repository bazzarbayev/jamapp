import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/main.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/presentation/router.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/profile_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/shop_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/check_out/check_out_success.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/basket_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/shop_screen.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  CounterBloc _counterBloc;
  AuthenticationBloc _authenticationBloc;
  var locator = GetIt.instance;

  BasketBloc _basketBloc;
  String _bonus = "0";

  @override
  void initState() {
    Analytics().doEventCustom("cart");

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _counterBloc = BlocProvider.of<CounterBloc>(context);
    _basketBloc = BlocProvider.of<BasketBloc>(context)
      ..add(GetBasketDataEvent());
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
              "basket.basket".tr().toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                BlocListener<CounterBloc, CounterState>(
                  listener: (context, state) {
                    if (state is RefreshBasketState) {
                      _basketBloc.add(GetBasketDataEvent());
                    }
                  },
                  child: BlocBuilder<BasketBloc, BasketState>(
                    builder: (context, state) {
                      if (state is RefreshBasketState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is FetchedBasketState &&
                          state.response.length != 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(32),
                              child: BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  if (state is FetchedProfileState) {
                                    _bonus = state.name.bonus;
                                    return _bonusInfo("basket.my_bonuses".tr(),
                                        state.name.bonusFormatted(), true);
                                  }
                                  return _bonusInfo(
                                      "basket.start_stash_bonus".tr(),
                                      "J coins",
                                      false);
                                },
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: COLOR_CONST.YELLOW_LIGHT,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: state.response.length,
                              itemBuilder: (context, index) {
                                return _buildBasketItem(state.response[index]);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'basket.positions_in_basket'.tr() +
                                        ": ${state.response.length}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: COLOR_CONST.DEFAULT),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'basket.summa'.tr() +
                                            ": " +
                                            sumFormat(state.money.toString()),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: COLOR_CONST.DEFAULT),
                                      ),
                                      jjActiveIcon
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity,
                                child: JJGreenButton(
                                    text: 'basket.confirm'.tr(),
                                    function: () async {
                                      if (state.money <= int.parse(_bonus) &&
                                          int.parse(_bonus) > 0) {
                                        var waitPage =
                                            await locator<NavigationService>()
                                                .navigateTo(
                                                    AppRouter.CHECK_OUT);

                                        if (waitPage == null) {
                                          _basketBloc.add(GetBasketDataEvent());
                                        }
                                        if (waitPage != null &&
                                            waitPage["result"] ==
                                                "success_check_out") {
                                          _basketBloc.add(GetBasketDataEvent());

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckOutSuccessScreen(
                                                          waitPage["id"])));

                                          // Navigator.pushNamed(
                                          //     context, "/check_out_success",
                                          //     arguments: {
                                          //       "id": waitPage["id"]
                                          //     });
                                        }
                                      } else {
                                        _authenticationBloc.add(ShowCustomAlert(
                                            'basket.error'.tr(),
                                            'basket.not_much_bonuses'.tr(),
                                            "Ок",
                                            ""));
                                      }
                                    })),
                          ],
                        );
                      }
                      if (state is FailureBasketState) {
                        return Center(
                          child: Text(state.error),
                        );
                      } else {
                        bonus = savedInitBonus; //restore to init bonus
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                            ),
                            Text(
                              "basket.empty_basket".tr(),
                              style: TextStyle(
                                  fontFamily: 'roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: COLOR_CONST.DEFAULT),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              "basket.stash_bonus_and_add_merches".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: COLOR_CONST.DEFAULT),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              child: JJGreenButton(
                                  text:
                                      "basket.back_to_shop".tr().toUpperCase(),
                                  function: () {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  }),
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildBasketItem(BasketItem item) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: COLOR_CONST.YELLOW_LIGHT,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(20.0)),
                      image: DecorationImage(
                          image: NetworkImage(item.item.srcImage),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale == Locale("kk", "KZ")
                            ? item.item.titleKz
                            : item.item.titleRu,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${item.item.priceFormatted()}",
                              style: TextStyle(
                                  color: GREEN,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            jjActiveIcon
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Row(
                        children: [
                          item.count != 1
                              ? GestureDetector(
                                  onTap: () {
                                    _counterBloc.add(BasketRemoveEvent(item));
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.remove,
                                      color: GREEN,
                                      size: 12,
                                    ),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: COLOR_CONST.YELLOW_COUNT,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                  ),
                                )
                              : Container(
                                  child: Icon(
                                    Icons.remove,
                                    color: GREEN,
                                    size: 12,
                                  ),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: COLOR_CONST.YELLOW_COUNT_LIGHT,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                ),
                          Container(
                            width: 40,
                            child: Center(child: Text(item.count.toString())),
                          ),
                          GestureDetector(
                            onTap: () {
                              _counterBloc.add(BasketAddEvent(item));
                            },
                            child: Container(
                              child: Icon(
                                Icons.add,
                                color: GREEN,
                                size: 12,
                              ),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: COLOR_CONST.YELLOW_COUNT,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            )),
        Positioned(
            right: -8,
            top: -8,
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 22, color: COLOR_CONST.DEFAULT),
                decoration: BoxDecoration(shape: BoxShape.circle, color: GREEN),
              ),
              onPressed: () {
                _counterBloc.add(RemovePositionEvent(item));
              },
            ))
      ],
    );
  }

  String sumFormat(String val) {
    try {
      return NumberFormat("##,###", "en_US").format(int.parse(val));
    } catch (e) {
      return NumberFormat("##,###", "en_US").format(0);
    }
  }

  _bonusInfo(String key, String value, bool isSized) {
    return Row(children: [
      Expanded(
        child: Text(
          key,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: COLOR_CONST.DEFAULT),
        ),
      ),
      Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value,
              style: isSized
                  ? TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: COLOR_CONST.DEFAULT)
                  : TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: COLOR_CONST.DEFAULT),
            ),
            SizedBox(
              width: 10,
            ),
            jjActiveIcon
          ]),
    ]);
  }

  final Widget jjActiveIcon =
      SvgPicture.asset('assets/images/jj_active_icon.svg', semanticsLabel: '');
}
