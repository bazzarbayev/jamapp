import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_app/model/repo/shop_repository.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ShopRepository _shopRepository;

  ScanBloc(this._shopRepository) : super(InitialScanState());

  @override
  Stream<ScanState> mapEventToState(ScanEvent event) async* {
    yield InitialScanState();
    if (event is SendScanDataEvent) {
      try {
        yield LoadingScanState();

        var user = await _shopRepository.getUser();

        var response = await _shopRepository.sendChecksUpdated(
            files: event.files, id: user.id.toString());

        if (response) {
          yield FetchedScanState();
        }
      } catch (e) {
        print(e.toString());

        yield FailureScanState(e.toString());
        yield InitialScanState();
      }
    }

  }
}

abstract class ScanEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RefreshScanEvent extends ScanEvent {}

class SendScanDataEvent extends ScanEvent {
  final List<File> files;
  SendScanDataEvent(this.files);
}

abstract class ScanState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialScanState extends ScanState {}

class FetchedScanState extends ScanState {}

class CleanScanState extends ScanState {}

class LoadingScanState extends ScanState {}

class FailureScanState extends ScanState {
  final String error;
  FailureScanState(this.error);
}
