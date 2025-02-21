import 'package:bloobin_app/features/home/domain/reward.dart';

sealed class RewardEvent {}

class RewardLoaded extends RewardEvent {
  RewardLoaded();
}

class RewardClaimed extends RewardEvent {
  final Reward reward;

  RewardClaimed(this.reward);
}
