import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jam_app/app/main_bloc/main_event.dart';
import 'package:jam_app/app/main_bloc/main_state.dart';
import 'package:jam_app/model/repo/user_repository.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        super(UnMainInitialized());

  MainState get initialState => UnMainInitialized();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    // if (event is CheckAge) {
    //   if (!event.isOlder) {
    //     // yield ShowAgeAlert(
    //     //     title: "Тебе нет 21 года",
    //     //     description:
    //     //         "К сожалению, ты не можешь получить доступ к нашей программе лояльности :(",
    //     //     text: "ok");
    //     yield UnMainInitialized();
    //   } else {}
    // }
  }
}
