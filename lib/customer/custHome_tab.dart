import 'package:flutter/material.dart';
import 'package:parcelmanagement/customer/parcelStatus.dart';
import 'package:parcelmanagement/customer/profilePage.dart';
import '../common/tab_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustTabView extends StatefulWidget {
  final User user;

  const CustTabView({Key? key, required this.user}) : super(key: key);

  @override
  State<CustTabView> createState() => _CustTabViewState();
}

class _CustTabViewState extends State<CustTabView> {
  int selctTab = 2;
  late Widget selectPageView = HomeView();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight - MediaQuery.of(context).padding.bottom - kToolbarHeight,
        child: PageStorage(
          bucket: PageStorageBucket(),
          child: selectPageView,
        ),
      ),
      backgroundColor: const Color(0x00000fff),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selctTab != 2) {
            setState(() {
              selctTab = 2;
              selectPageView = HomeView();
            });
          }
        },
        shape: const CircleBorder(),
        backgroundColor:
        selctTab == 2 ? Colors.blueAccent : Colors.grey.shade400,
        child: const Icon(Icons.home),
      ),//*/
      bottomNavigationBar: BottomAppBar(
        //elevation: 8,
        notchMargin: 12,
        height: screenHeight * 0.11,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabButton(
                  title: "Status",
                  icon: "assets/img/tab_more.png",
                  isSelected: selctTab == 3,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: () {
                    if (selctTab != 3) {
                      setState(() {
                        selctTab = 3;
                        selectPageView = ParcelStatusView(user: widget.user);
                      });
                    }
                  },
                ),
                /*TabButton(
                  //title: "Home",
                  iconData: Icons.home,
                  isSelected: selctTab == 2,
                  onTap: () {
                    if (selctTab != 2) {
                      setState(() {
                        selctTab = 2;
                        selectPageView = HomeView(); // Pass user object to ProfileView
                      });
                    }
                  },
                ),*/
                TabButton(
                  title: "Profile",
                  icon: "assets/img/tab_profile.png",
                  isSelected: selctTab == 4,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onTap: () {
                    if (selctTab != 4) {
                      setState(() {
                        selctTab = 4;
                        selectPageView = ProfileView(user: widget.user); // Pass user object to ProfileView
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        automaticallyImplyLeading: false, // Hide the back button
      ),
      body: Center(
        child: Text('Sign Up Page'),
      ),
    );
  }
}

