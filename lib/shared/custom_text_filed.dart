import 'package:flutter/material.dart';

class CustomTextFiled extends StatefulWidget {
  const CustomTextFiled({
    super.key,
    required this.TextInputTypee,
    required this.isPassword,
    required this.hinttextt,
  });

  final TextInputType TextInputTypee;
  final bool isPassword;
  final String hinttextt;

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  @override
  Widget build(BuildContext context) {
    return Container(margin:  EdgeInsets.all(16),
      child: TextField(
        keyboardType: widget.TextInputTypee,
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          hintText: widget.hinttextt,
          enabledBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}