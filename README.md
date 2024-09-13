# Wordle Puzzle Game

<br />
<div align="center">
    <img src="assets/images/wordle_logo.png" style="background-color: white; border-radius: 100%" />

  <br />
  <br />

  <p align="center">
    <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" />
    <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" />
    <img src="https://img.shields.io/badge/firebase-a08021?style=for-the-badge&logo=firebase&logoColor=ffcd34" />
    <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
    <img src="https://img.shields.io/badge/Gradle-02303A.svg?style=for-the-badge&logo=Gradle&logoColor=white" />
    <img src="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white" />
    <img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" />
  </p>
</div>

## Introduction

An app made on the popular game Wordle, where the hidden word has to be figured out in a given set of attempts.

## Features

Unlike the standard version, where the first guess is random, and the number of attempts are fixed for a total of 6. Here, we've:

- Generation of a random word along with a helping riddle, created with the help of Gemini API.

- 3 Modes of difficulty to choose from: Easy, Medium, Hard.

With increasing difficulty, your number of attempts reduces and points gained increases.

Sounds Exciting? Why not try it out yourself!.

## Environment Variables

To run this project, you will need to add environment variables to your .env file. Refer to .env.example file for more clarity.

## Run Locally

Clone the project

```bash
  git clone https://github.com/Fredorixo/wordle-puzzle-game.git
```

Go to the project directory

```bash
  cd wordle-puzzle-game
```

Install dependencies

```bash
  flutter pub get
```

Start the server

```bash
  flutter run
```

Include your environment variables, using --dart-define flag

```bash
  flutter run --dart-define=
```

## APK Generation

Generate the apk file for the app

```bash
  flutter build apk --split-per-abi
```

## Learnings

- State management in Flutter using BLoC(Business Logic Component) and Provider.

- Encompassing animations in the app using Lottie and other packages.

- Exception handling using try-catch and try-on-catch blocks.

- Interacting with FirebaseAuth for authentication and Firestore for user data storage.

- Using TextEditingController and FocusNode for controlling the flow of access.

- Exploring various layout and input widgets in the Flutter ecosystem.

- Maintaining the light and dark theme of the app using ThemeData.

- Working with Stream and StreamBuilder to route between Login and Home Screens based on user status.

- Grabbing user attention through SnackBar and AlertDialog widgets.

- Re-imagining the launcher icon of the app.

- Creating various GameStates for the application using BLoC, and rebuilding UI using BlocBuilder.