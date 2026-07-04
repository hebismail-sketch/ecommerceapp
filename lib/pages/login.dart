import 'package:flutter/material.dart';

import '../shared/custom_button.dart';
import '../shared/custom_text_filed.dart';
import 'register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),

              const CustomTextFiled(
                TextInputTypee: TextInputType.emailAddress,
                isPassword: false,
                hinttextt: 'Enter your email',
              ),

              const SizedBox(height: 36),

              const CustomTextFiled(
                TextInputTypee: TextInputType.text,
                isPassword: true,
                hinttextt: 'Enter your password',
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: 'Sign in',
                onPressed: () {
                  // ضع هنا كود تسجيل الدخول
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Do not have an account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}