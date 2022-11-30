import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

class InfoDialog extends StatefulWidget {
  @override
  _InfoDialogState createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: COLOR_CONST.DEFAULT,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          margin: EdgeInsets.only(top: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Text(
                "info_dialog.how".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'roboto'),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: PageView(
                  controller: _controller,
                  children: [
                    page1Widget(),
                    page2Widget(),
                    page3Widget(),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              JJGreenButton(
                text: "ok",
                function: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
        Positioned(
          child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop()),
          right: 0,
          top: 20,
          height: 50,
        ),
      ],
    );
  }

  Widget page1Widget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        scanIcon,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: GREEN,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 1),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 1),
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
        Text(
          "info_dialog.step_1".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: GREEN),
        ),
        Text(
          "info_dialog.step_1_info".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget page2Widget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        bonusIcon,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 1),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: GREEN,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 1),
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
        Text(
          "info_dialog.step_2".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: GREEN),
        ),
        Text(
          "info_dialog.step_2_info".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget page3Widget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        productIcon,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 1),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 1),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: GREEN,
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
        Text(
          "info_dialog.step_3".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: GREEN),
        ),
        Text(
          "info_dialog.step_3_info".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  final Widget bonusIcon =
      SvgPicture.asset('assets/images/bonus_info.svg', semanticsLabel: '');

  final Widget productIcon =
      SvgPicture.asset('assets/images/product_info.svg', semanticsLabel: '');

  final Widget scanIcon =
      SvgPicture.asset('assets/images/scan_info.svg', semanticsLabel: '');
}
