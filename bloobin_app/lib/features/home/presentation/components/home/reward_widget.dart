import 'package:bloobin_app/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_state.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/reward_event.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsWidget extends StatelessWidget {
  const RewardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rewards',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Material(
                elevation: 1.0,
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      _buildRewardTile(
                        colorScheme: colorScheme,
                        value: state.home.points,
                        label: 'Points',
                        onTap: () {
                          Navigator.of(context).pushNamed('/points');

                          context.pointsBloc.add(PointsLoaded());
                        },
                      ),
                      Container(
                        width: 2,
                        height: 70,
                        color: colorScheme.onError,
                      ),
                      _buildRewardTile(
                        colorScheme: colorScheme,
                        value: state.home.rewards,
                        label: 'Rewards',
                        onTap: () {
                          Navigator.of(context).pushNamed('/reward');

                          context.rewardsBloc.add(RewardLoaded());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is HomeError) {
          return Text('Error: ${state.errorMessage}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRewardTile({
    required ColorScheme colorScheme,
    required String value,
    required String label,
    required Function() onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
