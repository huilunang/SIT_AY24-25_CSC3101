import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar show(BuildContext context, String message,
      {String type = ''}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final snackBarTheme = theme.snackBarTheme;

    Color? backgroundColor;
    Color? textColor;
    switch (type.toLowerCase()) {
      case 'error':
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        break;
      case 'success':
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      default:
        backgroundColor = snackBarTheme.backgroundColor;
        textColor = snackBarTheme.actionTextColor;
    }

    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
        textColor: textColor,
      ),
      duration: const Duration(milliseconds: 3000),
      // behavior: SnackBarBehavior.floating,
    );
  }
}
