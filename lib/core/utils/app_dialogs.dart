import 'package:flutter/material.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool> confirmDelete(
      BuildContext context, {
        String? title,
        String? message,
      }) async {
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? l10n.delete),
          content: Text(message ?? l10n.deleteConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<bool> confirmLogout(
      BuildContext context,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(l10n.exit),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}