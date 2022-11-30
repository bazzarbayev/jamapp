import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/presentation/screen/home/features/profile/detail/my_order_detail_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/widgets/basket_icon.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckOutSuccessScreen extends StatefulWidget {
  final String id;
  CheckOutSuccessScreen(this.id);
  @override
  _CheckOutSuccessScreenState createState() => _CheckOutSuccessScreenState();
}

class _CheckOutSuccessScreenState extends State<CheckOutSuccessScreen> {
  @override
  void initState() {
    Analytics().doEventCustom("checkout_success_screen");
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
              "check_out.title".tr().toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Colors.transparent,
            actions: [
              BasketIcon(),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: Container(
            margin: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                successIcon,
                SizedBox(
                  height: 24,
                ),
                Text(
                  "check_out.success".tr().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: COLOR_CONST.DEFAULT,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: JJGreenButton(
                      text: "check_out.watch_status".tr(),
                      function: () {
                        // Navigator.popAndPushNamed(context, "/my_orders/detail",
                        //     arguments: {"id": int.parse(widget.id)});

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyOrderDetailScreen(int.parse(widget.id))));
                        // Navigator.pop(context, "success_check_out");
                        // BlocProvider.of<UserBloc>(context)
                        //   ..add(GoScanToHistoryEvent());
                      }),
                )
              ],
            ),
          )),
    );
  }

  final Widget successIcon =
      SvgPicture.asset('assets/images/success.svg', semanticsLabel: '');
}
