import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:wordle/animations/confetti_animation.dart";
import "package:wordle/backend/game.dart";
import "package:wordle/backend/riddle_word.dart";
import "package:wordle/constants/difficulty.dart";
import "package:wordle/constants/game_state.dart";
import "package:wordle/footer_buttons/instructions.dart";
import "package:wordle/footer_buttons/leaderboard.dart";
import "package:wordle/footer_buttons/settings.dart";
import "package:wordle/animations/loading_animation.dart";
import "package:wordle/home/action_button.dart";
import "package:wordle/home/points_flip_counter.dart";
import "package:wordle/home/text_field_grid.dart";

class HomeScreen extends StatefulWidget {
  final void Function() changeTheme;
  final bool hasLightTheme;

  const HomeScreen({
    Key? key,
    required this.changeTheme,
    required this.hasLightTheme,
  }) : super(key: key);

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

  void startLoading() {
    setState(() {
      _hasLoadingAnimation = true;
    });
  }

  void stopLoading() {
    setState(() {
      _hasLoadingAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, gameState) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.logout_rounded,
                semanticLabel: "Logout",
              ),
              tooltip: "Logout",
            ),
            leadingWidth: 35.0,
            title: const Text("Wordle Puzzle Game"),
            elevation: 1.0,
            actions: [
              Tooltip(
                message: gameState == GameState.begin
                    ? ""
                    : context.read<RiddleWordCubit>().state.riddle,
                preferBelow: true,
                triggerMode: TooltipTriggerMode.tap,
                padding: const EdgeInsets.all(7.5),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                showDuration: const Duration(seconds: 15),
                child: const Icon(
                  Icons.info_outline_rounded,
                ),
              ),
              ActionButton(
                letters: _letters,
                gameState: gameState,
                stopLoading: stopLoading,
                startLoading: startLoading,
                isDisabled: _hasLoadingAnimation,
              ),
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
                const PointsFlipCounter(),
                if (_hasLoadingAnimation) const LoadingAnimation(),
                if (gameState == GameState.win) const ConfettiAnimation()
              ],
            ),
          ),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LeaderBoard(
                  isDisabled: _hasLoadingAnimation,
                ),
                Instructions(
                  isDiabled: _hasLoadingAnimation,
                ),
                IconButton(
                  onPressed: _hasLoadingAnimation ? null : widget.changeTheme,
                  icon: Icon(
                    widget.hasLightTheme
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    semanticLabel: "Toggle Brightness",
                  ),
                  tooltip: "Toggle Brightness",
                ),
                Settings(
                  letters: _letters,
                  difficulty: _difficulty,
                  isDisabled: _hasLoadingAnimation,
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
