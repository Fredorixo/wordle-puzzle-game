import "package:flutter/material.dart";

class LoginButton extends StatelessWidget {
  final String title;
  final String assetName;

  const LoginButton({
    Key? key,
    required this.title,
    required this.assetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  "assets/images/$assetName.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
