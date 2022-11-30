import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jam_app/app/analytics.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/presentation/custom_ui/jj_green_button.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/city_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/profile_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/widgets/jj_text.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/shop_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/basket_item.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';

//const
String cityGlobal = "";
String cityStatusGlobal = "";

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  ProfileBloc _profileBloc;
  AuthenticationBloc _authenticationBloc;
  CounterBloc _counterBloc;

  @override
  void initState() {
    Analytics().doEventCustom("checkout");

    _counterBloc = BlocProvider.of<CounterBloc>(context);

    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  final Widget basketIcon =
      SvgPicture.asset('assets/images/basket.svg', semanticsLabel: '');

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
            "check_out.title".tr().toUpperCase(),
            style: Theme.of(context).textTheme.headline6,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Badge(
                    badgeColor: COLOR_CONST.RED2,
                    badgeContent: BlocConsumer<CounterBloc, CounterState>(
                      listener: (context, state) {
                        if (state is FailureUnAuthBasketState) {
                          _authenticationBloc.add(ShowCustomAlert(
                              "check_out.sign_up_to_stash_bonus".tr(),
                              "",
                              "check_out.sign_up".tr(),
                              "sign_up"));
                        }
                        if (state is FailureUnLoyalBasketState) {
                          _authenticationBloc.add(ShowCustomAlert(
                              "check_out.error_loyalty".tr(), "", "ok", ""));
                        }
                      },
                      buildWhen: (previus, current) {
                        if (current is CleanBasketState) {
                          return false;
                        }
                        if (current is RefreshBasketState) {
                          return false;
                        }
                        if (current is FailureUnAuthBasketState) {
                          return false;
                        }
                        if (current is FailureUnLoyalBasketState) {
                          return false;
                        }
                        return true;
                      },
                      builder: (context, state) {
                        if (state is CounterState) {
                          return Text(
                            state.counter.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }
                        return Container();
                      },
                    ),
                    child: basketIcon),
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: BlocConsumer<CheckOutBloc, CheckOutState>(
          listener: (context, state) {
            if (state is FailureCheckOutState) {
              _authenticationBloc.add(ShowCustomAlert(
                  "check_out.error".tr(), state.error, "Ок", ""));
            }

            if (state is SuccessCheckOutState) {
              _profileBloc.add(CleanProfileBlocEvent());
              _profileBloc.add(GetProfileDataEvent());
              _counterBloc.add(GetCounterDataEvent());
              Navigator.pop(
                  context, {"result": "success_check_out", "id": state.id});
            }

            if (state is FailureCheckOutCityEmptyState) {
              final snackBar =
                  SnackBar(content: Text("check_out.choose_city".tr()));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          buildWhen: (previous, current) {
            if (current is FailureCheckOutState) {
              return false;
            }
            if (current is CleanCheckOutState) {
              return false;
            }
            if (current is FailureCheckOutCityEmptyState) {
              return false;
            }
            if (current is SuccessCheckOutState) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state is LoadingCheckOutState) {
              return Center(child: CircularProgressIndicator());
            }

            return EditProfileBody();
          },
        ),
      ),
    );
  }
}

final Widget successIcon =
    SvgPicture.asset('assets/images/success.svg', semanticsLabel: '');

class EditProfileBody extends StatefulWidget {
  @override
  _EditProfileBodyState createState() => _EditProfileBodyState();
}

enum Gender { MALE, FEMALE }

class _EditProfileBodyState extends State<EditProfileBody> {
  var name = TextEditingController();
  var surname = TextEditingController();
  var street = TextEditingController();
  var dom = TextEditingController();
  var kv = TextEditingController();
  var blok = TextEditingController();
  var podezd = TextEditingController();
  var comments = TextEditingController();
  var email = TextEditingController();
  var instagram = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  var _city = "";

  CheckOutBloc _checkOutBloc;

