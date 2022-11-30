import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/db/database_helper.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/model/repo/shop_repository.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/basket_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/product_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/shop_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/shop_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SHOP
class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _shopRepository;

  ShopBloc(this._shopRepository) : super(InitialShopState());

  @override
  Stream<ShopState> mapEventToState(ShopEvent event) async* {
    if (event is GetShopDataEvent) {
      yield InitialShopState();
      List<ShopItem> response = [];
      try {
        var list = await _shopRepository.getCatalogs();
        response.addAll(list);
      } catch (e) {
        yield FailureShopState(e.toString());
      }
      yield FetchedShopState(response);
    }

    if (event is DoFilterEvent) {
      yield CleanShopListener();
      yield FilterShopListener();
    }

    if (event is GetShopDataFilterEvent) {
      yield InitialShopState();
      List<ShopItem> response = [];
      try {
        var list = await _shopRepository.getCatalogFiltered(
            order: event.order, type: event.type);
        response.addAll(list);
      } catch (e) {
        yield FailureShopState(e.toString());
      }
      yield FetchedShopState(response);
    }

    if (event is CheckOutShopDataEvent) {}
  }
}

abstract class ShopEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetShopDataEvent extends ShopEvent {}

class GetShopDataFilterEvent extends ShopEvent {
  final String order;
  final String type;

  GetShopDataFilterEvent({this.order = "", this.type = ""});
}

class DoFilterEvent extends ShopEvent {}

abstract class ShopState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialShopState extends ShopState {}

class CleanShopListener extends ShopState {}

class FilterShopListener extends ShopState {}

class FetchedShopState extends ShopState {
  final List<ShopItem> response;
  FetchedShopState(this.response);
}

class FailureShopState extends ShopState {
  final String error;
  FailureShopState(this.error);
}

//END SHOP

//CHECK_OUT BLOC
class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final ShopRepository _shopRepository;

  final DatabaseHelper _db = DatabaseHelper();

  CheckOutBloc(this._shopRepository) : super(InitialCheckOutState());

  @override
  Stream<CheckOutState> mapEventToState(CheckOutEvent event) async* {
    if (event is CheckOutShopDataEvent) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString("city") == "" || event.user.city.isEmpty) {
        yield FailureCheckOutCityEmptyState();
      } else {
        try {
          var baskets = await _db.getAllCheckOutBasket();

          List<List<String>> catalogs = baskets.map((e) {
            if (e.item.options == null || e.item.options.isEmpty) {
              return [e.item.id.toString(), e.count.toString()];
            } else {
              List<String> temp = [e.item.id.toString(), e.count.toString()];
              List<String> ss = e.item.options.map((e) => e as String).toList();
              temp.addAll(ss);
              return temp;
            }
          }).toList(); //[id,count,options]

          print(catalogs.toList().toString());
          var money = 0;
          try {
            baskets.forEach((element) {
              money += (element.count) * int.parse(element.item.priceInPoints);
            });
          } catch (e) {}

          var map = {
            "phone": event.user.phone,
            "price": money,
            "catalogs": jsonEncode(catalogs),
            "name": event.user.name,
            "surname": event.user.surname,
            "street": event.user.street,
            "home": event.user.house,
            "apartment": event.user.apartment,
            "block": event.user.block,
            "entrance": event.user.entrance,
            "other": event.user.comment,
            "email": event.user.email,
            "city": event.user.city
          };

          print("order -" + map.toString());
          yield LoadingCheckOutState();

          var _response = await _shopRepository.doOrder(map);

          if (_response.status == "success") {
            print("sss");
            await _db.removeAll();
            yield SuccessCheckOutState(_response.msg);
          } else {
            // yield InitialCheckOutState();
            yield FailureCheckOutState(_response.msg);
            yield InitialCheckOutState();
          }
        } catch (e) {
          yield FailureCheckOutState(e.toString());
          yield InitialCheckOutState();
        }
      }

      yield CleanCheckOutState();
    }
  }
}

abstract class CheckOutEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckOutShopDataEvent extends CheckOutEvent {
  final User user;
  final String phone;
  CheckOutShopDataEvent({this.user, this.phone});
}

abstract class CheckOutState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialCheckOutState extends CheckOutState {}

class CleanCheckOutState extends CheckOutState {}

class LoadingCheckOutState extends CheckOutState {}

class FailureCheckOutCityEmptyState extends CheckOutState {}

class SuccessCheckOutState extends CheckOutState {
  final String id;
  SuccessCheckOutState(this.id);
}

class FailureCheckOutState extends CheckOutState {
  final String error;
  FailureCheckOutState(this.error);
}

//END SHOP

////COUNTER START
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class IncrementEvent extends CounterEvent {
  final ShopItem item;
  final String userBonus;
  IncrementEvent(this.item, this.userBonus);
}

class IncrementProductItemEvent extends CounterEvent {
  final ProductItem item;
  final String size;
  IncrementProductItemEvent(this.item, this.size);
}

class BasketAddEvent extends CounterEvent {
  final BasketItem item;
  BasketAddEvent(this.item);
}

