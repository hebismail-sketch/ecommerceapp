import 'package:ecommerceapp/core/settings/app_settings.dart';
import 'package:ecommerceapp/features/authentication/presentation/pages/login_page.dart';
import 'package:ecommerceapp/features/settings/screens/about_app_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String screenRoute = 'settings';

  // ============================================================
  // Logout Dialog
  // ============================================================

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.logout,
          ),
          content: Text(
            l10n.logoutConfirmation,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.cancel,
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginPage.screenRoute,
                      (route) => false,
                );
              },
              child: Text(
                l10n.logout,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ======================================================
          // General Section
          // ======================================================

          Text(
            l10n.general,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // Language
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              subtitle: Text(
                settings.locale.languageCode == 'ar'
                    ? l10n.arabic
                    : l10n.english,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
          ),

          const SizedBox(height: 10),

          // Theme
          Card(
            child: ListTile(
              leading: Icon(
                settings.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title: Text(l10n.appearance),
              subtitle: Text(
                settings.themeMode == ThemeMode.dark
                    ? l10n.darkMode
                    : l10n.lightMode,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () {
                _showThemeDialog(context);
              },
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // Account Section
          // ======================================================

          Text(
            l10n.account,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // Notifications
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.notifications_outlined,
              ),
              title: Text(l10n.notifications),
              trailing: Switch(
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  context
                      .read<AppSettings>()
                      .changeNotifications(value);
                },
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // About App Section
          // ======================================================

          Text(
            l10n.aboutApp,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // About App
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: Text(l10n.aboutApp),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AboutAppScreen.screenRoute,
                );
              },
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // Logout
          // ======================================================

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(l10n.logout),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// Language Dialog
// ==================================================================

void _showLanguageDialog(BuildContext context) {
  final settings = context.read<AppSettings>();
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.chooseLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Arabic
            RadioListTile<String>(
              value: 'ar',
              title: Text(l10n.arabic),
              groupValue: settings.locale.languageCode,
              onChanged: (value) {
                if (value == null) return;

                settings.changeLanguage(value);

                Navigator.pop(dialogContext);
              },
            ),

            // English
            RadioListTile<String>(
              value: 'en',
              title: Text(l10n.english),
              groupValue: settings.locale.languageCode,
              onChanged: (value) {
                if (value == null) return;

                settings.changeLanguage(value);

                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      );
    },
  );
}

// ==================================================================
// Theme Dialog
// ==================================================================

void _showThemeDialog(BuildContext context) {
  final settings = context.read<AppSettings>();
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.chooseTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Light Mode
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              title: Text(l10n.lightMode),
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value == null) return;

                settings.changeTheme(value);

                Navigator.pop(dialogContext);
              },
            ),

            // Dark Mode
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              title: Text(l10n.darkMode),
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value == null) return;

                settings.changeTheme(value);

                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      );
    },
  );
}