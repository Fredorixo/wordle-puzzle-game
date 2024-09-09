import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:provider/provider.dart";
import "package:wordle/app/theme.dart";
import "package:wordle/backend/backend.dart";
import "package:wordle/backend/game.dart";
import "package:wordle/backend/riddle_word.dart";
import "package:wordle/home/home_screen.dart";
import "package:wordle/login/login_screen.dart";

class WordleApp extends StatefulWidget {
  const WordleApp({Key? key}) : super(key: key);

  @override
  State<WordleApp> createState() => _WordleAppState();
}

class _WordleAppState extends State<WordleApp> {
  bool _hasLightTheme = true;

  void changeTheme() {
    setState(() {
      _hasLightTheme = !_hasLightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GameCubit()),
        BlocProvider(create: (_) => RiddleWordCubit()),
      ],
      child: Provider(
        create: (_) => Backend(),
        dispose: (_, Backend backend) => backend.client.close(),
        child: MaterialApp(
          title: "Wordle App",
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _hasLightTheme ? ThemeMode.light : ThemeMode.dark,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomeScreen(
                  hasLightTheme: _hasLightTheme,
                  changeTheme: changeTheme,
                );
              }

              return const LoginScreen();
            },
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
