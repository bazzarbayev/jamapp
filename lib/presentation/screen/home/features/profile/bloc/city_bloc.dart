import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/model/repo/user_repository.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final UserRepository _userRepository;

  CityBloc(this._userRepository) : super(InitialCityState());
  // CityRepository _repository = CityRepository();

  @override
  Stream<CityState> mapEventToState(CityEvent event) async* {
    // yield FetchedCityState();
    if (event is GetCityDataEvent) {
      // yield InitialCityState();
      List<CityResponse> response = [
        // CityResponse(status: "nothandle", name: "")
      ];
      try {
        var list = await _userRepository.getCities();
        response.addAll(list);
      } catch (e) {
        print(e.toString());
        yield FailureCityState(e.toString());
      }
      yield FetchedCityState(response);
    }
  }
}

abstract class CityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCityDataEvent extends CityEvent {}

abstract class CityState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialCityState extends CityState {}

class FetchedCityState extends CityState {
  final List<CityResponse> response;
  FetchedCityState(this.response);
}

class FailureCityState extends CityState {
  final String error;
  FailureCityState(this.error);
}
