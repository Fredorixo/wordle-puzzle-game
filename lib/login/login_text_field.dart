import "package:flutter/material.dart";

class LoginTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final bool isDisabled;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const LoginTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.isDisabled,
    this.obscureText = false,
    required this.keyboardType,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white60,
      ),
      child: TextField(
        enabled: !isDisabled,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffixIcon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
