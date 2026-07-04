import 'package:flutter/material.dart';

import '../shared/custom_button.dart';
import '../shared/custom_text_filed.dart';
import 'login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 64),

                CustomTextFiled(
                  TextInputTypee: TextInputType.text,
                  isPassword: false,
                  hinttextt: 'Enter your Username',
                ),

                const SizedBox(height: 36),

                CustomTextFiled(
                  TextInputTypee: TextInputType.emailAddress,
                  isPassword: false,
                  hinttextt: 'Enter your email',
                ),

                const SizedBox(height: 36),

                CustomTextFiled(
                  TextInputTypee: TextInputType.text,
                  isPassword: true,
                  hinttextt: 'Enter your password',
                ),

                const SizedBox(height: 36),

                CustomButton(
                  text: 'Register', onPressed: () {  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.black),
                      ),
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