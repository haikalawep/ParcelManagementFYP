import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/view/loginPage.dart';
import 'package:parcelmanagement/view/registerPage.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class AllinOnboardModel {
  String imgStr;
  String description;
  String titlestr;
  AllinOnboardModel(this.imgStr, this.description, this.titlestr);
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  List<AllinOnboardModel> allinonboardlist = [
    AllinOnboardModel(
        "assets/img/received.png",
        "Effortlessly Collect Your Parcels with Seamless Convenience and Minimal Disruption",
        "Effortless Collection"),
    AllinOnboardModel(
        "assets/img/alert.png",
        "Stay Alert: Never Miss a Beat with Instant Notifications When Parcels Arrive",
        "Arrival Alerts"),
    AllinOnboardModel(
        "assets/img/inventory.png",
        "Experience Secure and Convenient Parcel Management with Streamlined Handling",
        "Secure Handling"),
  ];

  static const Duration kAnimationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "UiTM Parcel Centre",
      //     style: TextStyle(color: TColor.topBar, fontSize: screenHeight * 0.03),
      //   ),
      //   backgroundColor: TColor.background,
      // ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: screenHeight*0.07),
          Expanded(
            child: PageView.builder(
              controller: _pageController,

              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: allinonboardlist.length,
              itemBuilder: (context, index) {
                return PageBuilderWidget(
                  title: allinonboardlist[index].titlestr,
                  description: allinonboardlist[index].description,
                  imgurl: allinonboardlist[index].imgStr,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              allinonboardlist.length,
                  (index) => buildDot(index: index),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          GestureDetector( onTap: () {Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
          );
            },
            child: Container(
              width: screenWidth*0.63,
              height: screenHeight*0.07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: TColor.button),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: screenHeight * 0.03, color: TColor.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              );
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
                "Create an Account",
                style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    color: TColor.white,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.10),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index ? TColor.topBar : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PageBuilderWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imgurl;

  PageBuilderWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imgurl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.05),
            child: Image.asset(
              imgurl,
              height: screenHeight * 0.33,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: screenHeight * 0.07),
          Text(
            title,
            style: TextStyle(
              color: TColor.topBar,
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: TColor.topBar,
              fontSize: screenHeight * 0.02,
            ),
          ),
        ],
      ),
    );
  }
}
