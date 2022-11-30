import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:jam_app/widgets/dialog.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ClearAuthEvent extends AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LogInNotAuthEvent extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class ShowCustomAlert extends AuthenticationEvent {
  final String title, desc, btnText;
  final String doIt;
  ShowCustomAlert(this.title, this.desc, this.btnText, this.doIt);
}

class GoRegisterPageEvent extends AuthenticationEvent {}

class GetCitiesAuthEvent extends AuthenticationEvent {
  final String phone;
  GetCitiesAuthEvent(this.phone);
}

// ignore: must_be_immutable
class FinishRegisterEvent extends AuthenticationEvent {
  final FinishRegisterData data;
  final bool isAvailable;

  final Map localizationText;
  String loyalty = "";
  FinishRegisterEvent(this.data, this.isAvailable, {this.loyalty, this.localizationText});
}

class RegisterPhoneEvent extends AuthenticationEvent {
  final String phone;
  RegisterPhoneEvent(this.phone);
}

class SendCodeAgainEvent extends AuthenticationEvent {
  final String phone;
  SendCodeAgainEvent(this.phone);
}

class CheckCodeEvent extends AuthenticationEvent {
  final String code, phone;
  final bool isNewUser;
  CheckCodeEvent(this.code, this.phone, this.isNewUser);
}

// ignore: must_be_immutable
class CheckAgeEvent extends AuthenticationEvent {
  final String day, month, year;

  bool isOlder = false;

  CheckAgeEvent({this.day, this.month, this.year}) {
    this.isOlder = isAdult("$day-$month-$year");
  }

  @override
  String toString() {
    return "$day-$month-$year";
  }

  @override
  List<Object> get props => [day, month, year];

  bool isAdult(String birthDateString) {
    String datePattern = "dd-MM-yyyy";

    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);

    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 21,
      birthDate.month,
      birthDate.day,
    );

    return adultDate.isBefore(today);
  }
}
