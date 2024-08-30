import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:wordle/backend/backend.dart";
import "package:wordle/backend/game.dart";
import "package:wordle/backend/riddle_word.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/constants/game_state.dart";
import "package:wordle/footer_buttons/settings.dart";
import "package:wordle/home/text_field_grid.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _letters = 3;
  Difficulty _difficulty = Difficulty.easy;

  void updateLetterCount(int letters) {
    setState(() {
      _letters = letters;
      context.read<GameCubit>().changeGameState(GameState.begin);
    });
  }

  void updateDifficulty(Difficulty difficulty) {
    setState(() {
      _difficulty = difficulty;
      context.read<GameCubit>().changeGameState(GameState.begin);
    });
  }

  Map<GameState, IconData> icons = {
    GameState.begin: Icons.play_circle_outline_rounded,
    GameState.playing: Icons.play_disabled_rounded,
    GameState.complete: Icons.replay_circle_filled_rounded,
    GameState.win: Icons.replay_circle_filled_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, gameState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Let's Play Wordle!"),
            actions: [
              Tooltip(
                message: gameState == GameState.begin
                    ? ""
                    : context.read<RiddleWordCubit>().state.riddle,
                preferBelow: true,
                child: const Icon(
                  Icons.info_outline_rounded,
                ),
              ),
              IconButton(
                onPressed: gameState == GameState.playing
                    ? null
                    : () async {
                        // Initiate the loading animation

                        // Get the riddle-word from the backend
                        final RiddleWord _riddleWord =
                            await context.read<Backend>().getWord();

                        // Update the riddle-word
                        context.read<RiddleWordCubit>().updateWord(_riddleWord);

                        // Conclude the loading animation

                        context
                            .read<GameCubit>()
                            .changeGameState(GameState.playing);
                      },
                icon: Icon(
                  icons[gameState],
                ),
              )
            ],
          ),
          body: SafeArea(
            child: TextFieldGrid(
              letters: _letters,
              difficulty: _difficulty,
              isEnabled: gameState == GameState.playing,
            ),
          ),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.leaderboard_rounded,
                    color: Colors.grey.shade700,
                    semanticLabel: "Leaderboard",
                  ),
                  tooltip: "Leaderboard",
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.help_rounded,
                    color: Colors.grey.shade700,
                    semanticLabel: "Guide",
                  ),
                  tooltip: "Guide",
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.dark_mode_rounded,
                    color: Colors.grey.shade700,
                    semanticLabel: "Toggle Brightness",
                  ),
                  tooltip: "Toggle Brightness",
                ),
                Settings(
                  letters: _letters,
                  difficulty: _difficulty,
                  updateDifficulty: updateDifficulty,
                  updateLetterCount: updateLetterCount,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
