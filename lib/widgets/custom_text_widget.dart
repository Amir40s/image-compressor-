import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color secondColor;

  /// If true => first 2 words get secondColor
  final bool isFirst;

  /// If true => last 2 words get secondColor
  final bool isLast;

  const CustomTextWidget({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.black,
    this.secondColor = Colors.blue,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final words = text.trim().split(' ');

    List<TextSpan> spans = [];

    for (int i = 0; i < words.length; i++) {
      bool useSecondColor = false;

      /// First 2 words colored
      if (isFirst && i < 2) {
        useSecondColor = true;
      }

      /// Last 2 words colored
      if (isLast && i >= words.length - 2) {
        useSecondColor = true;
      }

      spans.add(
        TextSpan(
          text: "${words[i]} ",
          style: TextStyle(
            color: useSecondColor ? secondColor : color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}