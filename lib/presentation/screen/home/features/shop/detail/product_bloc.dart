//SHOP
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/repo/shop_repository.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/product_item.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ShopRepository _shopRepository;

  ProductBloc(this._shopRepository) : super(InitialProductState());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is GetProductDataEvent) {
      yield InitialProductState();
      ProductItem item;
      try {
        var list = await _shopRepository.getCatalogsID(event.id);
        item = list.first;
      } catch (e) {
        yield FailureProductState(e.toString());
      }
      yield FetchedProductState(item);
    }
  }
}

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetProductDataEvent extends ProductEvent {
  final int id;
  GetProductDataEvent(this.id);
}

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialProductState extends ProductState {}

class FetchedProductState extends ProductState {
  final ProductItem response;
  FetchedProductState(this.response);
}

class FailureProductState extends ProductState {
  final String error;
  FailureProductState(this.error);
}
