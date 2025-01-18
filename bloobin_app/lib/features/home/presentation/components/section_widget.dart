import 'package:bloobin_app/theme/theme.dart';
import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final String? sectionTitle;
  final Widget? sectionHeader;
  final Widget sectionChild;

  const SectionWidget({
    super.key,
    this.sectionTitle,
    this.sectionHeader,
    required this.sectionChild,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionHeader != null)
          sectionHeader!
        else if (sectionTitle != null)
          Text(
            sectionTitle!,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.sectionContainerLightScheme,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: sectionChild,
          ),
        ),
      ],
    );
  }
}
