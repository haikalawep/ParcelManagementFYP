import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/customer/parcelStatus.dart';
import 'package:parcelmanagement/customer/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class CustTabView extends StatefulWidget {
  final User user;

  const CustTabView({Key? key, required this.user}) : super(key: key);

  @override
  State<CustTabView> createState() => _CustTabViewState();
}

class _CustTabViewState extends State<CustTabView> {

  int currentSelectedIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      ParcelStatusView(user: widget.user),
      HomeView(),
      ProfileView(user: widget.user)
    ];
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/parcel-manage(1).svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/parcel-manage(1).svg",
              colorFilter: ColorFilter.mode(
                TColor.topBar,
                BlendMode.srcIn,
              ),
            ),
            label: "Status",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: ColorFilter.mode(
                TColor.topBar,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: ColorFilter.mode(
                TColor.topBar,
                BlendMode.srcIn,
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // int selctTab = 2;
  // late Widget selectPageView = HomeView();

  // @override
  // Widget build(BuildContext context) {
  //   double screenHeight = MediaQuery.of(context).size.height;
  //   double screenWidth = MediaQuery.of(context).size.width;
  //
  //   return Scaffold(
  //     body: SizedBox(
  //       height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight - MediaQuery.of(context).padding.bottom - kToolbarHeight,
  //       child: PageStorage(
  //         bucket: PageStorageBucket(),
  //         child: selectPageView,
  //       ),
  //     ),
  //     backgroundColor: const Color(0x00000fff),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         if (selctTab != 2) {
  //           setState(() {
  //             selctTab = 2;
  //             selectPageView = HomeView();
  //           });
  //         }
  //       },
  //       shape: const CircleBorder(),
  //       backgroundColor:
  //       selctTab == 2 ? Colors.blueAccent : Colors.grey.shade400,
  //       child: const Icon(Icons.home),
  //     ),//*/
  //     bottomNavigationBar: BottomAppBar(
  //       //elevation: 8,
  //       notchMargin: 12,
  //       height: screenHeight * 0.11,
  //       shape: const CircularNotchedRectangle(),
  //       child: SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               TabButton(
  //                 title: "Status",
  //                 icon: "assets/img/tab_more.png",
  //                 isSelected: selctTab == 3,
  //                 screenWidth: screenWidth,
  //                 screenHeight: screenHeight,
  //                 onTap: () {
  //                   if (selctTab != 3) {
  //                     setState(() {
  //                       selctTab = 3;
  //                       selectPageView = ParcelStatusView(user: widget.user);
  //                     });
  //                   }
  //                 },
  //               ),
  //               /*TabButton(
  //                 //title: "Home",
  //                 iconData: Icons.home,
  //                 isSelected: selctTab == 2,
  //                 onTap: () {
  //                   if (selctTab != 2) {
  //                     setState(() {
  //                       selctTab = 2;
  //                       selectPageView = HomeView(); // Pass user object to ProfileView
  //                     });
  //                   }
  //                 },
  //               ),*/
  //               TabButton(
  //                 title: "Profile",
  //                 icon: "assets/img/tab_profile.png",
  //                 isSelected: selctTab == 4,
  //                 screenWidth: screenWidth,
  //                 screenHeight: screenHeight,
  //                 onTap: () {
  //                   if (selctTab != 4) {
  //                     setState(() {
  //                       selctTab = 4;
  //                       selectPageView = ProfileView(user: widget.user); // Pass user object to ProfileView
  //                     });
  //                   }
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //
  //     ),
  //   );
  // }
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

