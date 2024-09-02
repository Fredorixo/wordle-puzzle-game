import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:wordle/app/color_schemes.dart";
import "package:wordle/app/dimensions.dart";
import "package:wordle/backend/game.dart";
import "package:wordle/backend/riddle_word.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/constants/game_state.dart";
import "package:wordle/constants/outcome.dart";
import "package:wordle/home/text_field_tile.dart";
import "package:wordle/reveal/loser_reveal_dialog.dart";
import "package:wordle/reveal/winner_reveal_dialog.dart";

class TextFieldGrid extends StatefulWidget {
  final int letters;
  final Difficulty difficulty;
  final bool isEnabled;
  late final int tries;

  TextFieldGrid({
    Key? key,
    required this.letters,
    required this.difficulty,
    required this.isEnabled,
  }) : super(key: key) {
    tries = attempts[difficulty]!;
  }

  @override
  State<TextFieldGrid> createState() => _TextFieldGridState();
}

class _TextFieldGridState extends State<TextFieldGrid> {
  late List<bool> _isReadOnly;
  late List<Color> _textColors;
  late List<List<FocusNode>> _nodes;
  late List<List<Color>> _fillColors;
  late List<List<TextEditingController>> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.tries,
      (_) => List.generate(
        widget.letters,
        (_) => TextEditingController(),
        growable: false,
      ),
      growable: false,
    );

    _nodes = List.generate(
      widget.tries,
      (_) => List.generate(
        widget.letters,
        (_) => FocusNode(),
        growable: false,
      ),
      growable: false,
    );

    _fillColors = List.generate(
      widget.tries,
      (_) => List.filled(
        widget.letters,
        Colors.white70,
      ),
      growable: false,
    );

    _isReadOnly = List.filled(widget.tries, false);
    _textColors = List.filled(widget.tries, Colors.black);
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.tries; ++i) {
      for (int j = 0; j < widget.letters; ++j) {
        _controllers[i][j].dispose();
        _nodes[i][j].dispose();
      }
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TextFieldGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool isChanged = oldWidget.tries != widget.tries ||
        oldWidget.letters != widget.letters ||
        (oldWidget.isEnabled == false && widget.isEnabled == true);

    if (isChanged) {
      _controllers = List.generate(
        widget.tries,
        (_) => List.generate(
          widget.letters,
          (_) => TextEditingController(),
          growable: false,
        ),
        growable: false,
      );

      _nodes = List.generate(
        widget.tries,
        (_) => List.generate(
          widget.letters,
          (_) => FocusNode(),
          growable: false,
        ),
        growable: false,
      );

      _fillColors = List.generate(
        widget.tries,
        (_) => List.filled(
          widget.letters,
          Colors.white70,
        ),
        growable: false,
      );

      _isReadOnly = List.filled(widget.tries, false);
      _textColors = List.filled(widget.tries, Colors.black);
    }
  }

  // Flash a reveal dialog on the screen
  void showWinnerRevealDialog() {
    showDialog(
      context: context,
      builder: (_) => const WinnerRevealDialog(),
    );
  }

  void showLoserRevealDialog(String word) {
    showDialog(
      context: context,
      builder: (_) => LoserRevealDialog(
        result: word,
      ),
    );
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
    final List<Outcome> result = List.filled(widget.letters, Outcome.incorrect);

    // Access the frequency map here
    context.read<RiddleWordCubit>().map.forEach((key, value) {
      count[key] = value;
    });

    // Access the word generated through the backend
    final String word = context.read<RiddleWordCubit>().state.word!;

    // Resolve exact matches
    for (int i = 0; i < widget.letters; ++i) {
      if (guess[i] == word[i]) {
        result[i] = Outcome.correct;
        decreaseCount(guess[i], count);
      }
    }

    // Resolve correct but not exact matches
    for (int i = 0; i < widget.letters; ++i) {
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

    for (final TextEditingController controller in _controllers[row]) {
      guess = guess + controller.text;
    }

    // Alert the user if the guess is too short
    if (guess.length < widget.letters) {
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

    bool isCorrect = true;

    for (int j = 0; j < widget.letters; ++j) {
      if (outcomes[j] != Outcome.correct) {
        isCorrect = false;
      }
    }

    if (isCorrect) {
      // If the guess was correct
      context.read<GameCubit>().changeGameState(GameState.win);
      showWinnerRevealDialog();
    } else if (row == widget.tries - 1) {
      // If this was the last unsuccessful attempt
      context.read<GameCubit>().changeGameState(GameState.complete);
      showLoserRevealDialog(context.read<RiddleWordCubit>().state.word!);
    }

    setState(() {
      for (int j = 0; j < widget.letters; ++j) {
        if (outcomes[j] == Outcome.correct) {
          _fillColors[row][j] = ColorSchemes.correctColor;
        } else if (outcomes[j] == Outcome.partiallyCorrect) {
          _fillColors[row][j] = ColorSchemes.partiallyCorrectColor;
        } else {
          _fillColors[row][j] = ColorSchemes.incorrectColor;
        }
      }

      _textColors[row] = Colors.white;
      _isReadOnly[row] = true;
    });
  }

  // Search the intended position for editing
  FocusNode? searchEditingPosition() {
    for (int i = 0; i < widget.tries; ++i) {
      if (_isReadOnly[i] == false) {
        for (int j = 0; j < widget.letters; ++j) {
          if (_controllers[i][j].text.isEmpty) {
            return _nodes[i][j];
          }
        }

        return _nodes[i].last;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        left: 15.0,
        right: 15.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.letters * Dimensions.tileSideLength +
                (widget.letters - 1) * Dimensions.tileGap,
          ),
          child: GridView.count(
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            crossAxisCount: widget.letters,
            children: [
              for (int i = 0; i < widget.tries; ++i)
                for (int j = 0; j < widget.letters; ++j)
                  TextFieldTile(
                    onSubmit: () => onSubmit(i),
                    onTap: searchEditingPosition,
                    isEnabled: widget.isEnabled,
                    controller: _controllers[i][j],
                    focusNode: _nodes[i][j],
                    backward: j > 0 ? _nodes[i][j - 1] : null,
                    forward: j + 1 < widget.letters ? _nodes[i][j + 1] : null,
                    backController: j > 0 ? _controllers[i][j - 1] : null,
                    isReadOnly: _isReadOnly[i],
                    fillColor: _fillColors[i][j],
                    textColor: _textColors[i],
                  )
            ],
          ),
        ),
      ),
    );
  }
}
