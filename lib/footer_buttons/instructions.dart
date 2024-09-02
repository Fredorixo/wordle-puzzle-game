import "package:flutter/material.dart";
import "package:wordle/app/color_schemes.dart";
import "package:wordle/app/dimensions.dart";
import "package:wordle/footer_buttons/footer_bottom_sheet.dart";
import "package:wordle/footer_buttons/instruction_tile.dart";

class Instructions extends StatelessWidget {
  const Instructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FooterBottomSheet(
      name: "Instructions",
      body: [
        Text(
          "You have to guess the hidden word in the given tries and the color of the tiles change to show how close you are.",
          style: TextStyle(
            fontSize: Dimensions.bottomSheetSubtitleFontSize,
          ),
          textAlign: TextAlign.justify,
        ),
        const Divider(),
        InstructionTile(
          color: ColorSchemes.correctColor,
          message: "Letter is in the word at the correct spot",
        ),
        InstructionTile(
          color: ColorSchemes.partiallyCorrectColor,
          message: "Letter is in the word but not at the correct spot",
        ),
        InstructionTile(
          color: ColorSchemes.incorrectColor,
          message: "Letter isn't in the word",
        ),
      ],
      titleIcon: Icons.library_books_rounded,
      displayIcon: Icons.help_rounded,
    );
  }
}
