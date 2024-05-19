import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class TabButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final String? icon;
  final IconData? iconData;
  final bool isSelected;

  const TabButton({
    Key? key,
    this.title,
    this.icon,
    this.iconData,
    required this.onTap,
    required this.isSelected,
  })  : assert(icon != null || iconData != null, 'Either icon or iconData must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,// Set a fixed width to ensure all buttons have the same size
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Image.asset(
                icon!,
                width: 20, // Set the size of the icon
                height: 20,
                color: isSelected ? TColor.primary : TColor.placeholder,
              )
            else if (iconData != null)
              Icon(
                iconData,
                size: 40, // Set the size of the icon
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}