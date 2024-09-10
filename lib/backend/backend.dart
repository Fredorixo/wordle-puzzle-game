import "dart:io";
import "dart:convert";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:http/http.dart" as http;

class Backend {
  final client = http.Client();

  // Get the RiddleWord from AI
  Future<RiddleWord> getRiddleWord(int letters) async {
    final Uri _url = Uri.https(
      "generativelanguage.googleapis.com",
      "/v1beta/models/gemini-1.5-flash:generateContent",
      {
        "key": const String.fromEnvironment(
          "API_KEY",
          defaultValue: "API_KEY",
        ),
      },
    );

    final String _body = jsonEncode(
      {
        "contents": [
          {
            "parts": [
              {
                "text": """
                  Return a random $letters-letter word and a corresponding riddle
                  to identify it. Use the following JSON Schema to written the data:
                  RiddleWord = {"word": string, "riddle": string}
                  Return RiddleWord.
                """
              }
            ]
          }
        ]
      },
    );

    final response = await client.post(
      _url,
      headers: {
        "Content-Type": "application/json",
      },
      body: _body,
    );

    // If the request fails
    if (response.statusCode != 200) {
      throw HttpException(
        "${response.statusCode}: ${response.reasonPhrase}",
      );
    }

    // If the request succesfully executes
    // Extract the text information from the raw data
    final data = jsonDecode(response.body);
    final text = data["candidates"][0]["content"]["parts"][0]["text"];

    // Retrieve the data in between ```json and ```
    final RegExp exp = RegExp(r"```json([\s\S]*?)```");
    final RegExpMatch? match = exp.firstMatch(text);

    // Decode the retrieved json data
    String? json = match?.group(1);
    final result = jsonDecode(json!) as Map<String, dynamic>;

    return RiddleWord.fromJson(result);
  }

  // Get the progress of a user's points
  Stream<int> get points {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return 0;
      }

      return (snapshot.data()!["points"] as num).toInt();
    });
  }

  // Update the points for a user
  Future<void> updatePoints(int value) async {
    final int currentPoints = await points.first;
    final int updatedPoints = currentPoints + value;

    final User user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
      {
        "id": user.uid,
        "image": user.photoURL,
        "name": user.displayName ?? "Anonymous",
        "points": updatedPoints,
      },
    );
  }

  // Get the top 5 scorers from the database
  Stream<List<Map<String, dynamic>>> get topScorers {
    return FirebaseFirestore.instance
        .collection("users")
        .orderBy("points", descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) => document.data()).toList();
    });
  }
}

class RiddleWord {
  final String? word;
  final String? riddle;

  RiddleWord({
    this.word,
    this.riddle,
  });

  factory RiddleWord.fromJson(Map<String, dynamic> json) {
    return RiddleWord(
      word: (json["word"] as String).toUpperCase(),
      riddle: json["riddle"],
    );
  }
}
