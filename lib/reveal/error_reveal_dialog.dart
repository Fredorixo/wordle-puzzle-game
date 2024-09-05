import "package:flutter/material.dart";
import "package:wordle/reveal/reveal_dialog.dart";

class ErrorRevealDialog extends StatelessWidget {
  const ErrorRevealDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RevealDialog(
      title: "Error",
      message: "An unexpected error occurred, please try again later.",
      icon: Icons.error_outline_rounded,
      color: Colors.red.shade400,
    );
  }
}
