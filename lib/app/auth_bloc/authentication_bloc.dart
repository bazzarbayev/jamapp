import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/widgets/dialog.dart';

import 'bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(Uninitialized());

  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      //test code for fast enter without sms
      // User user = await _userRepository.getUserWithPhone("87772208815");
      // yield Authenticated(user);
      yield* _mapAppStartedToState();
    } else if (event is CheckAgeEvent) {
      yield* _mapCheckAgeToState(event);
    } else if (event is LogInNotAuthEvent) {
      yield* _mapLogInNotAuthToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is GoRegisterPageEvent) {
      yield ClearAuthState();
      yield RegistrationState();
    } else if (event is RegisterPhoneEvent) {
      yield* _mapRegisterPhoneState(event);
    } else if (event is CheckCodeEvent) {
      yield* _mapCheckCodeState(event);
    } else if (event is SendCodeAgainEvent) {
      await _userRepository.registerPhone(event.phone);
    } else if (event is GetCitiesAuthEvent) {
      yield* _mapGoRegisterNameToState(event);
    } else if (event is FinishRegisterEvent) {
      if (!event.isAvailable) {
        yield* _mapShowAlertNoLoyaltyState(event.data, event.localizationText);
      } else {
        await _userRepository.setRegistered(event.data.phone);

        if (event.loyalty.isNotEmpty) {
          await _userRepository.setLoyalty(event.loyalty);
        }

        String token = await FirebaseMessaging().getToken();
        await _userRepository.saveDeviceToken(
            token: token, phone: event.data.phone);

        await _userRepository.updateUser(event.data.phone, event.data.name,
            event.data.instagram, event.data.facebook, event.data.city,
            loyalty: event.loyalty);
        yield* _mapLoggedInToState();
      }
    } else if (event is ShowCustomAlert) {
      yield* _mapShowCustomAlert(event);
    }
  }

  Stream<AuthenticationState> _mapShowCustomAlert(
      ShowCustomAlert event) async* {
    yield ClearAuthState();

    yield ShowAlert(
        title: event.title,
        description: event.desc,
        text: event.btnText,
        doIt: event.doIt);
  }

  Stream<AuthenticationState> _mapShowAlertNoLoyaltyState(
      FinishRegisterData data, Map map) async* {
    yield ClearAuthState();

    yield ShowAlertCityNotAvailable(
        title: "",
        description: map["main_text"],
        text: map["yes_thanks"],
        cancel: map["no_thanks"],
        data: data);
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    // yield RegisterNameAuthState([], "123123");
    try {
      yield Uninitialized();
      final isOlder21 = await _userRepository.isOlder21();
      await Future.delayed(Duration(seconds: 2));

      if (isOlder21) {
        final isRegistered = await _userRepository.isRegistered();

        if (isRegistered) {
          final user = await _userRepository.getUser();
          if (user.name != null) {
            yield Authenticated(user);
          } else {
            yield Unauthenticated();
          }
        } else {
          yield RegistrationState();
        }
      } else {
        yield ConfirmAgeState();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLogInNotAuthToState() async* {
    await _userRepository.setOlder21();

    yield Unauthenticated();
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapCheckAgeToState(CheckAgeEvent event) async* {
    if (!event.isOlder) {
      yield ClearAuthState();

      yield ShowAlert(
          title: "Тебе нет 21 года",
          description:
              "К сожалению, ты не можешь получить доступ к нашей программе лояльности :(",
          text: "ok");
    } else {}
  }

  Stream<AuthenticationState> _mapRegisterPhoneState(
      RegisterPhoneEvent event) async* {
    await _userRepository.setOlder21();

    var _phone = "8${event.phone}";

    try {
      var response = await _userRepository.registerPhone(_phone);
      if (response.status == "success") {
        yield CheckCodeState(_phone, response.newUser);
      } else {
        yield ClearAuthState();

        yield ShowAlert(
            title: "Ошибка", description: "Повторите еще раз", text: "ok");
      }
    } catch (e) {
      yield ClearAuthState();

      yield ShowAlert(title: "Ошибка", description: e.toString(), text: "ok");
    }
  }

  Stream<AuthenticationState> _mapCheckCodeState(CheckCodeEvent event) async* {
    var response = await _userRepository.checkCode(event.phone, event.code);
    if (response.status == "success") {
      if (!event.isNewUser) {
        String token = await FirebaseMessaging().getToken();
        await _userRepository.saveDeviceToken(token: token, phone: event.phone);

        try {
          User user = await _userRepository.getUserWithPhone(event.phone);
          yield Authenticated(user);
        } catch (e) {
          yield ClearAuthState();
          yield ShowAlert(
              title: "Ошибка", description: e.toString(), text: "ok");
        }
      } else {
        var cities = await _userRepository.getCities();
        yield RegisterNameAuthState(cities, event.phone);
      }
    } else {
      yield ClearAuthState();

      yield ShowAlert(
          title: "Ошибка!",
          description: "Неверный СМС код",
          text: "ввести повторно");
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapGoRegisterNameToState(
      GetCitiesAuthEvent event) async* {
    var cities = await _userRepository.getCities();
    yield RegisterNameAuthState(cities, event.phone);
  }
}
