import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:provider/provider.dart";
import "package:wordle/backend/backend.dart";
import "package:wordle/backend/game.dart";
import "package:wordle/backend/riddle_word.dart";
import "package:wordle/home/home_screen.dart";

class WordleApp extends StatelessWidget {
  const WordleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wordle App",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GameCubit()),
          BlocProvider(create: (_) => RiddleWordCubit()),
        ],
        child: Provider(
          create: (_) => Backend(),
          dispose: (_, Backend backend) => backend.client.close(),
          child: const HomeScreen(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
