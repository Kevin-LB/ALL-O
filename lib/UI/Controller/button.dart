import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ButtonSelect extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color buttonColor;
  final Color textColor;
  final String textStyle;
  final int tailleWidth;
  final int tailleHeight;
  final int fontSize;

  const ButtonSelect({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = const Color(0xFFD9D9D9),
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
    this.textStyle = "Jomhuria",
    this.tailleHeight = 38,
    this.tailleWidth = 108,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tailleWidth.toDouble(),
      height: tailleHeight.toDouble(),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text(
          text,
          style: GoogleFonts.getFont(textStyle, fontSize: fontSize.toDouble(), color: textColor),
        ),
      ),
    );
  }
}
