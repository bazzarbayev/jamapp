import 'package:equatable/equatable.dart';
import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/widgets/dialog.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

//listeners

class ShowAlert extends AuthenticationState {
  final String title, description, text;
  final String doIt;

  const ShowAlert({this.title, this.description, this.text, this.doIt});

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'ShowAlert {displayName: $description}';
  }

  ShowAlert copyWith({title, description, text}) {
    return ShowAlert(title: title, description: description, text: text);
  }
}

class Uninitialized extends AuthenticationState {}

class ClearAuthState extends AuthenticationState {}

class ShowAlertCityNotAvailable extends AuthenticationState {
  final String title, description, text, cancel;
  final FinishRegisterData data;
  const ShowAlertCityNotAvailable(
      {this.title, this.description, this.text, this.cancel, this.data});
}

class ClearLoadingAuthState extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Authenticated{displayName: $user}';
  }
}

class Unauthenticated extends AuthenticationState {}

class ConfirmAgeState extends AuthenticationState {}

class RegistrationState extends AuthenticationState {}

class CheckCodeState extends AuthenticationState {
  final String phone;
  final bool isNewUser;
  CheckCodeState(this.phone, this.isNewUser);
}

class RegisterNameAuthState extends AuthenticationState {
  final List<CityResponse> cities;
  final String phone;
  RegisterNameAuthState(this.cities, this.phone);
}
