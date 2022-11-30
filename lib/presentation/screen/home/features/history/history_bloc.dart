import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/entity/history.dart';
import 'package:jam_app/model/repo/user_repository.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final UserRepository _userRepository;

  HistoryBloc(this._userRepository) : super(InitialHistoryState());

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    if (event is GetHistoryDataEvent) {
      List<History> list = [];
      try {
        yield LoadingHistoryState();
        var listt = await _userRepository.getHistory(event.language);
        log("history listt: " + listt.toString());
        if (listt.isEmpty || listt.length == 0) {
          yield EmptyHistoryState();
        } else {
          list.addAll(listt);
          yield FetchedHistoryState(list);

          log("history list: " + list.toString());
        }
      } catch (e) {
        print(e.toString());
        yield FailureHistoryState(e.toString());
      }
    }
  }
}

abstract class HistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetHistoryDataEvent extends HistoryEvent {
  final String language;
  GetHistoryDataEvent({this.language});
}

class LoadingHistoryDataEvent extends HistoryEvent {}

class UpdateHistoryTypeEvent extends HistoryEvent {
  final int type;
  UpdateHistoryTypeEvent(this.type);
}

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialHistoryState extends HistoryState {}

class LoadingHistoryState extends HistoryState {}

class FetchedHistoryState extends HistoryState {
  final List<History> list;
  FetchedHistoryState(this.list);
}

class EmptyHistoryState extends HistoryState {}

class FailureHistoryState extends HistoryState {
  final String error;
  FailureHistoryState(this.error);
}
