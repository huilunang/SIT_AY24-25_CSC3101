import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_state.dart';
import 'package:bloobin_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CataloguePage extends StatelessWidget {
  const CataloguePage({super.key});

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
            BlocBuilder<CatalogueBloc, CatalogueState>(
                builder: (context, state) {
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
                          print('Clicked on ${voucher.name}');
                          // Add navigation or dialog here if needed
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
              }

              return const Center(
                child: Text('No catalogue available'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
