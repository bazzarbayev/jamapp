import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/entity/sales_department.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SalesDepartmentsBloc
    extends Bloc<SalesDepartmentsEvent, SalesDepartmentsState> {
  final UserRepository _userRepository;
  List<SalesDepartment> stores;
  final Function callback;
  SalesDepartment _store;

  final MapObjectId mapObjectCollectionId =
      const MapObjectId('map_object_collection');

  SalesDepartmentsBloc(this._userRepository, this.callback)
      : super(InitialSalesDepartmentsState());

  @override
  Stream<SalesDepartmentsState> mapEventToState(
      SalesDepartmentsEvent event) async* {
    if (event is GetSalesDepartments) {
      yield InitialSalesDepartmentsState();

      try {
        stores = await _userRepository.getSalesDepartments();

        List<MapObject> mapObjects = [];

        for (var store in stores) {
          var _point = Point(
            latitude: double.parse(store.coordX),
            longitude: double.parse(store.coordY),
          );

          final placemark = Placemark(
            mapId: MapObjectId(store.id.toString()),
            point: _point,
            onTap: (Placemark self, Point point) {
              print("storeName: " + store.name);
              _store = store;
              callback(_store);
            },
            opacity: 1,
            direction: 90,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/location.png'),
                  rotationType: RotationType.rotate),
            ),
          );

          mapObjects.add(placemark);
        }

        yield FetchedMySalesDepartmentsState(mapObjects);
      } catch (e) {
        FailureSalesDepartmentsState(e.toString());
      }
    }

    if (event is GetBarSalesDepartments) {
      yield InitialSalesDepartmentsState();

      try {
        stores = await _userRepository.getSalesDepartments();

        List<SalesDepartment> filteredStores = [];

        for (SalesDepartment c in stores) {
          if (c.type == "Бар") {
            filteredStores.add(c);
          }
        }

        List<MapObject> mapObjects = [];

        for (var store in filteredStores) {
          var _point = Point(
            latitude: double.parse(store.coordX),
            longitude: double.parse(store.coordY),
          );

          final placemark = Placemark(
              mapId: MapObjectId(store.id.toString()),
              point: _point,
              onTap: (Placemark self, Point point) {
                _store = store;
                callback(_store);
              },
              opacity: 1,
              direction: 90,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/location.png'),
                  rotationType: RotationType.rotate)));

          mapObjects.add(placemark);
        }

        yield FetchedMySalesDepartmentsState(mapObjects);
      } catch (e) {
        FailureSalesDepartmentsState(
            e.toString()); //wrap to try/catch to handle error
      }
    }

    if (event is GetPartnerSalesDepartments) {
      yield InitialSalesDepartmentsState();

      try {
        List<SalesDepartment> stores = [];
        stores = await _userRepository.getSalesDepartments();

        List<SalesDepartment> filteredStores = [];

        for (SalesDepartment c in stores) {
          if (c.type == "Партнёр") {
            filteredStores.add(c);
          }
        }

        List<MapObject> mapObjects = [];

        for (var store in filteredStores) {
          var _point = Point(
            latitude: double.parse(store.coordX),
            longitude: double.parse(store.coordY),
          );

          final placemark = Placemark(
              mapId: MapObjectId(store.id.toString()),
              point: _point,
              onTap: (Placemark self, Point point) {
                _store = store;
                callback(_store);
              },
              opacity: 1,
              direction: 90,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/location.png'),
                  rotationType: RotationType.rotate)));

          mapObjects.add(placemark);
        }

        yield FetchedMySalesDepartmentsState(mapObjects);
      } catch (e) {
        FailureSalesDepartmentsState(e.toString());
      }
    }

    if (event is GetStoreSalesDepartments) {
      yield InitialSalesDepartmentsState();

      try {
        List<SalesDepartment> stores = [];
        stores = await _userRepository.getSalesDepartments();

        List<SalesDepartment> filteredStores = [];

        for (SalesDepartment c in stores) {
          if (c.type == "Магазин") {
            filteredStores.add(c);
          }
        }

        List<MapObject> mapObjects = [];

        for (var store in filteredStores) {
          var _point = Point(
            latitude: double.parse(store.coordX),
            longitude: double.parse(store.coordY),
          );

          final placemark = Placemark(
              mapId: MapObjectId(store.id.toString()),
              point: _point,
              onTap: (Placemark self, Point point) {
                _store = store;
                callback(_store);
              },
              opacity: 1,
              direction: 90,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/location.png'),
                  rotationType: RotationType.rotate)));

          mapObjects.add(placemark);
        }

        yield FetchedMySalesDepartmentsState(mapObjects);
      } catch (e) {
        FailureSalesDepartmentsState(
            e.toString()); //wrap to try/catch to handle error
      }
    }

    if (event is GetPromotionedSalesDepartments) {
      yield InitialSalesDepartmentsState();

      try {
        List<SalesDepartment> stores = [];
        stores = await _userRepository.getSalesDepartments();

        List<SalesDepartment> filteredStores = [];

        for (SalesDepartment c in stores) {
          if (c.promotion != null) {
            filteredStores.add(c);
          }
        }

        List<MapObject> mapObjects = [];

        for (var store in filteredStores) {
          var _point = Point(
            latitude: double.parse(store.coordX),
            longitude: double.parse(store.coordY),
          );

          final placemark = Placemark(
              mapId: MapObjectId(store.id.toString()),
              point: _point,
              onTap: (Placemark self, Point point) {
                _store = store;
                callback(_store);
              },
              opacity: 1,
              direction: 90,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/location_active.png'),
                  rotationType: RotationType.rotate)));

          mapObjects.add(placemark);
        }

        yield FetchedMySalesDepartmentsState(mapObjects);
      } catch (e) {
        FailureSalesDepartmentsState(
            e.toString()); //wrap to try/catch to handle error
      }
    }
  }
}

abstract class SalesDepartmentsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetSalesDepartments extends SalesDepartmentsEvent {}

class GetBarSalesDepartments extends SalesDepartmentsEvent {}

class GetPartnerSalesDepartments extends SalesDepartmentsEvent {}

class GetStoreSalesDepartments extends SalesDepartmentsEvent {}

class GetPromotionedSalesDepartments extends SalesDepartmentsEvent {}

class UpdateSalesDepartmentsTypeEvent extends SalesDepartmentsEvent {
  final int type;
  UpdateSalesDepartmentsTypeEvent(this.type);
}

abstract class SalesDepartmentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialSalesDepartmentsState extends SalesDepartmentsState {}

class FetchedMySalesDepartmentsState extends SalesDepartmentsState {
  final List<MapObject> mapObjects;

  FetchedMySalesDepartmentsState(this.mapObjects);
}

class FetchedSalesDepartmentState extends SalesDepartmentsState {
  final SalesDepartment store;
  FetchedSalesDepartmentState(this.store);
}

class FailureSalesDepartmentsState extends SalesDepartmentsState {
  final String error;
  FailureSalesDepartmentsState(this.error);
}
