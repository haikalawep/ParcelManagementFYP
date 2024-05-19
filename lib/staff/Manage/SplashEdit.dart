import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/staff/Manage/manage_detailParcel.dart';


class SplashEditView extends StatelessWidget {
  const SplashEditView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ManageParcelPage()),
      );
    });
    return const Scaffold(
      backgroundColor: Color(0xFF074173),
      body: Center(
        child: Image(
          image: AssetImage("assets/img/UiTM Tapah Hub Logo.jpeg"),
        ),
      ),
    );
  }
}