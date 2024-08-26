import "package:flutter/material.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/footer_buttons/settings.dart";
import "package:wordle/text_field_grid.dart";

class WordleApp extends StatefulWidget {
  const WordleApp({Key? key}) : super(key: key);

  @override
  State<WordleApp> createState() => _WordleAppState();
}

class _WordleAppState extends State<WordleApp> {
  Difficulty _difficulty = Difficulty.easy;
  int _letters = 3;

  void updateLetterCount(int letters) {
    setState(() {
      _letters = letters;
    });
  }

  void updateDifficulty(Difficulty difficulty) {
    setState(() {
      _difficulty = difficulty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wordle App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Let's Play Wordle!"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: TextFieldGrid(
            word: "APPLE",
            difficulty: _difficulty,
          ),
        ),
        persistentFooterButtons: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.leaderboard_rounded,
              color: Colors.grey.shade700,
              semanticLabel: "Leaderboard",
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.help_rounded,
              color: Colors.grey.shade700,
              semanticLabel: "Help",
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.dark_mode_rounded,
              color: Colors.grey.shade700,
              semanticLabel: "Dark Mode",
            ),
          ),
          Settings(
            letters: _letters,
            difficulty: _difficulty,
            updateDifficulty: updateDifficulty,
            updateLetterCount: updateLetterCount,
          ),
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
