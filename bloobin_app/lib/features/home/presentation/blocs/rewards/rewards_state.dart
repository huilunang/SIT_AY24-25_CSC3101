import 'package:bloobin_app/features/home/domain/rewards.dart';

sealed class RewardsState {}

final class RewardsInitial extends RewardsState {}

final class RewardsLoadInProgress extends RewardsState {}

final class RewardsLoadSuccess extends RewardsState {
  final List<Rewards> rewardsList;

  RewardsLoadSuccess(this.rewardsList);
}

final class RewardsError extends RewardsState {
  final String errorMessage;

  RewardsError(this.errorMessage);
}
