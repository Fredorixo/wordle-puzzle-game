import "package:flutter/material.dart";

class IconTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final MainAxisAlignment mainAxisAlignment;

  const IconTitle({
    Key? key,
    required this.title,
    required this.icon,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5.0),
        Icon(icon),
      ],
    );
  }
}
