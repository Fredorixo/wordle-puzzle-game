import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:wordle/login/login_button.dart";
import "package:wordle/login/login_text_field.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController email;
  late final TextEditingController password;

  bool _isLoading = false;

  void startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  String errorCodeToReadableMessage(String errorCode) {
    return errorCode
        .split("-")
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(" ");
  }

  void showErrorMessage(String errorCode) {
    String message = errorCodeToReadableMessage(errorCode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.deepPurple.shade400,
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Please enter your details to sign in",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    children: [
                      LoginButton(
                        onPressed: _isLoading ? null : () {},
                        assetName: "apple_logo",
                      ),
                      LoginButton(
                        onPressed: _isLoading ? null : () {},
                        assetName: "google_logo",
                      ),
                      LoginButton(
                        onPressed: _isLoading ? null : () {},
                        assetName: "twitter_logo",
                      ),
                      LoginButton(
                        onPressed: _isLoading ? null : () {},
                        assetName: "facebook_logo",
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
                  LoginTextField(
                    icon: Icons.email_rounded,
                    hintText: "Email",
                    controller: email,
                    isDisabled: _isLoading,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 5.0),
                  LoginTextField(
                    icon: Icons.password_rounded,
                    hintText: "Password",
                    isDisabled: _isLoading,
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 5.0),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            String emailId = email.text.trim();
                            String passwordId = password.text.trim();

                            startLoading();

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: emailId,
                                password: passwordId,
                              );
                            } on FirebaseAuthException catch (error) {
                              // If no account is found, create an account
                              if (error.code == "user-not-found") {
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: emailId,
                                    password: passwordId,
                                  );

                                  // Sign in after successful account creation
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: emailId,
                                    password: passwordId,
                                  );
                                } on FirebaseAuthException catch (error) {
                                  // For weak-passwords
                                  stopLoading();
                                  showErrorMessage(error.code);
                                }
                              }

                              // For other cases, show errror message
                              stopLoading();
                              showErrorMessage(error.code);
                            }
                          },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[350],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't want to sign up ?"),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  startLoading();
                                  await FirebaseAuth.instance
                                      .signInAnonymously();
                                },
                          child: Text(
                            "Go Anonymous",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black45,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple.shade400,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
