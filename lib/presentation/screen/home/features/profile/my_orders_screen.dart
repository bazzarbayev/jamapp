import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/model/entity/history_order.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/my_orders_bloc.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  MyOrderBloc bloc;

  UserRepository _repository;

  @override
  void initState() {
    Analytics().doEventCustom("profile_order_list");

    _repository = RepositoryProvider.of<UserRepository>(context);
    bloc = MyOrderBloc(_repository)..add(GetMyOrders());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
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
                "my_orders.title".tr().toUpperCase(),
                style: Theme.of(context).textTheme.headline6,
              ),
              backgroundColor: Colors.transparent,
            ),
            body: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: [
                BlocBuilder<MyOrderBloc, MyOrderState>(
                  cubit: bloc,
                  builder: (context, state) {
                    if (state is FetchedHistoryOrderState) {
                      return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: state.order.length,
                        itemBuilder: (context, index) {
                          return _buildOrderItem(state.order[index]);
                        },
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(
                  height: 100,
                )
              ],
            )));
  }

  Widget _getStatus(HistoryOrder order) {
    switch (order.status.toString()) {
      case "0":
        return orderIcon;
      case "3":
        return closeIcon;
      case "1":
        return deliveryIcon;
      case "2":
        return deliveryDoneIcon;
    }
    return Container();
  }

  Widget _buildOrderItem(HistoryOrder order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/my_orders/detail",
            arguments: {"id": order.id});
      },
      child: Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: GREEN_DARKER,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "my_orders.order_n".tr(args: [order.orderNumber]),
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                "${order.date}",
                style: Theme.of(context).textTheme.headline2,
              ),
              _getStatus(order)
            ],
          )),
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
}
