import "package:flutter_bloc/flutter_bloc.dart";
import "package:wordle/backend/backend.dart";

class RiddleWordCubit extends Cubit<RiddleWord> {
  RiddleWordCubit() : super(RiddleWord());

  final Map<String, int> map = {};

  void updateWord(RiddleWord riddleWord) {
    map.clear();

    riddleWord.word?.split("").forEach((ch) {
      map[ch] = map.containsKey(ch) ? map[ch]! + 1 : 1;
    });

    emit(riddleWord);
  }
}
