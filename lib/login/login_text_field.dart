import "package:flutter/material.dart";

class LoginTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;

  const LoginTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
