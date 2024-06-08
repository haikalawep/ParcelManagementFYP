import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/staff/Manage/manage_detailParcel.dart';
import 'package:parcelmanagement/staff/Scan/scanPage.dart';


class SplashEditView extends StatelessWidget {
  const SplashEditView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScanView()),
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