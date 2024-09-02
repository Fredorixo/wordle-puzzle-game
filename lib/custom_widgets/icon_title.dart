import "package:flutter/material.dart";
import "package:wordle/app/dimensions.dart";

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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Dimensions.bottomSheetTitleFontSize,
          ),
        ),
        const SizedBox(width: 5.0),
        Icon(icon),
      ],
    );
  }
}
