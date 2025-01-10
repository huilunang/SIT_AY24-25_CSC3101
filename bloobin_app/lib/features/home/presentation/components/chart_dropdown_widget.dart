import 'dart:collection';

import 'package:bloobin_app/features/home/presentation/blocs/home_event.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

class ChartDropdownWidget extends StatelessWidget {
  const ChartDropdownWidget({super.key});

  static const List<String> dropdownOptions = ['Daily', 'Monthly'];
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    dropdownOptions
        .map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: DropdownMenu<String>(
          initialSelection: dropdownOptions.first,
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
