import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonSelect extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color buttonColor;
  final Color textColor;
  final String textStyle;

  const ButtonSelect({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = const Color(0xFFD9D9D9),
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
    this.textStyle = "Jomhuria",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108.0,
      height: 38.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text(
          text,
          style: GoogleFonts.getFont(textStyle, fontSize: 22, color: textColor),
        ),
      ),
    );
  }
}
