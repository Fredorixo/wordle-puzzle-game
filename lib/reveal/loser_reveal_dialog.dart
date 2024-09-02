import "package:flutter/material.dart";
import "package:wordle/reveal/reveal_dialog.dart";

class LoserRevealDialog extends StatelessWidget {
  final String result;

  const LoserRevealDialog({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RevealDialog(
      title: "Game Over",
      message: "The answer was ''$result''",
      icon: Icons.rocket_launch_rounded,
    );
  }
}
