import 'package:bloobin_app/common_widgets/custom_snack_bar.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_state.dart';
import 'package:bloobin_app/theme/theme.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CataloguePage extends StatelessWidget {
  final String points;

  const CataloguePage({super.key, required this.points});

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
              'Catalogue',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Click to redeem the vouchers using points',
              style: TextStyle(color: colorScheme.secondary),
            ),
            const SizedBox(height: 20),
            BlocConsumer<CatalogueBloc, CatalogueState>(
                listener: (context, state) {
              if (state is CatalogueRedeemSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.show(
                    context, state.message,
                    type: 'success'));

                Future.delayed(const Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                });
              } else if (state is CatalogueRedeemError) {
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.show(
                    context, state.errorMessage,
                    type: 'error'));
              }
            }, buildWhen: (previous, current) {
              return previous != current &&
                  (current is CatalogueLoadSuccess ||
                      current is CatalogueLoadInProgress ||
                      current is CatalogueError ||
                      current is CatalogueEmpty);
            }, builder: (context, state) {
              if (state is CatalogueLoadSuccess) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.catalogueList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10), // Space between items
                    itemBuilder: (context, index) {
                      final voucher = state.catalogueList[index];

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Redeem Voucher'),
                                  content: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                            text:
                                                'Are you sure you want to redeem '),
                                        TextSpan(
                                          text: voucher.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(text: ' using '),
                                        TextSpan(
                                          text: '${voucher.cost} points',
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
                                        context.catalogueBloc.add(
                                            CatalogueRedeemed(
                                                context.homeBloc,
                                                context.pointsBloc,
                                                points,
                                                voucher));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Redeem'),
                                    ),
                                  ],
                                );
                              });
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
                                  '${voucher.cost} pts',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: colorScheme.secondary,
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
              } else if (state is CatalogueLoadInProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CatalogueError) {
                return Center(
                  child: Text(
                    'Failed to load catalogue: ${state.errorMessage}',
                    style: TextStyle(color: colorScheme.error),
                  ),
                );
              } else if (state is CatalogueEmpty) {
                return const Center(
                  child: Text('No catalogue available'),
                );
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
