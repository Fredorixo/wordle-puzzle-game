import "package:flutter/material.dart";
import "package:wordle/constants/outcome.dart";
import "package:wordle/text_field_row.dart";

class TextFieldGrid extends StatelessWidget {
  final String word = "MOBILE";
  final Map<String, int> map = {};

  TextFieldGrid({Key? key}) : super(key: key) {
    for (int i = 0; i < word.length; ++i) {
      map[word[i]] = map.containsKey(word[i]) ? map[word[i]]! + 1 : 1;
    }
  }

  // Function to validate the word on submission
  void decreaseCount(final String ch, final Map<String, int> count) {
    count[ch] = count[ch]! - 1;

    if (count[ch] == 0) {
      count.remove(ch);
    }
  }

  List<Outcome> onSubmit(String guess) {
    // Replace with an alert notification
    assert(guess.length == word.length, "Word too short");

    final Map<String, int> count = {};
    final List<Outcome> result = List.filled(word.length, Outcome.incorrect);

    map.forEach((key, value) {
      count[key] = value;
    });

    // Resolve exact matches
    for (int i = 0; i < word.length; ++i) {
      if (guess[i] == word[i]) {
        result[i] = Outcome.correct;
        decreaseCount(guess[i], count);
      }
    }

    // Resolve correct but not exact matches
    for (int i = 0; i < word.length; ++i) {
      if (result[i] == Outcome.incorrect && count.containsKey(guess[i])) {
        result[i] = Outcome.partiallyCorrect;
        decreaseCount(guess[i], count);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 6; ++i)
          TextFieldRow(
            k: word.length,
            onSubmit: onSubmit,
          )
      ],
    );
  }
}
