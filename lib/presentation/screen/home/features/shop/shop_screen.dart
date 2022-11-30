import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/profile_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/shop_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/widgets/basket_icon.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:jam_app/widgets/filter_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

import 'model/shop_item.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

String bonus = "0";
String savedInitBonus = "0";

class _ShopScreenState extends State<ShopScreen> {
  CounterBloc _counterBloc;
  AuthenticationBloc _authBloc;

  @override
  void initState() {
    _counterBloc = BlocProvider.of<CounterBloc>(context);
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);

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
            iconTheme: IconThemeData(color: COLOR_CONST.DEFAULT),
            title: Text(
              "Jameson Shop".toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            actions: [
              BasketIcon(),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: _tableRow(),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: COLOR_CONST.YELLOW_LIGHT,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
                FilterRowWidget(),
                BlocConsumer<ShopBloc, ShopState>(
                  listener: (context, state) {
                    if (state is FilterShopListener) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterBox(
                              currentFilter: shopOrder,
                            );
                          });
                    }
                  },
                  buildWhen: (previous, current) {
                    if (current is CleanShopListener) {
                      return false;
                    }
                    if (current is FilterShopListener) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is InitialShopState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is FetchedShopState) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: state.response.length,
                        itemBuilder: (context, index) {
                          return _buildShopItem(state.response[index]);
                        },
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(
                  height: 150,
                )
              ],
            ),
          )),
    );
  }

  Widget _buildShopItem(ShopItem item) {
    return GestureDetector(
      onTap: () async {
        var detail = await Navigator.pushNamed(context, "/shop/detail",
            arguments: {"id": item.id});
        if (detail == null) {
          BlocProvider.of<CounterBloc>(context)..add(GetCounterDataEvent());
        }
      },
      child: Container(
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
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20.0)),
                    image: DecorationImage(
                        image: NetworkImage(item.mainImage.src),
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
                      context.locale.toString() == "kk_KZ"
                          ? item.name.kz
                          : item.name.ru,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'shop.current_count_shop'
                          .tr(args: ['${item.stockQuantity}']),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${item.priceFormatted()}",
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
                  GestureDetector(
                    onTap: () {
                      _counterBloc.add(IncrementEvent(item, bonus));
                    },
                    child: Container(
                      child: Icon(Icons.add, color: Colors.white),
                      width: 65,
                      height: 35,
                      decoration: BoxDecoration(
                          color: GREEN,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )),
    );
  }

  Widget _tableRow() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is FetchedProfileState) {
          bonus = state.name.bonus;

          return _bonusInfo(
              'shop.my_bonuses'.tr(), state.name.bonusFormatted(), true);
        }
        return _bonusInfo('shop.start_stash_bonus'.tr(), "J coins", false);
      },
    );
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

var _type = "";

class FilterRowWidget extends StatefulWidget {
  @override
  _FilterRowWidgetState createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _type = "merch";
            });
            shopType = "1";
            var filter =
                GetShopDataFilterEvent(order: shopOrder, type: shopType);
            BlocProvider.of<ShopBloc>(context)..add(filter);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            decoration: _type == "merch"
                ? BoxDecoration(
                    border: Border.all(color: GREEN, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)))
                : null,
            child: Row(
              children: [
                Text(
                  "Мерч",
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  width: 12,
                ),
                _type == "merch"
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = "";
                          });

                          shopType = "";

                          var filter = GetShopDataFilterEvent(
                              order: shopOrder, type: shopType);
                          BlocProvider.of<ShopBloc>(context)..add(filter);
                        },
                        child: Icon(
                          Icons.close,
                          size: 22,
                          color: COLOR_CONST.YELLOW_COUNT,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _type = "jameson";
            });
            shopType = "2";
            var filter =
                GetShopDataFilterEvent(order: shopOrder, type: shopType);
            BlocProvider.of<ShopBloc>(context)..add(filter);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: _type == "jameson"
                ? BoxDecoration(
                    border: Border.all(color: GREEN, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)))
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Jameson",
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  width: 12,
                ),
                _type == "jameson"
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = "";
                          });
                          shopType = "";

                          var filter = GetShopDataFilterEvent(
                              order: shopOrder, type: shopType);
                          BlocProvider.of<ShopBloc>(context)..add(filter);
                        },
                        child: Icon(
                          Icons.close,
                          size: 22,
                          color: COLOR_CONST.YELLOW_COUNT,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        IconButton(
          icon: Icon(
            Icons.sort,
            color: COLOR_CONST.DEFAULT,
          ),
          onPressed: () {
            BlocProvider.of<ShopBloc>(context)..add(DoFilterEvent());
          },
        )
      ],
    );
  }
}

var shopType = "";
var shopOrder = "";
