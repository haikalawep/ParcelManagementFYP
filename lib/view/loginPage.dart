import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parcelmanagement/class/appValidator.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _isPasswordVisible = false;
  var appValidator = AppValidator();

  Future<void> btnLogin() async {

    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, display a snackbar with the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the information!')),
      );
      return;
    }

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
      AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.rightSlide,
        title: 'Sign In Failed',
        desc: 'Email or Password Not Exist.',
      ).show();
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarRadius = screenSize.width * 0.16;

    return Scaffold(
      backgroundColor: TColor.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight*0.05),
                //Icon Logo
                CircleAvatar(
                  backgroundImage: AssetImage('assets/img/hubIcon.jpeg'),
                  radius: avatarRadius,
                ),
                SizedBox(height: screenHeight * 0.01),
                //greeting text
                Text("UiTM Parcel Centre", textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F1500),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                Text('Welcome back, you\'ve been missed.',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Color(0xFF2F1500),
                    )
                ),
                SizedBox(height: screenHeight * 0.03),
                //email text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 5),
                        child: TextFormField(
                          controller: txtEmail,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: appValidator.validateEmail,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: TColor.topBar,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 5),
                        child: TextFormField(
                          controller: txtPassword,
                          obscureText: !_isPasswordVisible,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: appValidator.validatePassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.password,
                              color: TColor.topBar,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: TColor.topBar, // Ensure AppColors is defined in your code
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
                SizedBox(height: screenHeight * 0.02),
                //password text field
                GestureDetector(
                  onTap: () {
                    btnLogin();
                  },
                  child: Container(
                    width: screenWidth*0.63,
                    height: screenHeight*0.07,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: TColor.moreButton
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: screenHeight * 0.03,
                          color: TColor.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),

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
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Or sign in with",
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        btnLoginWithGoogle();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        child: Image.asset("assets/img/google-sign-in.png", width: screenWidth*0.1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.0001),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
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
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            color: TColor.primary,
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
