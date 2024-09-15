import "package:flutter/material.dart";

class LoginButton extends StatelessWidget {
  final String assetName;
  final void Function()? onPressed;

  const LoginButton({
    Key? key,
    required this.assetName,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 32.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  "assets/images/$assetName.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
