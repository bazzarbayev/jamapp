import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class UnMainInitialized extends MainState {}

class ShowLoading extends MainState {}

class HideLoading extends MainState {}
