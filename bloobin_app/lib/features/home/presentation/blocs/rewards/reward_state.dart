import 'package:bloobin_app/features/home/domain/reward.dart';

sealed class RewardState {}

final class RewardInitial extends RewardState {}

final class RewardLoadInProgress extends RewardState {}

final class RewardLoadSuccess extends RewardState {
  final List<Reward> rewardList;

  RewardLoadSuccess(this.rewardList);
}

final class RewardClaimSuccess extends RewardState {
  final String message;

  RewardClaimSuccess(this.message);
}

final class RewardEmpty extends RewardState {}

final class RewardError extends RewardState {
  final String errorMessage;

  RewardError(this.errorMessage);
}

final class RewardClaimError extends RewardState {
  final String errorMessage;

  RewardClaimError(this.errorMessage);
}
