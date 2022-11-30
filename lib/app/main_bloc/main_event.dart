import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AgeAlertEvent extends MainEvent {}

class ShowLoadingEvent extends MainEvent {}
