import 'package:bloobin_app/features/home/domain/home.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadInProgress extends HomeState {}

final class HomeLoadSuccess extends HomeState {
  final String frequency;
  final Home home;

  HomeLoadSuccess(this.frequency, this.home);
}

final class HomeError extends HomeState {
  final String errorMessage;

  HomeError(this.errorMessage);
}
