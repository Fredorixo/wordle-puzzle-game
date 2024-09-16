import "dart:io";
import "dart:convert";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_web_auth/flutter_web_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:http/http.dart" as http;
import "package:twitter_login/twitter_login.dart";
import "package:wordle/constants/difficulty.dart";

class Backend {
  final client = http.Client();

  // Get the RiddleWord from AI
  Future<RiddleWord> getRiddleWord({
    required int letters,
    required Difficulty difficulty,
  }) async {
    final Uri _url = Uri.https(
      "generativelanguage.googleapis.com",
      "/v1beta/models/gemini-1.5-flash:generateContent",
      {
        "key": const String.fromEnvironment("GOOGLE_API_KEY"),
      },
    );

    final String _body = jsonEncode(
      {
        "contents": [
          {
            "parts": [
              {
                "text": """
                  Return a random $letters-letter word with ${title[difficulty]} difficulty
                  and a corresponding riddle to identify it.
                  Use the following JSON Schema to written the data:
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

  // Get the top 4 scorers from the database
  Stream<List<Map<String, dynamic>>> get topScorers {
    return FirebaseFirestore.instance
        .collection("users")
        .orderBy("points", descending: true)
        .limit(4)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) => document.data()).toList();
    });
  }

  // Sign in with Email and Password
  Future<void> signInWithEmailAndPassword({
    required String emailId,
    required String passwordId,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailId,
        password: passwordId,
      );
    } on FirebaseAuthException catch (error) {
      // If no account is found, create an account
      if (error.code == "user-not-found") {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailId,
          password: passwordId,
        );

        // Sign in after successful account creation
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailId,
          password: passwordId,
        );
      }

      // For other cases, show errror message
      rethrow;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(code: "sign-in-aborted");
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sign in with Twitter
  Future<void> signInWithTwitter() async {
    final twitterUser = await TwitterLogin(
      apiKey: const String.fromEnvironment("TWITTER_API_KEY"),
      apiSecretKey: const String.fromEnvironment("TWITTER_API_KEY_SECRET"),
      redirectURI: const String.fromEnvironment("REDIRECT_URI"),
    ).login();

    if (twitterUser.status == TwitterLoginStatus.cancelledByUser) {
      throw FirebaseAuthException(code: "sign-in-aborted");
    }

    if (twitterUser.status == TwitterLoginStatus.error) {
      throw FirebaseAuthException(code: "sign-in-error");
    }

    final credential = TwitterAuthProvider.credential(
      accessToken: twitterUser.authToken!,
      secret: twitterUser.authTokenSecret!,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sign in with Github
  Future<void> signInWithGithub() async {
    String clientId = const String.fromEnvironment("GITHUB_CLIENT_ID");
    String clientSecret = const String.fromEnvironment("GITHUB_CLIENT_SECRET");
    String callbackUrlScheme = const String.fromEnvironment("REDIRECT_URI");

    final url = Uri.https(
      "github.com",
      "/login/oauth/authorize",
      {
        "client_id": clientId,
        "redirect_uri": callbackUrlScheme,
        "scope": "read:user",
      },
    );

    // Present the dialog to the user
    final result = await FlutterWebAuth.authenticate(
      url: url.toString(),
      callbackUrlScheme: const String.fromEnvironment("URL_SCHEME"),
    );

    // Extract code from resulting url
    final code = Uri.parse(result).queryParameters["code"];

    // Use this code to get an access token
    final response = await http.post(
      Uri.parse("https://github.com/login/oauth/access_token"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "client_id": clientId,
        "client_secret": clientSecret,
        "redirect_uri": callbackUrlScheme,
        "code": code,
      }),
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(code: "sign-in-error");
    }

    // Get the access token from the response
    final accessToken = jsonDecode(response.body)["access_token"] as String;
    final credential = GithubAuthProvider.credential(accessToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
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
