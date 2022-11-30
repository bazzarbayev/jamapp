import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:jam_app/model/entity/sales_department.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/sales_departments_bloc.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

enum Category { BARS, PARTNERS, STORES }

class _MapScreenState extends State<MapScreen> {
  UserRepository _repository;
  SalesDepartmentsBloc bloc;

  final List<MapObject> mapObjects = [];
  final MapObjectId mapObjectCollectionId =
      const MapObjectId('map_object_collection');
  Point _point;
  YandexMapController _controller;

  Category _character;
  bool status = false;

  bool alaSelected = true;
  bool astSelected = false;

  bool visible = false;

  String tappedLocationName = "";
  String tappedLocationAddress = "";

  static const Point _pointAlmaty =
      Point(latitude: 43.252747, longitude: 76.945573);

  static const Point _pointNursultan =
      Point(latitude: 51.099907, longitude: 71.426189);

  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 1.0);

  @override
  void initState() {
    _repository = RepositoryProvider.of<UserRepository>(context);
    bloc = SalesDepartmentsBloc(_repository, onCalledFromOutside)
      ..add(GetSalesDepartments());
    super.initState();
  }

  void mapCreated(YandexMapController controller) {
    // if (_point == null) {
    //   Toast.warning(context, "Не можем показать на карте :(", duration: 3);
    //   return;
    // }

    print("HELLO");
  }

  void onCalledFromOutside(SalesDepartment salesDepartment) {
    setState(() {
      visible = true;
      tappedLocationName = salesDepartment.name;
      tappedLocationAddress = salesDepartment.contact;
    });
  }

  void changeCameraPositionToPoint() {
    _controller.moveCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: _point, zoom: 16)),
      animation: animation,
    );
  }

  Color _colorAlmaty = Color.fromRGBO(243, 227, 180, 1);
  Color _textColorAlmaty = Color.fromRGBO(0, 50, 32, 1);
  Color _colorNursultan = Color.fromRGBO(0, 0, 0, 0);
  Color _textColorNursultan = Color.fromRGBO(243, 227, 180, 1);
  bool isClicked = false;

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
              "home.where_to_buy_jameson".tr().toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isClicked = true;
                          alaSelected = true;
                          astSelected = false;
                          _colorAlmaty = Color.fromRGBO(243, 227, 180, 1);
                          _textColorAlmaty = Color.fromRGBO(0, 50, 32, 1);
                          _colorNursultan = Color.fromARGB(0, 0, 0, 0);
                          _textColorNursultan =
                              Color.fromRGBO(243, 227, 180, 1);
                        });

                        await _controller.moveCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: _pointAlmaty, zoom: 11)),
                            animation: animation);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 64, right: 24),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Алматы",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: _textColorAlmaty),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: COLOR_CONST.DEFAULT,
                            ),
                            color: _colorAlmaty,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isClicked = true;
                          alaSelected = false;
                          astSelected = true;
                          _colorNursultan = Color.fromRGBO(243, 227, 180, 1);
                          _textColorNursultan = Color.fromRGBO(0, 50, 32, 1);
                          _colorAlmaty = Color.fromRGBO(0, 0, 0, 0);
                          _textColorAlmaty = Color.fromRGBO(243, 227, 180, 1);
                        });
                        await _controller.moveCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: _pointNursultan, zoom: 11)),
                            animation: animation);
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Нур-Султан",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: _textColorNursultan),
                        ),
                        decoration: BoxDecoration(
                            color: _colorNursultan,
                            border: Border.all(
                              width: 2,
                              color: COLOR_CONST.DEFAULT,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile<Category>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          activeColor: COLOR_CONST.DEFAULT,
                          title: Text(
                            "map.bars".tr(),
                            style: TextStyle(
                                color: COLOR_CONST.DEFAULT, fontSize: 12),
                          ),
                          value: Category.BARS,
                          groupValue: _character,
                          onChanged: (Category value) {
                            bloc = SalesDepartmentsBloc(
                                _repository, onCalledFromOutside)
                              ..add(GetBarSalesDepartments());

                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile<Category>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          activeColor: COLOR_CONST.DEFAULT,
                          title: Text(
                            "map.partners".tr(),
                            style: TextStyle(
                                color: COLOR_CONST.DEFAULT, fontSize: 12),
                          ),
                          value: Category.PARTNERS,
                          groupValue: _character,
                          onChanged: (Category value) {
                            bloc = SalesDepartmentsBloc(
                                _repository, onCalledFromOutside)
                              ..add(GetPartnerSalesDepartments());

                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile<Category>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          activeColor: COLOR_CONST.DEFAULT,
                          title: Text(
                            "map.stores".tr(),
                            style: TextStyle(
                                color: COLOR_CONST.DEFAULT, fontSize: 12),
                          ),
                          value: Category.STORES,
                          groupValue: _character,
                          onChanged: (Category value) {
                            bloc = SalesDepartmentsBloc(
                                _repository, onCalledFromOutside)
                              ..add(GetStoreSalesDepartments());

                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterSwitch(
                      width: 55.0,
                      height: 30.0,
                      toggleSize: 20.0,
                      value: status,
                      borderRadius: 30.0,
                      padding: 4.0,
                      toggleColor: Colors.transparent,
                      switchBorder: Border.all(
                        color: COLOR_CONST.DEFAULT,
                        width: 2.0,
                      ),
                      toggleBorder: Border.all(
                        color: COLOR_CONST.DEFAULT,
                        width: 2.0,
                      ),
                      activeColor: Color.fromRGBO(108, 19, 39, 1),
                      inactiveColor: Colors.transparent,
                      onToggle: (val) {
                        setState(() {
                          status = val;
                          if (val == true) {
                            bloc = SalesDepartmentsBloc(
                                _repository, onCalledFromOutside)
                              ..add(GetPromotionedSalesDepartments());
                          } else {
                            if (_character == Category.BARS) {
                              bloc = SalesDepartmentsBloc(
                                  _repository, onCalledFromOutside)
                                ..add(GetBarSalesDepartments());
                            } else if (_character == Category.PARTNERS) {
                              bloc = SalesDepartmentsBloc(
                                  _repository, onCalledFromOutside)
                                ..add(GetPartnerSalesDepartments());
                            } else if (_character == Category.STORES) {
                              bloc = SalesDepartmentsBloc(
                                  _repository, onCalledFromOutside)
                                ..add(GetStoreSalesDepartments());
                            } else {
                              bloc = SalesDepartmentsBloc(
                                  _repository, onCalledFromOutside)
                                ..add(GetSalesDepartments());
                            }
                          }
                        });
                      },
                    ),
                    SizedBox(width: 12),
                    Text(
                      "map.stocks".tr(),
                      style:
                          TextStyle(color: COLOR_CONST.DEFAULT, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(height: 12),
                BlocBuilder<SalesDepartmentsBloc, SalesDepartmentsState>(
                  cubit: bloc,
                  builder: (context, state) {
                    if (state is FetchedMySalesDepartmentsState) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 400,
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: YandexMap(
                                      onMapCreated: (YandexMapController
                                          yandexMapController) async {
                                        _controller = yandexMapController;
                                        yandexMapController.moveCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: alaSelected
                                                      ? _pointAlmaty
                                                      : _pointNursultan,
                                                  zoom: 11)),
                                          animation: animation,
                                        );
                                      },
                                      mapObjects: state.mapObjects,
                                    ),
                                  ),
                                  Visibility(
                                    visible: visible,
                                    child: Positioned(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 20, top: 20, right: 20),
                                        child: Wrap(
                                          children: [
                                            IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  SizedBox(width: 12),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            left: 10,
                                                            bottom: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            tappedLocationName),
                                                        Text(
                                                            tappedLocationAddress),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Wrap(
                                                    children: [
                                                      IconButton(
                                                        alignment:
                                                            Alignment.topRight,
                                                        icon: const Icon(
                                                            Icons.close,
                                                            size: 18.0),
                                                        onPressed: () {
                                                          setState(() {
                                                            visible = !visible;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                243, 227, 180, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if (state is FailureSalesDepartmentsState) {
                      return Text(state.error,
                          style: TextStyle(color: Colors.white));
                    }
                    return Container();
                  },
                ),
              ],
            ),
          )),
    );
  }
}
