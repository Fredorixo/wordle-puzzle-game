import "package:flutter/material.dart";
import "package:wordle/text_field_grid.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wordle App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome To Wordle"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: TextFieldGrid(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
