import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/core/theme/app_text_style.dart';
import 'package:ecommerceapp/core/utils/app_snackbar.dart';
import 'package:ecommerceapp/core/widgets/app_button.dart';
import 'package:ecommerceapp/core/widgets/app_text_field.dart';
import 'package:ecommerceapp/features/admin/screens/admin_home.dart';
import 'package:ecommerceapp/features/authentication/screens/register_screen.dart';
import 'package:ecommerceapp/features/main/screens/main_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceapp/core/notifications/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String screenRoute = AppConstants.loginRoute;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await NotificationService.saveToken(
        credential.user!.uid,
      );

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .get();

      final role = doc.data()?['role'];

      if (!mounted) return;

      if (role == AppConstants.adminRole) {
        Navigator.pushReplacementNamed(
          context,
          AdminHome.screenRoute,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          MainScreen.screenRoute,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      AppSnackBar.error(
        context,
        e.message ??
            AppLocalizations.of(context)!.somethingWentWrong,
      );
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.error(
        context,
        AppLocalizations.of(context)!.unexpectedError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  l10n.welcomeBack,
                  style: AppTextStyles.heading,
                ),

                const SizedBox(height: 40),

                AppTextField(
                  controller: _emailController,
                  hintText: l10n.enterYourEmail,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: _passwordController,
                  hintText: l10n.enterYourPassword,
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                AppButton(
                  text: l10n.signIn,
                  onPressed: _login,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAnAccount,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RegisterScreen.screenRoute,
                        );
                      },
                      child: Text(l10n.signUp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}