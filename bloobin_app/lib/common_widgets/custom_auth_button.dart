import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomAuthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(
        buttonText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
