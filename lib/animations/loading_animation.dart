import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      child: ColoredBox(
        color: Colors.black45,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400.0,
          ),
          child: Lottie.asset(
            "assets/loading_animation.json",
          ),
        ),
      ),
    );
  }
}
