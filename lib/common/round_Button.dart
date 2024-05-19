import 'package:flutter/material.dart';

import '../common/color_extension.dart';

enum RoundButtonType { bgPrimary, textPrimary }

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final RoundButtonType type;
  final double fontSize;
  const RoundButton(
      {super.key,
        required this.title,
        required this.onPressed,
        this.fontSize = 20,
        this.type = RoundButtonType.bgPrimary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgPrimary ? null : Border.all(color: TColor.primary, width: 1),
          color: type == RoundButtonType.bgPrimary ? TColor.primary : TColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: type == RoundButtonType.bgPrimary ? TColor.white :  TColor.primary, fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}