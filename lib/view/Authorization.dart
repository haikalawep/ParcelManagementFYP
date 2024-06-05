import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/customer/custHome_tab.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/view/WelcomeView.dart';
import 'package:parcelmanagement/view/loginPage.dart';
import 'package:parcelmanagement/view/welcomePage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if user is logged in
          if (snapshot.hasData) {
            // Here, you can check the user's role based on their email or any other criteria
            String? userEmail = snapshot.data!.email;

            // Check if the user's email matches the specified emails for staff
            if (userEmail == 'haikal.awep@gmail.com' || userEmail == 'haikalarif02@gmail.com') {
              return MainTabView(); // Navigate to staff page
            }
            // Check if the user's email matches the specified emails for customer
            return CustTabView(user: snapshot.data!); // Navigate to customer page
          }

          // User is NOT logged in or role not specified
          return WelcomeScreen();
        },
      ),
    );
  }
}
