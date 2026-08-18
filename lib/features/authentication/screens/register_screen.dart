import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/core/theme/app_text_style.dart';
import 'package:ecommerceapp/core/utils/app_snackbar.dart';
import 'package:ecommerceapp/core/widgets/app_button.dart';
import 'package:ecommerceapp/core/widgets/app_text_field.dart';
import 'package:ecommerceapp/features/authentication/screens/login_screen.dart';
import 'package:ecommerceapp/features/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceapp/core/notifications/notification_service.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String screenRoute = AppConstants.registerRoute;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': AppConstants.userRole,
      });
      await NotificationService.saveToken(
        credential.user!.uid,
      );

      if (!mounted) return;

      AppSnackBar.success(context, 'Account created successfully');

      Navigator.pushReplacementNamed(context, HomeScreen.screenRoute);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      AppSnackBar.error(context, e.message ?? 'Something went wrong');
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.error(context, 'Unexpected error');
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Create Account", style: AppTextStyles.heading),

                  const SizedBox(height: 40),

                  AppTextField(
                    controller: _usernameController,
                    hintText: 'username',
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return 'username';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _emailController,
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return "Enter your email";
                      }
                      if (!value.contains('@')) {
                        return "Enter your email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _passwordController,
                    hintText: "Enter your password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your password";
                      }

                      if (value.length < 6) {
                        return "Enter your password";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  AppButton(
                    text: "Register",
                    onPressed: _register,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.screenRoute);
                        },
                        child: const Text("Sign in"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
