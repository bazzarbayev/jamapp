import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/entity/history_order.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/model/repo/user_repository.dart';

class MyOrderBloc extends Bloc<MyOrderEvent, MyOrderState> {
  final UserRepository _userRepository;

  MyOrderBloc(this._userRepository) : super(InitialMyOrderState());

  @override
  Stream<MyOrderState> mapEventToState(MyOrderEvent event) async* {
    if (event is GetMyOrders) {
      yield InitialMyOrderState();
      List<HistoryOrder> orders = [];
      orders = await _userRepository.getMyOrders();

      yield FetchedHistoryOrderState(orders);
    }

    if (event is GetMyOrderDetailEvent) {
      HistoryOrder order;
      try {
        order = await _userRepository.getMyOrder(event.id);
        yield FetchedOrderState(order);
      } catch (e) {
        yield FailureMyOrderState(e.toString());
      }
    }
  }
}

abstract class MyOrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMyOrders extends MyOrderEvent {}

class GetMyOrderDetailEvent extends MyOrderEvent {
  final int id;
  GetMyOrderDetailEvent(this.id);
}

class UpdateMyOrderTypeEvent extends MyOrderEvent {
  final int type;
  UpdateMyOrderTypeEvent(this.type);
}

abstract class MyOrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMyOrderState extends MyOrderState {}

class FetchedMyOrderState extends MyOrderState {
  final User name;
  FetchedMyOrderState(this.name);
}

class FetchedHistoryOrderState extends MyOrderState {
  final List<HistoryOrder> order;
  FetchedHistoryOrderState(this.order);
}

class FetchedOrderState extends MyOrderState {
  final HistoryOrder order;
  FetchedOrderState(this.order);
}

class FailureMyOrderState extends MyOrderState {
  final String error;
  FailureMyOrderState(this.error);
}
