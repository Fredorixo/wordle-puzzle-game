import "package:flutter/material.dart";
import "package:wordle/app/color_schemes.dart";
import "package:wordle/custom_widgets/icon_title.dart";

class RevealDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const RevealDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
        decoration: BoxDecoration(
          color: ColorSchemes.headlineColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: IconTitle(
          title: title,
          icon: icon,
        ),
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