  @override
  void initState() {
    _checkOutBloc = BlocProvider.of<CheckOutBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    surname.dispose();
    street.dispose();
    dom.dispose();
    kv.dispose();
    blok.dispose();
    podezd.dispose();
    comments.dispose();
    email.dispose();
    instagram.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is FetchedProfileState) {
          // selectGender(state.name.sex);

          _city = state.name.city;

          name.text = state.name.name;
          surname.text = state.name.surname;
          street.text = state.name.street;
          dom.text = state.name.house;
          kv.text = state.name.apartment;
          blok.text = state.name.block;
          podezd.text = state.name.entrance;
          comments.text = state.name.comment;
          email.text = state.name.email;
          instagram.text = state.name.instagram;

          return ListView(
            children: [
              OrderDetailsWidget(),
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(48)),
                    color: GREEN_DARKER),
                padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      Text("check_out.contact_data".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: COLOR_CONST.DEFAULT)),
                      SizedBox(
                        height: 24,
                      ),
                      JJTextValidateWidget(
                          controller: name, text: "check_out.name".tr()),
                      SizedBox(
                        height: 12,
                      ),
                      JJTextValidateWidget(
                          controller: surname, text: "check_out.surname".tr()),
                      SizedBox(
                        height: 12,
                      ),
                      Text("check_out.city".tr() + "*",
                          style: TextStyle(fontSize: 12, color: GREEN)),
                      SizedBox(
                        height: 10,
                      ),
                      ProfileCityWidget(state.name.city),
                      SizedBox(
                        height: 12,
                      ),
                      JJTextValidateWidget(
                          controller: street, text: "check_out.street".tr()),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: JJTextValidateWidget(
                                controller: dom, text: "check_out.house".tr()),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: JJTextLabelWidget(
                                controller: kv, text: "check_out.kv".tr()),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: JJTextLabelWidget(
                                controller: blok, text: "check_out.block".tr()),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: JJTextLabelWidget(
                                controller: podezd,
                                text: "check_out.podezd".tr()),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      JJTextLabelWidget(
                          controller: comments,
                          text: "check_out.comments".tr()),
                      SizedBox(
                        height: 12,
                      ),
                      Text("check_out.nomer_phone".tr(),
                          style: TextStyle(fontSize: 12, color: GREEN)),
                      SizedBox(
                        height: 4,
                      ),
                      Text(maskFormatter.maskText(state.name.phone),
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(
                        height: 12,
                      ),
                      JJTextEmailValidateWidget(
                          controller: email, text: "Email*"),
                      SizedBox(
                        height: 12,
                      ),
                      JJTextValidateWidget(
                          controller: instagram, text: "Instagram*".tr()),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: JJGreenButton(
                            text: "check_out.finish_check_out".tr(),
                            function: () {
                              if (_formKey.currentState.validate()) {
                                var user = User();
                                user.phone = state.name.phone;
                                user.name = name.text;
                                user.surname = surname.text;
                                user.street = street.text;
                                user.house = dom.text;
                                user.email = email.text;
                                user.instagram = instagram.text;
                                user.apartment = kv.text;
                                user.block = blok.text;
                                user.entrance = podezd.text;
                                user.comment = comments.text;
                                user.city = _city;

                                _checkOutBloc.add(CheckOutShopDataEvent(
                                  user: user,
                                  phone: state.name.phone,
                                ));
                              }
                            }),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class ProfileCityWidget extends StatefulWidget {
  final String city;
  ProfileCityWidget(this.city);

  @override
  _ProfileCityWidgetState createState() => _ProfileCityWidgetState();
}

class _ProfileCityWidgetState extends State<ProfileCityWidget> {
  var _city = "";
  var _cityStatus = "";

  ProfileBloc _bloc;
  CityBloc _cityBloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ProfileBloc>(context);
    BlocProvider.of<CityBloc>(context)..add(GetCityDataEvent());
    _city = widget.city;
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _cityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 55.0,
            decoration: BoxDecoration(
              border: Border.all(color: COLOR_CONST.DEFAULT, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      _city.isEmpty ? "check_out.city".tr() : _city,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 0.8,
                  color: COLOR_CONST.DEFAULT,
                ),
                Container(
                  margin: EdgeInsets.only(right: 6),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: COLOR_CONST.DEFAULT,
                    ),
                    onPressed: () {
                      _showCityPicker(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _picker(List<CityResponse> list) {
    return CupertinoPicker(
      looping: false,
      magnification: 1.3,
      backgroundColor: COLOR_CONST.DEFAULT_2,
      children: <Widget>[
        for (int i = 0; i < list.length; i++)
          if (list[i].status == "yes" || list[i].status == "nothandle")
            Text(
              list[i].name,
              style: TextStyle(color: Colors.black, fontSize: 20),
            )
      ],
      itemExtent: 44, //height of each item
      onSelectedItemChanged: (int index) {
        setState(() {
          _city = list[index].name;
          _cityStatus = list[index].status;
        });
        _bloc.add(SetCityProfileEvent(_city, _cityStatus));
      },
    );
  }

  Future<void> bottomsSheet(BuildContext context, Widget child,
      {double height}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Container(
            height: height ?? MediaQuery.of(context).size.height / 3,
            child: BlocBuilder<CityBloc, CityState>(builder: (context, state) {
              if (state is FetchedCityState) {
                return _picker(state.response);
              }
              return Container();
            })));
  }

  void _showCityPicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: COLOR_CONST.YELLOW_LIGHT,
              child: Column(
                children: [
                  Container(
                      height: 400,
                      child: BlocBuilder<CityBloc, CityState>(
                          builder: (context, state) {
                        if (state is FetchedCityState) {
                          return CityPicker(
                            list: state.response,
                          );
                          // return _picker(state.response);
                        }
                        return Container();
                      })),
                  CupertinoButton(
                      child: Text('OK'),
                      onPressed: () {
                        setState(() {
                          _city = cityGlobal;
                          _cityStatus = cityStatusGlobal;
                        });
                        _bloc.add(SetCityProfileEvent(_city, _cityStatus));
                        Navigator.pop(context);
                      })
                ],
              ),
            ));
  }
}

class CityPicker extends StatefulWidget {
  List<CityResponse> list;

