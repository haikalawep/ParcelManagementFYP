import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'package:parcelmanagement/common/round_Button.dart';
import 'package:parcelmanagement/common/round_icon_button.dart';
import 'package:parcelmanagement/view/ForgotPassword.dart';
//import 'package:parcelmanagement/view/reset_password.dart';
import 'package:parcelmanagement/view/registerPage.dart';
import 'package:parcelmanagement/customer/custHome_tab.dart';
import 'package:parcelmanagement/staff/home_tab.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> btnLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPassword.text,
      );
      // Navigate to the appropriate page based on user role
      if (userCredential.user != null) {
        // Check if the user's email matches the specified emails
        String userEmail = userCredential.user!.email!;

        if (userEmail == 'haikal.awep@gmail.com' || userEmail == 'haikalarif@gmail.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainTabView()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CustTabView(user: userCredential.user!)),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Show an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email or Password Does Not Exist!')),
      );
    }
  }

  Future<void> btnLoginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          String email = user.email ?? '';

          // Check if the user is signing in for the first time
          final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
          if (isNewUser) {
            // If the user is new, save their information to Firestore
            await FirebaseFirestore.instance.collection('users').doc(email).set({
              'email': user.email,
              'name': user.displayName,
              'mobile': user.phoneNumber,
              'college': 'null',
              'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/parcelfyp.appspot.com/o/defaultProfileImage.jpg?alt=media&token=73bcb7fb-96d8-4fda-a781-b61259b950c5',
            });
          }
          // Handle navigation based on user role here if needed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustTabView(user: userCredential.user!)),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      // Show an error message if login fails
      // You can customize this according to your needs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google'),
        ),
      );
    }
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  /*bool userRoleIsCustomer() {
    // Example function to determine user role based on email
    // You can implement your own logic to determine the user role
    // For example, check if the email is associated with a customer account
    return txtEmail.text.endsWith('@example.com');
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E5DE),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon Logo
              const CircleAvatar(
                backgroundImage: AssetImage('assets/img/hubIcon.jpeg'),
                radius: 60.0,
              ),

              const SizedBox(height: 5.0,),

              //greeting text

              Text("UiTM Parcel Centre",
                style: TextStyle(
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F1500),
                ),
              ),

              const SizedBox(height: 5.0,),

              const Text('Welcome back, you\'ve been missed.',
                  style: TextStyle(
                    fontSize: 16,
                  )),

              const SizedBox(height: 40.0,),

              //email text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: txtEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20.0,),

              //password text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: txtPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),

              //login button
              const SizedBox(height: 20.0,),
              RoundButton(
                  title: "Login",
                  onPressed: () {
                    btnLogin();
                  }),
              const SizedBox(
                height: 4,
              ),

              //Forgot Password
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordView(),
                      //ForgotPasswordView(),
                    ),
                  );
                },
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              const Text(
                "Or sign in with",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      btnLoginWithGoogle();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        //border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Image.asset("assets/img/google_logo.png", width: 60),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,), //Register
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an Account? ",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  // @override
  // Widget build(BuildContext context) {
  //   var media = MediaQuery.of(context).size;
  //
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             const SizedBox(
  //               height: 64,
  //             ),
  //             Text(
  //               "Login",
  //               style: TextStyle(
  //                   color: TColor.primaryText,
  //                   fontSize: 30,
  //                   fontWeight: FontWeight.w800),
  //             ),
  //             Text(
  //               "Add your details to login",
  //               style: TextStyle(
  //                   color: TColor.secondaryText,
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w500),
  //             ),
  //             const SizedBox(
  //               height: 25,
  //             ),
  //             RoundTextfield(
  //               hintText: "Your Email",
  //               controller: txtEmail,
  //               keyboardType: TextInputType.emailAddress,
  //             ),
  //             const SizedBox(
  //               height: 25,
  //             ),
  //             RoundTextfield(
  //               hintText: "Password",
  //               controller: txtPassword,
  //               obscureText: true,
  //             ),
  //             const SizedBox(
  //               height: 25,
  //             ),
  //             RoundButton(
  //                 title: "Login",
  //                 onPressed: () {
  //                   btnLogin();
  //
  //                 }),
  //             const SizedBox(
  //               height: 4,
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const ForgotPasswordView(),
  //                     //ForgotPasswordView(),
  //                   ),
  //                 );
  //               },
  //               child: Text(
  //                 "Forgot your password?",
  //                 style: TextStyle(
  //                     color: TColor.secondaryText,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Text(
  //               "or Login With",
  //               style: TextStyle(
  //                   color: TColor.secondaryText,
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w500),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             RoundIconButton(
  //               icon: "assets/img/google_logo.png",
  //               title: "Login with Google",
  //               color: const Color(0xffDD4B39),
  //               onPressed: () {
  //                 btnLoginWithGoogle();
  //               },
  //             ),
  //             const SizedBox(
  //               height: 40,
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => RegisterView(),
  //                   ),
  //                 );
  //               },
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     "Don't have an Account? ",
  //                     style: TextStyle(
  //                         color: TColor.secondaryText,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //                   Text(
  //                     "Sign Up",
  //                     style: TextStyle(
  //                         color: TColor.primary,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w700),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
