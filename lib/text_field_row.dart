import "package:flutter/material.dart";
import "package:wordle/text_field_tile.dart";

class TextFieldRow extends StatefulWidget {
  final int k;
  final String word;
  final Map<String, int> map = {};

  TextFieldRow({
    Key? key,
    required this.k,
    required this.word,
  })  : assert(word.length == k),
        super(key: key) {
    for (int i = 0; i < k; ++i) {
      map[word[i]] = map.containsKey(word[i]) ? map[word[i]]! + 1 : 1;
    }
  }

  @override
  State<TextFieldRow> createState() => _TextFieldRowState();
}

class _TextFieldRowState extends State<TextFieldRow> {
  bool isReadOnly = false;
  late List<Color> colors;
  late final List<FocusNode> focusNodes;
  late final List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.k, (_) => TextEditingController());
    focusNodes = List.generate(widget.k, (_) => FocusNode());
    colors = List.filled(widget.k, Colors.white70);
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.k; ++i) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }

    super.dispose();
  }

  void decreaseCount(final String ch, final Map<String, int> count) {
    count[ch] = count[ch]! - 1;

    if (count[ch] == 0) {
      count.remove(ch);
    }
  }

  void validate() {
    final Map<String, int> count = {};
    final List<Color> updatedColors = List.filled(widget.k, Colors.grey);

    widget.map.forEach((key, value) {
      count[key] = value;
    });

    for (int i = 0; i < widget.k; ++i) {
      if (controllers[i].text == widget.word[i]) {
        // Match with correct position
        updatedColors[i] = Colors.green;
        decreaseCount(controllers[i].text, count);
      } else if (count.containsKey(controllers[i].text)) {
        // Match but not correct position
        updatedColors[i] = Colors.yellow;
        decreaseCount(controllers[i].text, count);
      } else {
        // No match
        updatedColors[i] = Colors.grey;
      }
    }

    setState(() {
      colors = updatedColors;
      isReadOnly = true;
    });
  }

  void showError() {
    // Implement using an alert system
    // print("The word is too small.");
  }

  FocusNode onTap() {
    for (int i = 0; i < widget.k; ++i) {
      if (controllers[i].text.isEmpty) {
        return focusNodes[i];
      }
    }

    return focusNodes.last;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < widget.k; ++i)
          TextFieldTile(
            onTap: onTap,
            fillColor: colors[i],
            focusNode: focusNodes[i],
            isReadOnly: isReadOnly,
            controller: controllers[i],
            backController: i > 0 ? controllers[i - 1] : null,
            backward: i > 0 ? focusNodes[i - 1] : null,
            forward: i + 1 < widget.k ? focusNodes[i + 1] : null,
            onSubmit: i == widget.k - 1 ? validate : showError,
          ),
      ],
    );
  }
}
