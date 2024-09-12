import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/backend/backend.dart";
import "package:wordle/custom_widgets/loading_indicator.dart";
import "package:wordle/footer_buttons/footer_bottom_sheet.dart";
import "package:wordle/footer_buttons/leaderboard_tile.dart";

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
              return const LoadingIndicator();
            } else {
              final users = snapshot.data!;
              final currentUserId = FirebaseAuth.instance.currentUser!.uid;

              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    for (int i = 0; i < users.length; ++i) ...[
                      TableRow(
                        decoration: BoxDecoration(
                          border: users[i]["id"] == currentUserId
                              ? Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                )
                              : null,
                          color: users[i]["id"] == currentUserId
                              ? Theme.of(context).primaryColor.withOpacity(0.6)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 7.5),
                            child: Text(
                              "${i + 1}.",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          LeaderBoardTile(
                            name: users[i]["name"],
                            image: users[i]["image"],
                            points: users[i]["points"],
                            isMatch: users[i]["id"] == currentUserId,
                          ),
                        ],
                      ),
                      const TableRow(
                        children: [
                          SizedBox(height: 5.0),
                          SizedBox(height: 5.0),
                        ],
                      )
                    ]
                  ],
                ),
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
