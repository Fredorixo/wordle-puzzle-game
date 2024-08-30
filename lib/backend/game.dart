import "package:flutter_bloc/flutter_bloc.dart";
import "package:wordle/constants/game_state.dart";

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.begin);

  void changeGameState(GameState gameState) {
    emit(gameState);
  }
}
