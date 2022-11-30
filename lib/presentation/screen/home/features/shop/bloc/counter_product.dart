import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/db/database_helper.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/basket_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/product_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/shop_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/shop_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CounterProductEvent extends Equatable {
  const CounterProductEvent();

  @override
  List<Object> get props => [];
}

class IncrementEvent extends CounterProductEvent {
  final ShopItem item;
  IncrementEvent(this.item);
}

class IncrementProduct2ItemEvent extends CounterProductEvent {
  final ProductItem item;
  final String size;
  final String color;
  IncrementProduct2ItemEvent(this.item, this.size, this.color);
}

class BasketAddEvent extends CounterProductEvent {
  final BasketItem item;
  BasketAddEvent(this.item);
}

class BasketRemoveEvent extends CounterProductEvent {
  final BasketItem item;
  BasketRemoveEvent(this.item);
}

class GetCounterProductDataEvent extends CounterProductEvent {}

class CounterProductState extends Equatable {
  final int counter;
  final int money;
  const CounterProductState({this.counter, this.money});

  @override
  List<Object> get props => [counter];
}

class RefreshBasket2State extends CounterProductState {}

class CleanBasket2State extends CounterProductState {}

class FailureUnAuthBasket2State extends CounterProductState {}

class FailureUnLoyalBasket2State extends CounterProductState {}

class FailureBonusLackBasket2State extends CounterProductState {}

class SuccessBonusLackBasket2State extends CounterProductState {}

class CounterProductBloc
    extends Bloc<CounterProductEvent, CounterProductState> {
  CounterProductBloc() : super(CounterProductState(counter: 0));
  var db = DatabaseHelper();

  @override
  Stream<CounterProductState> mapEventToState(
      CounterProductEvent event) async* {
    var prefs = await SharedPreferences.getInstance();

    if (event is GetCounterProductDataEvent) {
      var size = await db.getSizeBasket();
      yield CounterProductState(counter: size);
    }

    if (event is IncrementProduct2ItemEvent) {
      var isAuth = prefs.getString("isRegistered");
      var isLoyal = prefs.getString("isLoyal");

      if (isAuth == null) {
        yield CleanBasket2State();
        yield FailureUnAuthBasket2State();
      } else if (isLoyal != null) {
        yield CleanBasket2State();
        yield FailureUnLoyalBasket2State();
      } else {

        if (int.parse(event.item.priceInPoints) <= int.parse(bonus) &&
            int.parse(bonus) > 0) {
          var leftBonus =
              int.parse(bonus) - int.parse(event.item.priceInPoints);
          bonus = leftBonus.toString();

          await db.addShopItem(ShopItem(
              id: event.item.id,
              srcImage: event.item.images.first.src, //emptyy
              price: event.item.price,
              options: [event.size, event.color],
              titleRu: event.item.name.ru,
              titleKz: event.item.name.kz,
              priceInPoints: event.item.priceInPoints,
              uUID: event.item.uUID));

          var size = await db.getSizeBasket();

          yield SuccessBonusLackBasket2State();
          yield CounterProductState(counter: size);
        } else {
          yield CleanBasket2State();
          yield FailureBonusLackBasket2State();
        }
      }
    }

    if (event is BasketAddEvent) {
      await db.addShopItem(event.item.item);
      yield RefreshBasket2State();
      var size = await db.getSizeBasket();
      yield CounterProductState(counter: size);
    }

    if (event is GetCounterProductDataEvent) {}
  }
}
