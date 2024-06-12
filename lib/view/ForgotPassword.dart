import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'package:parcelmanagement/common/round_Button.dart';
import 'package:parcelmanagement/view/OtpPage.dart';
import 'package:parcelmanagement/view/loginPage.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController txtEmail = TextEditingController();
  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              Text(
                "Reset Password",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),

              const SizedBox(
                height: 15,
              ),

              Text(
                "Please enter your email to receive a\n reset code to create a new password via email",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 60,
              ),
              RoundTextfield(
                hintText: "Your Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 30,
              ),

              RoundButton(title: "Send", onPressed: () async {
                /*myauth.setConfig(
                    appEmail: "contact@hdevcoder.com",
                    appName: "Email OTP",
                    userEmail: txtEmail.text,
                    otpLength: 4,
                    otpType: OTPType.digitsOnly);
                if (await myauth.sendOTP() == true) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content: Text("OTP has been sent"),
                  ));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>   OtpScreen(myauth: myauth, email: txtEmail.text,)));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content: Text("Oops, OTP send failed"),
                  ));
                }*/
                String email = txtEmail.text.trim();
                if (email.isNotEmpty) {
                  resetPassword(email, context);
                } else {
                  showErrorMessage(context, "Please enter an email address.");
                }

              }),

            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(String email, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(email)) {
        throw 'Invalid email format';
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      showSuccessMessage(
        context,
        "Email telah dihantar",
      );
    } catch (e) {
      Navigator.pop(context);

      final errorMessage = e is FirebaseAuthException
          ? e.message ?? "Email gagal dihantar. Sila cuba lagi"
          : "Email gagal dihantar. Sila cuba lagi";

      showErrorMessage(context, errorMessage);
    }
  }

  void showSuccessMessage(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: 'Email is already sent. Please check email to change yor password',
    ).show();
  }

  void showErrorMessage(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Failed',
      desc: 'Email unsuccessful sent. Try again later',
    ).show();
  }

  void showAutoDismissAlertDialog(
      BuildContext context, String message, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, height: 50, width: 50),
              SizedBox(height: 10),
              Text(message),
            ],
          ),
        );
      },
    );
  }

//OtpScreen(myauth: myauth, email: txtEmail.text,)));
}