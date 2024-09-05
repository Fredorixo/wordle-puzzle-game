import "package:flutter/material.dart";
import "package:wordle/custom_widgets/icon_title.dart";

class RevealDialog extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final String message;

  const RevealDialog({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
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