class BasketRemoveEvent extends CounterEvent {
  final BasketItem item;
  BasketRemoveEvent(this.item);
}

class GetCounterDataEvent extends CounterEvent {}

class CounterState extends Equatable {
  final int counter;
  final int money;
  const CounterState({this.counter, this.money});

  @override
  List<Object> get props => [counter];
}

class RefreshBasketState extends CounterState {}

class CleanBasketState extends CounterState {}

class FailureUnAuthBasketState extends CounterState {}

class FailureBonusLackBasketState extends CounterState {}

class SuccessBonusLackBasketState extends CounterState {}

class FailureUnLoyalBasketState extends CounterState {}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(counter: 0));
  var db = DatabaseHelper();

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    var prefs = await SharedPreferences.getInstance();

    if (event is IncrementEvent) {
      var isAuth = prefs.getString("isRegistered");
      var isLoyal = prefs.getString("isLoyal");
      if (isAuth == null) {
        yield CleanBasketState();
        yield FailureUnAuthBasketState();
      } else if (isLoyal != null) {
        yield CleanBasketState();
        yield FailureUnLoyalBasketState();
      } else {
        if (int.parse(event.item.priceInPoints) <= int.parse(bonus) &&
            int.parse(bonus) > 0) {
          var leftBonus =
              int.parse(bonus) - int.parse(event.item.priceInPoints);
          bonus = leftBonus.toString();

          await db.addShopItem(ShopItem(
              id: event.item.id,
              srcImage: event.item.mainImage.src,
              price: event.item.price,
              titleRu: event.item.name.ru,
              titleKz: event.item.name.kz,
              priceInPoints: event.item.priceInPoints,
              uUID: event.item.uUID));

          var size = await db.getSizeBasket();
          print(size);
          yield SuccessBonusLackBasketState();
          yield CounterState(counter: size);
        } else {
          print(event.userBonus);
          print(event.item.price);
          yield CleanBasketState();
          yield FailureBonusLackBasketState();
        }
      }
    }

    if (event is GetCounterDataEvent) {
      var size = await db.getSizeBasket();
      yield CounterState(counter: size);
    }

    if (event is IncrementProductItemEvent) {
      var isAuth = prefs.getString("isRegistered");
      var isLoyal = prefs.getString("isLoyal");
      if (isAuth == null) {
        yield CleanBasketState();
        yield FailureUnAuthBasketState();
      } else if (isLoyal != null) {
        yield CleanBasketState();
        yield FailureUnLoyalBasketState();
      } else {
        await db.addShopItem(ShopItem(
            id: event.item.id,
            srcImage: event.item.images.first.src,
            price: event.item.price,
            options: [event.size],
            titleRu: event.item.name.ru,
            titleKz: event.item.name.kz,
            priceInPoints: event.item.priceInPoints,
            uUID: event.item.uUID));

        var size = await db.getSizeBasket();

        yield CounterState(counter: size);
      }
    }

    if (event is BasketRemoveEvent) {
      await db.removeItem(event.item.item.positionId);
      yield RefreshBasketState();
      var size = await db.getSizeBasket();
      yield CounterState(counter: size);
    }

    if (event is BasketAddEvent) {
      await db.addShopItem(event.item.item);
      yield RefreshBasketState();
      var size = await db.getSizeBasket();
      yield CounterState(counter: size);
    }

    if (event is GetCounterDataEvent) {}

    if (event is RemovePositionEvent) {
      var basket = await db.getAllWithID(event.item.item.id.toString());

      for (int i = 0; i < basket.length; i++) {
        db.removeItem(basket[i].positionId);
      }

      yield RefreshBasketState();
      var size = await db.getSizeBasket();
      yield CounterState(counter: size);
    }
  }
}

///COUNTER END

//SHOP
class BasketBloc extends Bloc<BasketEvent, BasketState> {
  DatabaseHelper _db = new DatabaseHelper();

  BasketBloc() : super(InitialBasketState());
  // ShopRepository _repository = ShopRepository();

  @override
  Stream<BasketState> mapEventToState(BasketEvent event) async* {
    yield InitialBasketState();

    if (event is GetBasketDataEvent) {
      List<BasketItem> response = [];
      var money = 0;

      try {
        var basket = await _db.getAllBasket();
        response.addAll(basket);

        try {
          basket.forEach((element) {
            money += (element.count) * int.parse(element.item.priceInPoints);
          });
        } catch (e) {}
      } catch (e) {
        print(e.toString());
        yield FailureBasketState(e.toString());
      }
      yield FetchedBasketState(response, money);
    }
  }
}

abstract class BasketEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBasketDataEvent extends BasketEvent {}

abstract class BasketState extends Equatable {
  @override
  List<Object> get props => [];
}

class RemovePositionEvent extends CounterEvent {
  final BasketItem item;
  RemovePositionEvent(this.item);
}

class InitialBasketState extends BasketState {}

class FetchedBasketState extends BasketState {
  final List<BasketItem> response;
  final int money;
  FetchedBasketState(this.response, this.money);
}

class FailureBasketState extends BasketState {
  final String error;
  FailureBasketState(this.error);
}

//END SHOP
