import "package:flutter/material.dart";
import "package:flutter/services.dart";

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class TextFieldTile extends StatelessWidget {
  final bool isReadOnly;
  final bool isEnabled;
  final Color fillColor;
  final Color textColor;
  final FocusNode? forward;
  final FocusNode? backward;
  final FocusNode focusNode;
  final void Function() onSubmit;
  final FocusNode? Function() onTap;
  final TextEditingController controller;
  final TextEditingController? backController;

  const TextFieldTile({
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
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (controller.text.isEmpty) {
              backward?.requestFocus();
              backController?.clear();
            }
          }
        },
        child: TextField(
          textAlign: TextAlign.center,
          enableInteractiveSelection: false,
          readOnly: isReadOnly,
          enabled: isEnabled,
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 20.0,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            UpperCaseTextFormatter(),
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              forward?.requestFocus();
            }
          },
          onSubmitted: (_) => onSubmit(),
          onTap: () {
            FocusNode? curr = onTap();
            curr?.requestFocus();
          },
        ),
      ),
    );
  }
}
