import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:wordle/backend/backend.dart";
import "package:wordle/backend/game.dart";
import "package:wordle/backend/riddle_word.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/constants/game_state.dart";
import "package:wordle/reveal/error_reveal_dialog.dart";

class ActionButton extends StatelessWidget {
  final int letters;
  final Difficulty difficulty;
  final bool isDisabled;
  final GameState gameState;
  final void Function() stopLoading;
  final void Function() startLoading;

  ActionButton({
    Key? key,
    required this.letters,
    required this.difficulty,
    required this.gameState,
    required this.isDisabled,
    required this.stopLoading,
    required this.startLoading,
  }) : super(key: key);

  final Map<GameState, IconData> icons = {
    GameState.begin: Icons.play_circle_outline_rounded,
    GameState.playing: Icons.play_disabled_rounded,
    GameState.complete: Icons.replay_circle_filled_rounded,
    GameState.win: Icons.replay_circle_filled_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: gameState == GameState.playing || isDisabled
          ? null
          : () async {
              // Initiate the loading animation
              startLoading();

              try {
                // Get the riddle-word from the backend
                final RiddleWord _riddleWord =
                    await context.read<Backend>().getRiddleWord(
                          letters: letters,
                          difficulty: difficulty,
                        );

                // Update the riddle-word
                context.read<RiddleWordCubit>().updateRiddleWord(_riddleWord);

                // Conclude the loading after 4 more seconds
                await Future.delayed(const Duration(seconds: 4), () {
                  stopLoading();
                });

                context.read<GameCubit>().changeGameState(GameState.playing);
              } on HttpException {
                // Stop the loading animation immediately
                stopLoading();

                // Alert the user with about the error
                Future.delayed(const Duration(seconds: 1), () {
                  showDialog(
                    context: context,
                    builder: (_) => const ErrorRevealDialog(),
                  );
                });
              }
            },
      icon: Icon(
        icons[gameState],
      ),
    );
  }
}
