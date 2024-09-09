import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/backend/backend.dart";
import "package:wordle/footer_buttons/footer_bottom_sheet.dart";

class LeaderBoard extends StatelessWidget {
  final bool isDisabled;

  const LeaderBoard({
    Key? key,
    required this.isDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FooterBottomSheet(
      name: "Leaderboard",
      body: [
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: context.read<Backend>().topScorers,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Opacity(opacity: 0.0);
            } else if (!snapshot.hasData) {
              return CircularProgressIndicator(
                color: Colors.deepPurple.shade400,
              );
            } else {
              final users = snapshot.data!;

              return Column(
                children: [for (final user in users) Text(user.toString())],
              );
            }
          },
        ),
      ],
      titleIcon: Icons.layers_rounded,
      isDisabled: isDisabled,
      displayIcon: Icons.leaderboard_rounded,
    );
  }
}
