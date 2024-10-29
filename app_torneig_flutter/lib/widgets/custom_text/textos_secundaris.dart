import 'package:flutter/material.dart';

class TextNomsSecundaris extends StatelessWidget {
  const TextNomsSecundaris({
    super.key,
    required this.text1,
    this.text2,
    this.fontSize = 18.0,
    this.colorText1 = Colors.white,
    this.colorText2 = Colors.red, // Color diferente para text2
  });

  final String text1;
  final String? text2;
  final double fontSize;
  final Color colorText1;
  final Color colorText2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'FaceOffM54',
          shadows: const <Shadow>[
            Shadow(
              offset: Offset(4.0, 3.0),
              blurRadius: 1.0,
              color: Colors.black,
            ),
          ],
        ),
        children: <TextSpan>[
          TextSpan(
            text: text1,
            style: TextStyle(
              color: colorText1,
            ),
          ),
          if (text2 != null)
            TextSpan(
              text: " $text2",
              style: TextStyle(
                color: colorText2,
              ),
            ),
        ],
      ),
    );
  }
}
