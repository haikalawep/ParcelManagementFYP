import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/staff/home_tab.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainTabView()),
      );
    });

    return const SafeArea(
      child: Scaffold(
        backgroundColor: TColor.primaryColor,
        body: Center(
          child: Image(
            image: AssetImage("assets/img/UiTM Tapah Hub Logo.jpeg"),
          ),
        ),
      ),
    );
  }
}