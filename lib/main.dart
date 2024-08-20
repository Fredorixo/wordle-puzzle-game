import "package:flutter/material.dart";
import "package:wordle/text_field_row.dart";

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
        body: TextFieldRow(
          k: 6,
          word: "MOBILE",
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
