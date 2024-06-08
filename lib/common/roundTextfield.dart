import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? bgColor;
  final Color? borderColor; // Add border color property
  final Widget? left;
  final bool enabled;

  const RoundTextfield({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.bgColor,
    this.borderColor, // Initialize border color property
    this.left,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? TColor.textfield,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? Colors.black, // Use border color or default to transparent
        ),
      ),
      child: Row(
        children: [
          if (left != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: left!,
            ),
          Expanded(
            child: TextField(
              autocorrect: false,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              enabled: enabled,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: TColor.placeholder,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundTitleTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? bgColor;
  final Color? borderColor; // Add border color property
  final Widget? left;
  final bool enabled;

  const RoundTitleTextfield({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.bgColor,
    this.borderColor, // Initialize border color property
    this.left,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: bgColor ?? TColor.textfield,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: borderColor ?? Colors.transparent, // Use border color or default to transparent
        ),
      ),
      child: Row(
        children: [
          if (left != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: left!,
            ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(
                    top: 8,
                  ),
                  alignment: Alignment.topLeft,
                  child: TextField(
                    autocorrect: false,
                    controller: controller,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    enabled: enabled,
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: Colors.black87, // Customize hint text color
                        fontWeight: FontWeight.w600, // Customize hint text font weight
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 5, left: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style:
                    TextStyle(color: TColor.placeholder, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
