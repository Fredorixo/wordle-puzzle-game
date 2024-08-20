import "package:flutter/material.dart";
import "package:wordle/wordle_text_field.dart";

class WordleGridView extends StatelessWidget {
  const WordleGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 4; ++i) const WordleTextField(),
      ],
    );
  }
}
