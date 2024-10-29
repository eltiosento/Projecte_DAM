import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomTexts extends StatelessWidget {
  const CustomTexts({
    super.key,
    required this.text,
    this.fontSize = 20.0,
    this.colorText = Colors.white,
    this.fontFamily = 'Montserrat',
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.style,
    this.shadows,
    this.maxLines,
  });

  final String text;
  final double fontSize;
  final Color colorText;
  final String fontFamily;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextStyle? style;
  final List<Shadow>? shadows;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: colorText,
        shadows: shadows,
      ),
      maxLines: maxLines,
      minFontSize: 10,
      //overflow: TextOverflow.ellipsis,
      textScaleFactor:
          isMobile(context) ? 0.8 : (isTablet(context) ? 1.0 : 1.2),
      textAlign: textAlign,
    );
  }
}
