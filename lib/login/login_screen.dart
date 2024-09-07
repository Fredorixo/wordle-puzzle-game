import "package:flutter/material.dart";
import "package:wordle/login/login_button.dart";
import "package:wordle/login/login_text_field.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Wordle Puzzle Game",
                style: TextStyle(
                  color: Colors.deepPurple.shade400,
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 45.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.center,
                children: const [
                  LoginButton(
                    title: "Google",
                    assetName: "google_logo",
                  ),
                  LoginButton(
                    title: "Meta",
                    assetName: "meta_logo",
                  ),
                  LoginButton(
                    title: "Github",
                    assetName: "github_logo",
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              const Text(
                "OR",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25.0),
              const LoginTextField(
                icon: Icons.email_rounded,
                hintText: "Email",
              ),
              const SizedBox(height: 5.0),
              const LoginTextField(
                icon: Icons.password_rounded,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 5.0),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
