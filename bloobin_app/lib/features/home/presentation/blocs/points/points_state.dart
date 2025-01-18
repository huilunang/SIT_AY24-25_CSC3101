import 'package:bloobin_app/features/home/domain/points.dart';

sealed class PointsState {}

final class PointsInitial extends PointsState {}

final class PointsLoadInProgress extends PointsState {}

final class PointsLoadSuccess extends PointsState {
  final Points points;

  PointsLoadSuccess(this.points);
}

final class PointsError extends PointsState {
  final String errorMessage;

  PointsError(this.errorMessage);
}
