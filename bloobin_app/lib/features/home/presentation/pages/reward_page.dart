import 'package:bloobin_app/common_widgets/custom_snack_bar.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/reward_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/reward_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/reward_state.dart';
import 'package:bloobin_app/theme/theme.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Vouchers',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Click to claim the vouchers',
              style: TextStyle(color: colorScheme.secondary),
            ),
            const SizedBox(height: 20),
            BlocConsumer<RewardBloc, RewardState>(listener: (context, state) {
              if (state is RewardClaimSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.show(
                    context, state.message,
                    type: 'success'));
              } else if (state is RewardClaimError) {
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.show(
                    context, state.errorMessage,
                    type: 'error'));
              }
            }, buildWhen: (previous, current) {
              return previous != current &&
                  (current is RewardLoadSuccess ||
                      current is RewardLoadInProgress ||
                      current is RewardError ||
                      current is RewardEmpty);
            }, builder: (context, state) {
              if (state is RewardLoadSuccess) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.rewardList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10), // Space between items
                    itemBuilder: (context, index) {
                      final voucher = state.rewardList[index];
                      final dateFormatter = DateFormat('yyyy-MM-dd');

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Claim Voucher'),
                                content: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                          text:
                                              'Are you sure you want to claim to use '),
                                      TextSpan(
                                        text: voucher.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(text: '?'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.rewardsBloc.add(RewardClaimed(
                                          context.homeBloc, voucher));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Claim'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: index.isEven
                              ? colorScheme.sectionContainerLightScheme
                              : colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  voucher.name,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  dateFormatter.format(
                                      DateTime.parse(voucher.validDate)),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is RewardLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RewardError) {
                return Center(child: Text(state.errorMessage));
              } else if (state is RewardEmpty) {
                return const Center(child: Text('No rewards available.'));
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
