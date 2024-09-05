class Backend {
  Future<RiddleWord> getRiddleWord(int letters) async {
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

  factory RiddleWord.fromJson(Map<String, String> json) {
    return RiddleWord(
      word: json["word"],
      riddle: json["riddle"],
    );
  }
}
