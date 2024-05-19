import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/customer/custHome_tab.dart';

class SplashUpdateView extends StatelessWidget {
  final User user;
  const SplashUpdateView({Key? key, required this.user});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustTabView(user: user)),
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