import "package:flip_card/flip_card.dart";
import "package:flip_card/flip_card_controller.dart";
import "package:flutter/material.dart";
import "package:wordle/home/text_field_tile.dart";

class FlipCardTile extends StatelessWidget {
  final bool isReadOnly;
  final bool isEnabled;
  final Color fillColor;
  final Color? textColor;
  final FocusNode? forward;
  final FocusNode? backward;
  final FocusNode focusNode;
  final void Function() onSubmit;
  final FocusNode? Function() onTap;
  final TextEditingController controller;
  final FlipCardController flipController;
  late final TextFieldTile _textFieldTile;
  final TextEditingController? backController;

  FlipCardTile({
    Key? key,
    this.backController,
    this.forward,
    this.backward,
    required this.onSubmit,
    required this.onTap,
    required this.controller,
    required this.focusNode,
    required this.isReadOnly,
    required this.isEnabled,
    required this.fillColor,
    this.textColor,
    required this.flipController,
  }) : super(key: key) {
    _textFieldTile = TextFieldTile(
      onSubmit: onSubmit,
      onTap: onTap,
      backController: backController,
      forward: forward,
      backward: backward,
      controller: controller,
      focusNode: focusNode,
      isReadOnly: isReadOnly,
      isEnabled: isEnabled && !isReadOnly,
      fillColor: fillColor,
      textColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      flipOnTouch: false,
      front: _textFieldTile,
      back: _textFieldTile,
      controller: flipController,
      direction: FlipDirection.VERTICAL,
    );
  }
}
