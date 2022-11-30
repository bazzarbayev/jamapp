import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/presentation/screen/home/features/shop/basket/basket_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/counter_product.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

class BasketProductIcon extends StatefulWidget {
  @override
  _BasketProductIconState createState() => _BasketProductIconState();
}

class _BasketProductIconState extends State<BasketProductIcon> {
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BasketScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Badge(
            badgeColor: COLOR_CONST.RED2,
            badgeContent: BlocConsumer<CounterProductBloc, CounterProductState>(
              listener: (context, state) {
                if (state is FailureUnAuthBasket2State) {
                  _authenticationBloc.add(ShowCustomAlert(
                      'check_out.sign_up_to_stash_bonus'.tr(),
                      "",
                      'check_out.sign_up'.tr(),
                      "sign_up"));
                }
                if (state is FailureUnLoyalBasket2State) {
                  _authenticationBloc.add(ShowCustomAlert(
                      'check_out.error_loyalty'.tr(), "", "ok", ""));
                }
                if (state is FailureBonusLackBasket2State) {
                  _authenticationBloc.add(ShowCustomAlert('basket.error'.tr(),
                      'basket.not_much_bonuses'.tr(), "Ок", ""));
                }
                if (state is SuccessBonusLackBasket2State) {
                  _authenticationBloc.add(ShowCustomAlert('Успешно!',
                      'Товар успешно добавлен в корзину!', "Ок", ""));
                }
              },
              buildWhen: (previus, current) {
                if (current is CleanBasket2State) {
                  return false;
                }
                if (current is RefreshBasket2State) {
                  return false;
                }
                if (current is FailureUnAuthBasket2State) {
                  return false;
                }
                if (current is FailureUnLoyalBasket2State) {
                  return false;
                }
                if (current is FailureBonusLackBasket2State) {
                  return false;
                }
                if (current is SuccessBonusLackBasket2State) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is CounterProductState) {
                  return Container(
                    margin: EdgeInsets.all(2),
                    child: Text(
                      state.counter.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  );
                }
                return Container();
              },
            ),
            child: basketIcon),
      ),
    );
  }

  final Widget basketIcon =
      SvgPicture.asset('assets/images/basket.svg', semanticsLabel: '');
}
