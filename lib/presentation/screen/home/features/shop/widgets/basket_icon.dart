import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jam_app/app/auth_bloc/authentication_bloc.dart';
import 'package:jam_app/app/auth_bloc/authentication_event.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/shop_bloc.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:easy_localization/easy_localization.dart';

class BasketIcon extends StatefulWidget {
  @override
  _BasketIconState createState() => _BasketIconState();
}

class _BasketIconState extends State<BasketIcon> {
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    BlocProvider.of<CounterBloc>(context)..add(GetCounterDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/basket");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Badge(
            badgeColor: COLOR_CONST.RED2,
            badgeContent: BlocConsumer<CounterBloc, CounterState>(
              listener: (context, state) {
                if (state is FailureUnAuthBasketState) {
                  _authenticationBloc.add(ShowCustomAlert(
                      'check_out.sign_up_to_stash_bonus'.tr(),
                      "",
                      'check_out.sign_up'.tr(),
                      "sign_up"));
                }
                if (state is FailureUnLoyalBasketState) {
                  _authenticationBloc.add(ShowCustomAlert(
                      'check_out.error_loyalty'.tr(), "", "ok", ""));
                }
                if (state is FailureBonusLackBasketState) {
                  _authenticationBloc.add(ShowCustomAlert('basket.error'.tr(),
                      'basket.not_much_bonuses'.tr(), "Ок", ""));
                }
                if (state is SuccessBonusLackBasketState) {
                  _authenticationBloc.add(ShowCustomAlert('Успешно!',
                      'Товар успешно добавлен в корзину!', "Ок", ""));
                }
              },
              buildWhen: (previus, current) {
                if (current is CleanBasketState) {
                  return false;
                }
                if (current is RefreshBasketState) {
                  return false;
                }
                if (current is FailureBonusLackBasketState) {
                  return false;
                }
                if (current is SuccessBonusLackBasketState) {
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
