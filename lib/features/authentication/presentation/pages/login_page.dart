import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/core/theme/app_text_style.dart';
import 'package:ecommerceapp/core/utils/app_snackbar.dart';
import 'package:ecommerceapp/core/widgets/app_button.dart';
import 'package:ecommerceapp/core/widgets/app_text_field.dart';
import 'package:ecommerceapp/features/admin/presentation/pages/admin_home.dart';
import 'package:ecommerceapp/features/authentication/presentation/manager/authentication_bloc.dart';
import 'package:ecommerceapp/features/authentication/presentation/pages/register_page.dart';
import 'package:ecommerceapp/features/main/presentation/pages/main_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String screenRoute = AppConstants.loginRoute;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.error(
        context,
        AppLocalizations.of(context)?.invalidCredentials ??
            'Please fill all fields',
      );
      return;
    }

    // Trigger login event in BLoC
    context.read<AuthenticationBloc>().add(
          LoginPressedEvent(email: email, password: password),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationError) {
              AppSnackBar.error(context, state.message);
            } else if (state is UserLoggedIn) {
              // Navigate based on user role
              final role = state.user.role;
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
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  final isLoading = state is AuthenticationLoading;

                  return Column(
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
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: _passwordController,
                        hintText: l10n.enterYourPassword,
                        obscureText: true,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 30),
                      AppButton(
                        text: l10n.signIn,
                        onPressed: isLoading ? null : _handleLogin,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.dontHaveAnAccount),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterPage.screenRoute,
                                    );
                                  },
                            child: Text(l10n.signUp),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

