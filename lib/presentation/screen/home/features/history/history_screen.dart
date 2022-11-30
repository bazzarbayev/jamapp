import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jam_app/model/entity/history.dart';
import 'package:jam_app/presentation/screen/home/features/history/history_bloc.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:jam_app/widgets/info_dialog.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _currentLang = "";

  void _getLocale() {
    if (context.locale == Locale("kk", "KZ")) {
      _currentLang = "kk";
    } else {
      _currentLang = "ru";
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
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: COLOR_CONST.DEFAULT),
              title: Text(
                "history.my_history".tr().toUpperCase(),
                style: Theme.of(context).textTheme.headline6,
              ),
              backgroundColor: Colors.transparent,
            ),
            body: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
              if (state is LoadingHistoryState) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is FetchedHistoryState) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    GroupedListView<History, DateTime>(
                        shrinkWrap: true,
                        elements: state.list,
                        groupBy: (history) {
                          return history.date;
                        },
                        groupSeparatorBuilder: (DateTime date) {
                          String dateTime =
                              DateFormat("dd MMMM, yyyy", _currentLang)
                                  .format(date);

                          return Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(dateTime,
                                  style: TextStyle(
                                      color: COLOR_CONST.DEFAULT,
                                      fontSize: 13)));
                        },
                        order: GroupedListOrder.DESC,
                        itemBuilder: (context, History item) {
                          return _buildHistoryItem(item);
                        }),
                    SizedBox(
                      height: 100,
                    )
                  ],
                );
              }
              if (state is EmptyHistoryState) {
                return Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "history.no_history".tr(),
                          style: TextStyle(
                              fontSize: 18,
                              color: COLOR_CONST.DEFAULT,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          "history.read_down".tr(),
                          style: TextStyle(
                              fontSize: 16,
                              color: COLOR_CONST.DEFAULT,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          margin: EdgeInsets.all(32),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return InfoDialog();
                                  });
                            },
                            child: Text(
                              "history.how_to_stash_bonus".tr(),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  color: COLOR_CONST.DEFAULT,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ]),
                );
              }
              return Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "history.no_history".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: COLOR_CONST.DEFAULT,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "history.read_down".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: COLOR_CONST.DEFAULT,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        margin: EdgeInsets.all(32),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return InfoDialog();
                                });
                          },
                          child: Text(
                            "history.how_to_stash_bonus".tr(),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                                color: COLOR_CONST.DEFAULT,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ]),
              );
            })));
  }

  Widget _buildHistoryItem(History order) {
    return Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: GREEN_DARKER,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: ListTile(
          trailing: _getStatus(order),
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Text(_currentLang == "kk" ? order.nameKz : order.name,
                style: TextStyle(color: COLOR_CONST.DEFAULT)),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_currentLang == "kk" ? order.infoKz : order.info,
                  style: TextStyle(
                      color: COLOR_CONST.DEFAULT,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 4),
              Text(order.time,
                  style: TextStyle(
                      color: COLOR_CONST.YELLOW_COUNT,
                      fontSize: 10,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ));
  }

  Widget _getStatus(History order) {
    print("${order.name} ${order.status}");

    if (order.status == "loading") {
      return orderIcon;
    } else if (order.status == "cancel") {
      return closeIcon;
    } else if (order.status == "sending") {
      return deliveryIcon;
    } else if (order.status == "complete") {
      return deliveryDoneIcon;
    } else if (order.status == "delivered") {
      return deliveryDoneIcon;
    } else if (order.status == "bonus") {
      return bonusWidget(order.bonusInfo);
    } else {
      return Container();
    }
  }

  Widget bonusWidget(String bonus) {
    return Container(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(
          bonus,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          width: 10,
        ),
        jjActiveIcon
      ]),
    );
  }

  Widget orderIcon = SvgPicture.asset(
    'assets/images/history_icon.svg',
    semanticsLabel: '',
    color: COLOR_CONST.DEFAULT,
  );

  Widget closeIcon = SvgPicture.asset(
    'assets/images/close.svg',
    semanticsLabel: '',
    color: COLOR_CONST.DEFAULT,
  );

  Widget deliveryIcon = SvgPicture.asset(
    'assets/images/delivery.svg',
    semanticsLabel: '',
    color: COLOR_CONST.DEFAULT,
  );

  Widget deliveryDoneIcon = SvgPicture.asset(
    'assets/images/delivery_done.svg',
    semanticsLabel: '',
  );

  final Widget jjActiveIcon =
      SvgPicture.asset('assets/images/jj_active_icon.svg', semanticsLabel: '');
}
