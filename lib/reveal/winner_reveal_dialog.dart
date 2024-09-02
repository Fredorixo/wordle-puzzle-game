import "package:flutter/material.dart";
import "package:wordle/reveal/reveal_dialog.dart";

class WinnerRevealDialog extends StatelessWidget {
  const WinnerRevealDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RevealDialog(
      title: "Congratulations",
      message: "You were able to successfully guess the word.",
      icon: Icons.celebration_rounded,
    );
  }
}
