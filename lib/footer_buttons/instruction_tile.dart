import "package:flutter/material.dart";
import "package:wordle/app/dimensions.dart";

class InstructionTile extends StatelessWidget {
  final Color color;
  final String message;

  const InstructionTile({
    Key? key,
    required this.color,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.square_rounded,
        color: color,
      ),
      title: Text(
        message,
        style: TextStyle(
          fontSize: Dimensions.bottomSheetSubtitleFontSize,
        ),
      ),
    );
  }
}
