import "package:flutter/material.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/constants/outcome.dart";
import "package:wordle/text_field_tile.dart";

class TextFieldGrid extends StatefulWidget {
  final String word;
  final Difficulty difficulty;
  final Map<String, int> map = {};

  TextFieldGrid({
    Key? key,
    required this.word,
    required this.difficulty,
  }) : super(key: key) {
    for (int i = 0; i < word.length; ++i) {
      map[word[i]] = map.containsKey(word[i]) ? map[word[i]]! + 1 : 1;
    }
  }

  @override
  State<TextFieldGrid> createState() => _TextFieldGridState();
}

class _TextFieldGridState extends State<TextFieldGrid> {
  late final int tries;
  late final List<List<FocusNode>> nodes;
  late List<List<Color>> fillColors;
  late final List<bool> isReadOnly;
  late final List<List<TextEditingController>> controllers;
  late final List<Color> textColors;

  @override
  void initState() {
    super.initState();
    tries = attempts[widget.difficulty]!;

    controllers = List.generate(
      tries,
      (_) => List.generate(
        widget.word.length,
        (_) => TextEditingController(),
        growable: false,
      ),
      growable: false,
    );

    nodes = List.generate(
      tries,
      (_) => List.generate(
        widget.word.length,
        (_) => FocusNode(),
        growable: false,
      ),
      growable: false,
    );

    fillColors = List.generate(
      tries,
      (_) => List.filled(
        widget.word.length,
        Colors.white70,
      ),
      growable: false,
    );

    isReadOnly = List.filled(tries, false);
    textColors = List.filled(tries, Colors.black);
  }

  @override
  void dispose() {
    for (int i = 0; i < tries; ++i) {
      for (int j = 0; j < widget.word.length; ++j) {
        controllers[i][j].dispose();
        nodes[i][j].dispose();
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

    for (final TextEditingController controller in controllers[row]) {
      guess = guess + controller.text;
    }

    // Alert the user if the guess is too short
    if (guess.length < widget.word.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Word is Too Short"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "OK"),
              child: const Text("OK"),
            )
          ],
        ),
      );

      return;
    }

    List<Outcome> outcomes = validate(guess);
    List<List<Color>> updatedColors = fillColors;

    for (int j = 0; j < widget.word.length; ++j) {
      if (outcomes[j] == Outcome.correct) {
        updatedColors[row][j] = Colors.lightGreen.shade600;
      } else if (outcomes[j] == Outcome.partiallyCorrect) {
        updatedColors[row][j] = Colors.yellow.shade700;
      } else {
        updatedColors[row][j] = Colors.grey;
      }
    }

    setState(() {
      fillColors = updatedColors;
      textColors[row] = Colors.white;
      isReadOnly[row] = true;
    });
  }

  // Search the intended position for editing
  FocusNode? searchEditingPosition() {
    for (int i = 0; i < tries; ++i) {
      if (isReadOnly[i] == false) {
        for (int j = 0; j < widget.word.length; ++j) {
          if (controllers[i][j].text.isEmpty) {
            return nodes[i][j];
          }
        }

        return nodes[i].last;
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
        for (int i = 0; i < tries; ++i)
          for (int j = 0; j < widget.word.length; ++j)
            TextFieldTile(
              onSubmit: () => onSubmit(i),
              onTap: searchEditingPosition,
              controller: controllers[i][j],
              focusNode: nodes[i][j],
              backward: j > 0 ? nodes[i][j - 1] : null,
              forward: j + 1 < widget.word.length ? nodes[i][j + 1] : null,
              backController: j > 0 ? controllers[i][j - 1] : null,
              isReadOnly: isReadOnly[i],
              fillColor: fillColors[i][j],
              textColor: textColors[i],
            )
      ],
    );
  }
}
