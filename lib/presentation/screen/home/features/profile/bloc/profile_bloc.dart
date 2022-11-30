import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/presentation/screen/home/features/shop/shop_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc(this._userRepository) : super(InitialProfileState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is CleanProfileBlocEvent) {
      yield CleanProfileState();
    }

    if (event is GetProfileDataEvent) {
      User user;
      try {
        user = await _userRepository.getUser();
        savedInitBonus = user.bonus;

        var bonusStatus = await _userRepository.checkForBonus();
        if (bonusStatus.status == "false") {
          user.initialBonus = false;
        } else {
          user.initialBonus = true;
        }
      } catch (e) {
        yield FailureProfileState(e.toString());
      }
      yield CleanProfileState();

      yield FetchedProfileState(user);
    }

    if (event is UpdateProfileEvent) {
      try {
        var user = event.user;
        var prefs = await SharedPreferences.getInstance();
        if (prefs.getString("gender") != null) {
          user.sex = prefs.getString("gender");
        }
        if (prefs.getString("city") != null) {
          user.city = prefs.getString("city");
        }
        var response = await _userRepository.updateFullUser(user);
        yield FetchedProfileState(response);
      } catch (e) {}
    }

    if (event is SetGenderEvent) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString("gender", event.gender);
    }

    if (event is SetCityProfileEvent) {
      var prefs = await SharedPreferences.getInstance();
      if (event.status == "yes") {
        await prefs.setString("isLoyal", null);
      } else if (event.status == "no") {
        await prefs.setString("isLoyal", "yes");
      }
      await prefs.setString("city", event.city);
    }
  }
}

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetProfileDataEvent extends ProfileEvent {}

class CleanProfileBlocEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final User user;
  UpdateProfileEvent(this.user);
}

class SetGenderEvent extends ProfileEvent {
  final String gender;
  SetGenderEvent(this.gender);
}

class SetCityProfileEvent extends ProfileEvent {
  final String status;
  final String city;
  SetCityProfileEvent(this.city, this.status);
}

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialProfileState extends ProfileState {}

class CleanProfileState extends ProfileState {}

class FetchedProfileState extends ProfileState {
  final User name;
  FetchedProfileState(this.name);
}

class FailureProfileState extends ProfileState {
  final String error;
  FailureProfileState(this.error);
}
