import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/counter_product.dart';
import 'package:jam_app/presentation/screen/home/features/shop/detail/product_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/product_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/widgets/basket_icon_detail.dart';
import 'package:jam_app/utils/helpers.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

String globalSize = "";
String globalColor = "";

class ProductDetailScreen extends StatefulWidget {
  final int id;
  ProductDetailScreen(this.id);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductItem item;

  CounterProductBloc _counterBloc;
  AuthenticationBloc _authBloc;

  var _current = 0;

  @override
  void initState() {
    Analytics().doEventCustom("shop_card");

    globalSize = "";
    _counterBloc = BlocProvider.of<CounterProductBloc>(context)
      ..add(GetCounterProductDataEvent());
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    BlocProvider.of<ProductBloc>(context)..add(GetProductDataEvent(widget.id));
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
              centerTitle: true,
              title: Text(
                "shop_details.card_product".tr().toUpperCase(),
                style: Theme.of(context).textTheme.headline6,
              ),
              backgroundColor: Colors.transparent,
              actions: [
                BasketProductIcon(),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            body: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
              if (state is FetchedProductState) {
                List<String> getImages =
                    state.response.images.map((e) => e.src).toSet().toList();

                return Container(
                  color: Colors.white,
                  child: ListView(children: [
                    Stack(
                      children: [
                        Container(
                          height: 230,
                          color: Colors.white,
                          child: _sliderWidget(getImages),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 230),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(48)),
                              color: GREEN_DARKER),
                          padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
                          child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              Text(
                                  context.locale.toString() == "kk_KZ"
                                      ? "${state.response.name.kz}"
                                      : "${state.response.name.ru}",
                                  style: Theme.of(context).textTheme.headline3),
                              SizedBox(
                                height: 12,
                              ),
                              bonusWidget(
                                  bonusFormatted(state.response.priceInPoints)),
                              SizedBox(
                                height: 16,
                              ),
                              _tableAttributes(state.response.attribute),
                              SizedBox(
                                height: 12,
                              ),
                              Divider(
                                color: GREEN,
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text("shop_details.card_information".tr(),
                                  style: Theme.of(context).textTheme.headline3),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                  context.locale.toString() == "kk_KZ"
                                      ? "${state.response.description.kz}"
                                      : "${state.response.description.ru}",
                                  style: Theme.of(context).textTheme.headline2),
                              SizedBox(
                                height: 32,
                              ),
                              JJGreenButton(
                                  text: "shop_details.card_add_basket".tr(),
                                  function: () =>
                                      addItemToBasket(state.response)),
                              SizedBox(
                                height: 500,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            })

            //dont touch
            ));
  }

  _sliderWidget(List<String> images) {
    return Stack(
      children: [
        CarouselSlider(
          items: _getImages(images),
          options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map((url) {
              int index = images.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _current == index ? GREEN : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  _getImages(List<String> images) {
    return images
        .map(
          (item) => Image.network(
            item,
            fit: BoxFit.contain,
            width: 1000.0,
          ),
        )
        .toList();
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

  final Widget jjActiveIcon =
      SvgPicture.asset('assets/images/jj_active_icon.svg', semanticsLabel: '');

  _tableAttributes(List<Attribute> list) {
    final rows = <TableRow>[];
    for (var rowData in list) {
      if (rowData.visible) {
        if (!rowData.variation) {
          rows.add(
            _productAttributeRow(rowData.name, rowData.options.first),
          );
          rows.add(_buildTableRowSpace());
        } else if (rowData.id == 29) {
          rows.add(_productColorOptionsRow(rowData.name, rowData.options));
        } else {
          rows.add(_productOptionsRow(rowData.name, rowData.options));
        }
      }
    }

    return Table(
      children: rows,
    );
  }

  TableRow _productAttributeRow(String key, String value) {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(key,
            style:
                TextStyle(color: COLOR_CONST.YELLOW_COUNT_LIGHT, fontSize: 12))
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(color: COLOR_CONST.DEFAULT, fontSize: 12))
      ]),
    ]);
  }

  TableRow _productColorOptionsRow(String key, List<String> value) {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(key,
            style:
                TextStyle(color: COLOR_CONST.YELLOW_COUNT_LIGHT, fontSize: 12))
      ]),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ColorOptionWidget(value)]),
    ]);
  }

  TableRow _productOptionsRow(String key, List<String> value) {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(key,
            style:
                TextStyle(color: COLOR_CONST.YELLOW_COUNT_LIGHT, fontSize: 12))
      ]),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SizeOptionWidget(value)]),
    ]);
  }

  void addItemToBasket(ProductItem item) {
    
    _counterBloc.add(IncrementProduct2ItemEvent(item, globalSize, globalColor));
  }

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

class SizeOptionWidget extends StatefulWidget {
  final List<String> options;
  String _size = "";
  SizeOptionWidget(this.options);
  @override
  _SizeOptionWidgetState createState() => _SizeOptionWidgetState();

  set size(String value) {
    _size = value;
  }

  get size => _size;
}

class _SizeOptionWidgetState extends State<SizeOptionWidget> {
  String _currentValue = "";

  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    list.clear();
    for (var item in widget.options) {
      list.add(_rowItem(item));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }

  Widget _rowItem(String size) {
    return Flexible(
      child: GestureDetector(
          onTap: () {
            setState(() {
              _currentValue = size;
              widget.size = size;
              globalSize = size;
            });
          },
          child: Container(
            width: 60,
            decoration: _currentValue == size
                ? BoxDecoration(
                    border: Border.all(color: GREEN, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)))
                : null,
            child: Center(
              child: Text(
                size,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          )),
    );
  }
}

///COLOR
///
///
class ColorOptionWidget extends StatefulWidget {
  final List<String> options;
  String _color = "";
  ColorOptionWidget(this.options);
  @override
  _ColorOptionWidgetState createState() => _ColorOptionWidgetState();

  set color(String value) {
    _color = value;
  }

  get color => _color;
}

class _ColorOptionWidgetState extends State<ColorOptionWidget> {
  String _currentValue = "";

  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    list.clear();
    for (var item in widget.options) {
      String color = item.replaceAll('#', '0xff');
      list.add(_rowItem(color));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }

  Widget _rowItem(String color) {
    var cc;
    try {
      cc = int.parse(color);
    } catch (e) {
      cc = 0xffFFFFFF;
    }
    return Flexible(
      child: GestureDetector(
          onTap: () {
            setState(() {
              _currentValue = color;
              widget.color = color;
              globalColor = color.replaceAll('0xff', '#');
            });
          },
          child: Container(
              decoration: _currentValue == color
                  ? BoxDecoration(
                      border: Border.all(color: GREEN, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    )
                  : null,
              child: Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.all(4),
                decoration:
                    BoxDecoration(color: Color(cc), shape: BoxShape.circle),
              ))),
    );
  }
}
