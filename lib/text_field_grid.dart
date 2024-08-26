import "package:flutter/material.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/constants/outcome.dart";
import "package:wordle/text_field_tile.dart";

class TextFieldGrid extends StatefulWidget {
  final String word;
  final Difficulty difficulty;

  final Map<String, int> map = {};
  late final int tries;
  late final List<List<FocusNode>> nodes;
  late final List<List<Color>> fillColors;
  late final List<bool> isReadOnly;
  late final List<List<TextEditingController>> controllers;
  late final List<Color> textColors;

  TextFieldGrid({
    Key? key,
    required this.word,
    required this.difficulty,
  }) : super(key: key) {
    for (int i = 0; i < word.length; ++i) {
      map[word[i]] = map.containsKey(word[i]) ? map[word[i]]! + 1 : 1;
    }

    tries = attempts[difficulty]!;

    controllers = List.generate(
      tries,
      (_) => List.generate(
        word.length,
        (_) => TextEditingController(),
        growable: false,
      ),
      growable: false,
    );

    nodes = List.generate(
      tries,
      (_) => List.generate(
        word.length,
        (_) => FocusNode(),
        growable: false,
      ),
      growable: false,
    );

    fillColors = List.generate(
      tries,
      (_) => List.filled(
        word.length,
        Colors.white70,
      ),
      growable: false,
    );

    isReadOnly = List.filled(tries, false);
    textColors = List.filled(tries, Colors.black);
  }

  @override
  State<TextFieldGrid> createState() => _TextFieldGridState();
}

class _TextFieldGridState extends State<TextFieldGrid> {
  @override
  void dispose() {
    for (int i = 0; i < widget.tries; ++i) {
      for (int j = 0; j < widget.word.length; ++j) {
        widget.controllers[i][j].dispose();
        widget.nodes[i][j].dispose();
      }
    }

    super.dispose();
  }

  void decreaseCount(final String ch, final Map<String, int> count) {
    count[ch] = count[ch]! - 1;

    if (count[ch] == 0) {
      count.remove(ch);
    }
  }

  // Function to validate the word on submission
  List<Outcome> validate(String guess) {
    final Map<String, int> count = {};
    final List<Outcome> result =
        List.filled(widget.word.length, Outcome.incorrect);

    widget.map.forEach((key, value) {
      count[key] = value;
    });

    // Resolve exact matches
    for (int i = 0; i < widget.word.length; ++i) {
      if (guess[i] == widget.word[i]) {
        result[i] = Outcome.correct;
        decreaseCount(guess[i], count);
      }
    }

    // Resolve correct but not exact matches
    for (int i = 0; i < widget.word.length; ++i) {
      if (result[i] == Outcome.incorrect && count.containsKey(guess[i])) {
        result[i] = Outcome.partiallyCorrect;
        decreaseCount(guess[i], count);
      }
    }

    return result;
  }

  // Function to activate on submission
  void onSubmit(int row) {
    String guess = "";

    for (final TextEditingController controller in widget.controllers[row]) {
      guess = guess + controller.text;
    }

    // Alert the user if the guess is too short
    if (guess.length < widget.word.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Word is Too Short",
            style: TextStyle(
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.shade600,
        ),
      );

      return;
    }

    List<Outcome> outcomes = validate(guess);

    setState(() {
      for (int j = 0; j < widget.word.length; ++j) {
        if (outcomes[j] == Outcome.correct) {
          widget.fillColors[row][j] = Colors.lightGreen.shade600;
        } else if (outcomes[j] == Outcome.partiallyCorrect) {
          widget.fillColors[row][j] = Colors.yellow.shade700;
        } else {
          widget.fillColors[row][j] = Colors.grey;
        }
      }

      widget.textColors[row] = Colors.white;
      widget.isReadOnly[row] = true;
    });
  }

  // Search the intended position for editing
  FocusNode? searchEditingPosition() {
    for (int i = 0; i < widget.tries; ++i) {
      if (widget.isReadOnly[i] == false) {
        for (int j = 0; j < widget.word.length; ++j) {
          if (widget.controllers[i][j].text.isEmpty) {
            return widget.nodes[i][j];
          }
        }

        return widget.nodes[i].last;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5.0,
      crossAxisCount: widget.word.length,
      children: [
        for (int i = 0; i < widget.tries; ++i)
          for (int j = 0; j < widget.word.length; ++j)
            TextFieldTile(
              onSubmit: () => onSubmit(i),
              onTap: searchEditingPosition,
              controller: widget.controllers[i][j],
              focusNode: widget.nodes[i][j],
              backward: j > 0 ? widget.nodes[i][j - 1] : null,
              forward:
                  j + 1 < widget.word.length ? widget.nodes[i][j + 1] : null,
              backController: j > 0 ? widget.controllers[i][j - 1] : null,
              isReadOnly: widget.isReadOnly[i],
              fillColor: widget.fillColors[i][j],
              textColor: widget.textColors[i],
            )
      ],
    );
  }
}
