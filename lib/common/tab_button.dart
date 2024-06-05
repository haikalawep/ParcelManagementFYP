import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class TabButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final String? icon;
  final IconData? iconData;
  final bool isSelected;
  final double screenWidth;
  final double screenHeight;

  TabButton({
    Key? key,
    this.title,
    this.icon,
    this.iconData,
    required this.onTap,
    required this.isSelected,
    required this.screenWidth,
    required this.screenHeight,
  })  : assert(icon != null || iconData != null, 'Either icon or iconData must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.2, // Set a dynamic width
        height: screenHeight * 0.2, // Set a dynamic height
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Image.asset(
                icon!,
                width: screenWidth * 0.05, // Adjust the size of the icon dynamically
                height: screenWidth * 0.05,
                color: isSelected ? TColor.primary : TColor.placeholder,
              )
            else if (iconData != null)
              Icon(
                iconData,
                size: screenWidth * 0.1, // Adjust the size of the icon dynamically
                color: isSelected ? Colors.blueAccent : Colors.grey.shade400,
              ),
            const SizedBox(
              height: 10,
            ),
            if (title != null && title!.isNotEmpty)
              Text(
                title!,
                style: TextStyle(
                  color: isSelected ? TColor.primary : TColor.placeholder,
                  fontSize: screenWidth * 0.04, // Adjust the text size dynamically
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
