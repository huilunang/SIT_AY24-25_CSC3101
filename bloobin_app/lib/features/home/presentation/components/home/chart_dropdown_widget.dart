import 'dart:collection';

import 'package:bloobin_app/features/home/presentation/blocs/home/home_event.dart';
import 'package:bloobin_app/theme/theme.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

class ChartDropdownWidget extends StatelessWidget {
  final String selectedFrequency;

  const ChartDropdownWidget({super.key, required this.selectedFrequency});

  static const List<String> dropdownOptions = ['Daily', 'Monthly'];
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    dropdownOptions
        .map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 1.0,
      color: colorScheme.sectionContainerLightScheme,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.sectionContainerLightScheme,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: DropdownMenu<String>(
          initialSelection: selectedFrequency,
          onSelected: (String? value) {
            if (value != null) {
              context.homeBloc.add(HomeLoaded(newFrequency: value));
            }
          },
          dropdownMenuEntries: menuEntries,
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
