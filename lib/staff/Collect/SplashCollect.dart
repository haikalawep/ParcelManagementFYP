import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/staff/Scan/scanPage.dart';
import 'package:parcelmanagement/view/welcomePage.dart';

class SplashCollectView extends StatelessWidget {
  const SplashCollectView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainTabView()),
      );
    });
    return const Scaffold(
      backgroundColor: Color(0xFF074173),
      body: Center(
        child: Image(
          image: AssetImage("assets/img/parcelGo_logo.png"),
        ),
      ),
    );
  }
}