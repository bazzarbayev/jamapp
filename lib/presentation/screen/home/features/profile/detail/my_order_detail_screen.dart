import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/model/entity/history_order.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/my_orders_bloc.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOrderDetailScreen extends StatefulWidget {
  MyOrderDetailScreen(this.id);
  final int id;
  @override
  _MyOrderDetailScreenState createState() => _MyOrderDetailScreenState();
}

class _MyOrderDetailScreenState extends State<MyOrderDetailScreen> {
  MyOrderBloc bloc;
  UserRepository _repository;

  @override
  void initState() {
    Analytics().doEventCustom("profile_order_card");

    _repository = RepositoryProvider.of<UserRepository>(context);
    bloc = MyOrderBloc(_repository)..add(GetMyOrderDetailEvent(widget.id));
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
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(color: COLOR_CONST.DEFAULT),
              title: Text(
                "my_order_detail.title".tr().toUpperCase(),
                style: Theme.of(context).textTheme.headline6,
              ),
              backgroundColor: Colors.transparent,
            ),
            body: BlocBuilder<MyOrderBloc, MyOrderState>(
                cubit: bloc,
                builder: (context, state) {
                  if (state is FetchedOrderState) {
                    return Container(
                      margin: EdgeInsets.all(16),
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: [
                          Text(
                            "my_order_detail.order_n"
                                .tr(args: ["${state.order.orderNumber}"]),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Divider(
                            thickness: 1,
                            color: GREEN,
                          ),
                          Text(
                            _buildOrderStatus(state.order.status),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          // Text(
                          //   "my_order_detail.confirmed".tr(),
                          //   style: Theme.of(context).textTheme.headline3,
                          // ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            state.order.dateOrder,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "my_order_detail.you_ordered".tr(),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: state.order.catalogsCatalog.length,
                            itemBuilder: (context, index) {
                              return _buildOrderItem(
                                  state.order.catalogsCatalog[index]);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "my_order_detail.address".tr(),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            state.order.shipping,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _bottomWidget(state.order),
                          SizedBox(
                            height: 20,
                          ),
                          _buildLinkItem(
                              "my_order_detail.contact_with_us"
                                  .tr()
                                  .toUpperCase(),
                              instaIcon),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                })));
  }

  String _buildOrderStatus(String orderStatus) {
    if (orderStatus == "1") {
      return "В обработке";
    } else if (orderStatus == "3") {
      return "Отменен";
    } else if (orderStatus == "0") {
      return "Ожидание";
    } else if (orderStatus == "2") {
      return "Завершен";
    }
    return "";
  }

  final Widget instaIcon =
      SvgPicture.asset('assets/images/insta_icon.svg', semanticsLabel: '');

  Widget _buildLinkItem(String text, Widget icon) {
    return Container(
        height: 70,
        decoration: BoxDecoration(
            color: GREEN_DARKER,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Center(
          child: ListTile(
            onTap: () async {
              var url = 'https://www.instagram.com/jamesonkz';
              print(url);

              if (await canLaunch(url)) {
                await launch(url);
              } else {
                // throw 'Could not launch $url';
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

  Widget _bottomWidget(HistoryOrder order) {
    return Table(
      children: [
        _tableRow(order.price.toString()),
        _tableSpaceRow(),
        _tableDeliveryRow()
      ],
    );
  }

  TableRow _tableRow(String price) {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "my_order_detail.sum".tr().toUpperCase(),
          style: Theme.of(context).textTheme.headline3,
        )
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            price,
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(
            width: 10,
          ),
          jjActiveIcon
        ]),
      ]),
    ]);
  }

  TableRow _tableDeliveryRow() {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          deliveryIcon,
          SizedBox(
            width: 10,
          ),
          Text(
            "my_order_detail.delivery".tr(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
          "my_order_detail.free".tr(),
          style: Theme.of(context).textTheme.headline3,
        ),
      ]),
    ]);
  }

  TableRow _tableSpaceRow() {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 10,
        )
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 10,
        )
      ]),
    ]);
  }

  Widget _buildOrderItem(CatalogsCatalog ctl) {
    return GestureDetector(
      onTap: () {},
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
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20.0)),
                    image: DecorationImage(
                        image: NetworkImage(
                          ctl.catalogWithMainImage.mainImage.src,
                        ),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "X ${ctl.quantity} ",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  context.locale.toString() == "kk_KZ"
                      ? "${ctl.catalogWithMainImage.name.kz}"
                      : "${ctl.catalogWithMainImage.name.ru}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  ctl.catalogWithMainImage.priceInPoints,
                  style: TextStyle(
                      color: GREEN, fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                jjActiveIcon
              ]),
              SizedBox(
                width: 10,
              ),
            ],
          )),
    );
  }

  final Widget jjActiveIcon =
      SvgPicture.asset('assets/images/jj_active_icon.svg', semanticsLabel: '');

  Widget deliveryIcon = SvgPicture.asset(
    'assets/images/delivery.svg',
    semanticsLabel: '',
    color: COLOR_CONST.DEFAULT,
  );
}
