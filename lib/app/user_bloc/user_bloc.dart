import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(InitialUserState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield InitialUserState();

    if (event is GoScanToHistoryEvent) {
      yield CleanUserState();
      yield GoScanToHistoryState();
    }

    if (event is GetUsersOrdersMarkEvent) {
      var list = await repository.getUserOrdersMark();

      if (list.isNotEmpty) {
        var ids = list.map((e) => e.id).toList();
        yield OrderMarkDialogState(ids: ids);
        yield CleanUserState();
      }

      if (coldBrew) {
        yield* _coldBrewPopUpShow();
      }
    }
  }

  Stream<UserState> _coldBrewPopUpShow() async* {
    var sp = await SharedPreferences.getInstance();

    var coldBrewPopUpLaunched = sp.getString("cold_brew_popup_launch_445d");

    var date = DateTime.now();
    var d2 = DateTime(2021, 9, 30);

    if (d2.isAfter(date)) {
      if (coldBrewPopUpLaunched == null) {
        sp.setString("cold_brew_popup_launch_445d", date.toString());
        yield ColdBrewModeState();
        yield CleanUserState();
      } else {
        var lastSavedDate = sp.getString("cold_brew_popup_launch_445d");
        var prevDate = DateTime.parse(lastSavedDate);
        var diffDays = date.difference(prevDate).inDays;
        if (diffDays >= 3) {
          sp.setString("cold_brew_popup_launch_445d", date.toString());
          yield ColdBrewModeState();
          yield CleanUserState();
        }
      }
    }
  }
}

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserDataEvent extends UserEvent {}

class GetUsersOrdersMarkEvent extends UserEvent {}

class GoScanToHistoryEvent extends UserEvent {}

class CleanUserEvent extends UserEvent {}

class CleanUserState extends UserState {}

class GoScanToHistoryState extends UserState {}

class UpdateUserTypeEvent extends UserEvent {
  final int type;
  UpdateUserTypeEvent(this.type);
}

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialUserState extends UserState {}

class OrderMarkDialogState extends UserState {
  final List<int> ids;
  OrderMarkDialogState({this.ids});
}

class ColdBrewModeState extends UserState {}

class FetchedUserState extends UserState {}

class FailureUserState extends UserState {
  final String error;
  FailureUserState(this.error);
}
