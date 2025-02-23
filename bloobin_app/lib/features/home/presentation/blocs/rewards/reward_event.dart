import 'package:bloobin_app/features/home/domain/reward.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_bloc.dart';

sealed class RewardEvent {}

class RewardLoaded extends RewardEvent {
  RewardLoaded();
}

class RewardClaimed extends RewardEvent {
  final HomeBloc homeBloc;
  final Reward reward;

  RewardClaimed(this.homeBloc, this.reward);
}
