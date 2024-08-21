import "package:flutter/material.dart";
import "package:wordle/constants/outcome.dart";
import "package:wordle/text_field_tile.dart";

class TextFieldRow extends StatefulWidget {
  final int k;
  final List<Outcome> Function(String) onSubmit;

  const TextFieldRow({
    Key? key,
    required this.k,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<TextFieldRow> createState() => _TextFieldRowState();
}

class _TextFieldRowState extends State<TextFieldRow> {
  bool isReadOnly = false;
  Color textColor = Colors.black;
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

  void evaluate() {
    String guess = "";

    for (final TextEditingController controller in controllers) {
      guess = guess + controller.text;
    }

    List<Outcome> outcomes = widget.onSubmit(guess);

    final List<Color> updatedColors = List.filled(widget.k, Colors.grey);

    for (int i = 0; i < widget.k; ++i) {
      if (outcomes[i] == Outcome.correct) {
        updatedColors[i] = Colors.lightGreen.shade600;
      } else if (outcomes[i] == Outcome.partiallyCorrect) {
        updatedColors[i] = Colors.yellow.shade700;
      } else {
        updatedColors[i] = Colors.grey;
      }
    }

    setState(() {
      colors = updatedColors;
      textColor = Colors.white;
      isReadOnly = true;
    });
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
            textColor: textColor,
            focusNode: focusNodes[i],
            isReadOnly: isReadOnly,
            controller: controllers[i],
            backController: i > 0 ? controllers[i - 1] : null,
            backward: i > 0 ? focusNodes[i - 1] : null,
            forward: i + 1 < widget.k ? focusNodes[i + 1] : null,
            onSubmit: evaluate,
          ),
      ],
    );
  }
}
