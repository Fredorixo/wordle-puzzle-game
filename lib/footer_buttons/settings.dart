import "package:flutter/material.dart";
import "package:wordle/constants/difficulty.dart";

class Settings extends StatefulWidget {
  final int letters;
  final Difficulty difficulty;
  final void Function(int) updateLetterCount;
  final void Function(Difficulty) updateDifficulty;

  const Settings({
    Key? key,
    required this.letters,
    required this.difficulty,
    required this.updateDifficulty,
    required this.updateLetterCount,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Settings",
      icon: Icon(
        Icons.settings_rounded,
        color: Colors.grey.shade700,
        semanticLabel: "Settings",
      ),
      onPressed: () {
        showModalBottomSheet(
          enableDrag: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text("Difficulty"),
                        subtitle: Wrap(
                          spacing: 5.0,
                          children: [
                            ChoiceChip(
                              label: const Text("Easy"),
                              selected: widget.difficulty == Difficulty.easy,
                              selectedColor: Colors.lightGreen,
                              onSelected: (bool selected) {
                                if (selected) {
                                  widget.updateDifficulty(Difficulty.easy);
                                  setState(() {});
                                }
                              },
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            ChoiceChip(
                              label: const Text("Medium"),
                              selected: widget.difficulty == Difficulty.medium,
                              selectedColor: Colors.yellow.shade800,
                              onSelected: (bool selected) {
                                if (selected) {
                                  widget.updateDifficulty(Difficulty.medium);
                                  setState(() {});
                                }
                              },
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            ChoiceChip(
                              label: const Text("Hard"),
                              selected: widget.difficulty == Difficulty.hard,
                              selectedColor: Colors.red.shade400,
                              onSelected: (bool selected) {
                                if (selected) {
                                  widget.updateDifficulty(Difficulty.hard);
                                  setState(() {});
                                }
                              },
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Number of Letters"),
                        subtitle: Wrap(
                          children: [
                            for (int count = 3; count <= 8; ++count)
                              ChoiceChip(
                                label: Text("$count"),
                                selected: widget.letters == count,
                                selectedColor: Colors.grey,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    widget.updateLetterCount(count);
                                    setState(() {});
                                  }
                                },
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
