import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/detail/my_order_detail_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/basket/basket_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/shop_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/check_out/check_out_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/check_out/check_out_success.dart';
import 'package:jam_app/presentation/screen/home/features/shop/detail/product_detail_screen.dart';
import 'package:jam_app/presentation/screen/home/features/shop/shop_screen.dart';

class ShopRoutes extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ShopRoutes({@required this.navigatorKey});

  @override
  _ShopRoutesState createState() => _ShopRoutesState();
}

class _ShopRoutesState extends State<ShopRoutes> {
  @override
  void initState() {
    BlocProvider.of<ShopBloc>(context).add(GetShopDataEvent());
    BlocProvider.of<CounterBloc>(context).add(GetCounterDataEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: (settings) {
          Widget page;
          if (settings.name == '/') page = ShopScreen();
          if (settings.name == '/basket') page = BasketScreen();
          if (settings.name == '/check_out_success') {
            Map object = settings.arguments;
            page = CheckOutSuccessScreen(object["id"]);
          }

          if (settings.name == '/shop/detail') {
            Map object = settings.arguments;
            page = ProductDetailScreen(object["id"]);
          }
          if (settings.name == '/my_orders/detail') {
            Map object = settings.arguments;
            page = MyOrderDetailScreen(object["id"]);
          }
          if (settings.name == "/check_out") page = CheckOutScreen();
          return MaterialPageRoute(builder: (context) => page);
        },
      ),
    );
  }
}
