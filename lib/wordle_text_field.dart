import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pin_code_fields/pin_code_fields.dart";

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

class WordleTextField extends StatefulWidget {
  const WordleTextField({Key? key}) : super(key: key);

  @override
  State<WordleTextField> createState() => _WordleTextFieldState();
}

class _WordleTextFieldState extends State<WordleTextField> {
  bool isReadOnly = false;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      enableActiveFill: true,
      readOnly: isReadOnly,
      mainAxisAlignment: MainAxisAlignment.center,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        fieldHeight: 48.0,
        fieldWidth: 48.0,
        inactiveBorderWidth: 3.0,
        inactiveColor: Colors.grey[300],
        inactiveFillColor: Colors.white70,
        activeBorderWidth: 3.0,
        activeColor: Colors.black45,
        activeFillColor: Colors.white70,
        selectedBorderWidth: 3.0,
        selectedColor: Colors.black45,
        selectedFillColor: Colors.white70,
        borderRadius: BorderRadius.circular(5.0),
        fieldOuterPadding: const EdgeInsets.only(right: 5.0),
      ),
      autoDismissKeyboard: false,
      showCursor: false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        UpperCaseTextFormatter(),
      ],
      onSubmitted: (word) => setState(() {
        isReadOnly = true;
      }),
    );
  }
}
