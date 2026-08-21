import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/core/theme/app_text_style.dart';
import 'package:ecommerceapp/core/utils/app_snackbar.dart';
import 'package:ecommerceapp/core/widgets/app_button.dart';
import 'package:ecommerceapp/core/widgets/app_text_field.dart';
import 'package:ecommerceapp/features/authentication/presentation/manager/authentication_bloc.dart';
import 'package:ecommerceapp/features/authentication/presentation/pages/login_page.dart';
import 'package:ecommerceapp/features/home/screens/home_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String screenRoute = AppConstants.registerRoute;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    // Trigger register event in BLoC
    context.read<AuthenticationBloc>().add(
          RegisterPressedEvent(
            email: email,
            password: password,
            username: username,
          ),
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
              AppSnackBar.success(
                context,
                l10n.accountCreatedSuccessfully,
              );
              Navigator.pushReplacementNamed(
                context,
                HomeScreen.screenRoute,
              );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  final isLoading = state is AuthenticationLoading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          l10n.createAccount,
                          style: AppTextStyles.heading,
                        ),
                        const SizedBox(height: 40),
                        AppTextField(
                          controller: _usernameController,
                          hintText: l10n.username,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.invalidUsername;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _emailController,
                          hintText: l10n.enterYourEmail,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.enterYourEmail;
                            }
                            if (!value.contains('@')) {
                              return l10n.invalidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _passwordController,
                          hintText: l10n.enterYourPassword,
                          obscureText: true,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.enterYourPassword;
                            }
                            if (value.length < 6) {
                              return l10n.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        AppButton(
                          text: l10n.register,
                          onPressed: isLoading ? null : _handleRegister,
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.alreadyHaveAnAccount),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pushNamed(
                                        context,
                                        LoginPage.screenRoute,
                                      );
                                    },
                              child: Text(l10n.signIn),
                            ),
                          ],
                        ),
                      ],
                    ),
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

