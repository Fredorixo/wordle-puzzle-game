import "package:flutter/material.dart";
import "package:wordle/app/color_schemes.dart";
import "package:wordle/custom_widgets/icon_title.dart";

class FooterBottomSheet extends StatelessWidget {
  final String name;
  final List<Widget> body;
  final IconData titleIcon;
  final IconData displayIcon;

  const FooterBottomSheet({
    Key? key,
    required this.name,
    required this.body,
    required this.titleIcon,
    required this.displayIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: name,
      icon: Icon(
        displayIcon,
        color: Colors.grey.shade700,
        semanticLabel: name,
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: ColorSchemes.headlineColor,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: IconTitle(
                    title: name,
                    icon: titleIcon,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                const SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 5.0,
                  ),
                  child: Column(
                    children: body,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
