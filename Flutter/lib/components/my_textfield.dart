import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  final controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(context) {
    return SizedBox(
      width: 325,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          //Color(
          //int.parse("#e8ccfc".substring(1, 7), radix: 16) + 0xFF000000),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        ),
      ),
    );
  }
}
