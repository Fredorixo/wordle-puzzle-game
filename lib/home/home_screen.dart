import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:wordle/backend/backend.dart";
import "package:wordle/backend/game.dart";
import "package:wordle/backend/riddle_word.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/constants/game_state.dart";
import "package:wordle/footer_buttons/instructions.dart";
import "package:wordle/footer_buttons/settings.dart";
import "package:wordle/home/loading_animation.dart";
import "package:wordle/home/text_field_grid.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _letters = 3;
  bool _hasLoadingAnimation = false;
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
                        setState(() {
                          _hasLoadingAnimation = true;
                        });

                        // Get the riddle-word from the backend
                        final RiddleWord _riddleWord =
                            await context.read<Backend>().getRiddleWord();

                        // Update the riddle-word
                        context
                            .read<RiddleWordCubit>()
                            .updateRiddleWord(_riddleWord);

                        // Conclude the loading animation
                        await Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            _hasLoadingAnimation = false;
                          });
                        });

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
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                TextFieldGrid(
                  letters: _letters,
                  difficulty: _difficulty,
                  isEnabled: gameState == GameState.playing,
                ),
                if (_hasLoadingAnimation) const LoadingAnimation(),
              ],
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
                const Instructions(),
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
