import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/shop_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/shop_screen.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterBox extends StatefulWidget {
  final VoidCallback callback;
  final String currentFilter;

  const FilterBox({Key key, this.callback, this.currentFilter = ""})
      : super(key: key);

  @override
  _FilterBoxState createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  var _current = "";

  @override
  void initState() {
    _current = widget.currentFilter;
    super.initState();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "filter_dialog.sorting".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: GREEN,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _current = "asc";
                  });

                  shopOrder = _current;
                  var filter =
                      GetShopDataFilterEvent(order: _current, type: shopType);
                  BlocProvider.of<ShopBloc>(context)..add(filter);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "filter_dialog.asc".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _current == "asc" ? GREEN : COLOR_CONST.TIPA_GREY,
                    ),
                  ),
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _current = "desc";
                  });

                  shopOrder = _current;
                  var filter =
                      GetShopDataFilterEvent(order: _current, type: shopType);
                  BlocProvider.of<ShopBloc>(context)..add(filter);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "filter_dialog.desc".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _current == "desc" ? GREEN : COLOR_CONST.TIPA_GREY,
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: JJGreenButton(
                    text: "filter_dialog.reset".tr(),
                    function: () {
                      setState(() {
                        _current = "";
                        shopOrder = "";
                      });
                      var filter = GetShopDataFilterEvent(
                          order: _current, type: shopType);
                      BlocProvider.of<ShopBloc>(context)..add(filter);
                      Navigator.of(context).pop();
                    }),
              )
            ],
          ),
        ),
        Positioned(
          child: IconButton(
              iconSize: 32,
              icon: Icon(
                Icons.close,
                color: GREEN,
              ),
              onPressed: () {
                // shopOrder = _current;
                // var filter =
                //     GetShopDataFilterEvent(order: _current, type: shopType);
                // BlocProvider.of<ShopBloc>(context)..add(filter);
                Navigator.of(context).pop();
              }),
          right: 0,
          top: 25,
          height: 50,
        ),
      ],
    );
  }
}