  CityPicker({Key key, @required this.list}) : super(key: key);

  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  @override
  void initState() {
    cityGlobal = widget.list[0].name;
    cityStatusGlobal = widget.list[0].status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      looping: false,
      magnification: 1.3,
      backgroundColor: COLOR_CONST.DEFAULT_2,
      children: <Widget>[
        for (int i = 0; i < widget.list.length; i++)
          Text(
            widget.list[i].name,
            style: TextStyle(color: Colors.black, fontSize: 20),
          )
      ],
      itemExtent: 44, //height of each item
      onSelectedItemChanged: (int index) {
        cityGlobal = widget.list[index].name;
        cityStatusGlobal = widget.list[index].status;
      },
    );
  }
}

class OrderDetailsWidget extends StatefulWidget {
  @override
  _OrderDetailsWidgetState createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        if (state is FetchedBasketState) {
          return Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("check_out.your_order".tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: COLOR_CONST.DEFAULT)),
                SizedBox(
                  height: 8,
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
                  height: 15,
                ),
                _bottomWidget(state.money.toString())
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _bottomWidget(String money) {
    return Table(
      children: [_tableRow(money), _tableSpaceRow(), _tableDeliveryRow()],
    );
  }

  TableRow _tableRow(String price) {
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("check_out.sum".tr().toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: COLOR_CONST.DEFAULT))
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(price,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: COLOR_CONST.DEFAULT)),
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
            "check_out.delivery".tr(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
          "check_out.free".tr(),
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

  Widget _buildBasketItem(BasketItem ctl) {
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
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20.0)),
                    image: DecorationImage(
                        image: NetworkImage(
                          ctl.item.srcImage,
                        ),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "X ${ctl.count}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  ctl.item.priceInPoints,
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
