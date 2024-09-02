class Backend {
  Future<RiddleWord> getRiddleWord() {
    return Future.value(
      RiddleWord(
        word: "DREAMS",
        riddle: "I come at night and leave by day",
      ),
    );
  }
}

class RiddleWord {
  final String? word;
  final String? riddle;

  RiddleWord({
    this.word,
    this.riddle,
  });
}
