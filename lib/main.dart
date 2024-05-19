import 'package:firebase_core/firebase_core.dart';
import 'package:parcelmanagement/customer/custHome_tab.dart';
import 'package:parcelmanagement/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/view/Authorization.dart';
import 'package:parcelmanagement/view/loginPage.dart';
import 'package:parcelmanagement/view/welcomePage.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthPage(), // Set the initial page
    );
  }
}