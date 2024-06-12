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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: screenHeight*0.09,
        width: screenWidth*0.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgPrimary ? null : Border.all(color: TColor.moreButton, width: 1),
          color: type == RoundButtonType.bgPrimary ? TColor.moreButton : TColor.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: type == RoundButtonType.bgPrimary ? TColor.white :  TColor.moreButton, fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}