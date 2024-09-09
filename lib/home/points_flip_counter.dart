import "package:animated_flip_counter/animated_flip_counter.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/backend/backend.dart";

class PointsFlipCounter extends StatelessWidget {
  const PointsFlipCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15.0,
      right: 10.0,
      child: StreamBuilder<int>(
        stream: context.read<Backend>().points,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Opacity(opacity: 0.0);
          } else if (!snapshot.hasData) {
            return CircularProgressIndicator(
              color: Colors.deepPurple.shade400,
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: AnimatedFlipCounter(
                value: snapshot.data!,
                duration: const Duration(milliseconds: 500),
                hideLeadingZeroes: true,
                wholeDigits: 10,
                prefix: "Points: ",
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
