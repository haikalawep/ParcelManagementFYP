import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/tab_button.dart';
import 'package:parcelmanagement/staff/Collect/collectPage.dart';
import 'package:parcelmanagement/staff/History/historyPage.dart';
import 'package:parcelmanagement/staff/Manage/managePage.dart';
import 'package:parcelmanagement/staff/Scan/scanPage.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectedIndex = 0;
  late Widget selectedPageView;

  @override
  void initState() {
    super.initState();
    selectedPageView = const ScanView(); // Default page

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: selectedPageView,
      backgroundColor: const Color(0xFFF9E5DE),

      bottomNavigationBar: BottomAppBar(
        //surfaceTintColor: Colors.purple,
        //shadowColor: Colors.white,
        elevation: 1,
        notchMargin: 12,
        height: screenHeight * 0.11,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                title: "Scan",
                icon: "assets/img/scan.png",
                onTap: () => _selectTab(0),
                isSelected: selectedIndex == 0,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              TabButton(
                title: "Collect",
                icon: "assets/img/tab_offer.png",
                onTap: () => _selectTab(1),
                isSelected: selectedIndex == 1,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              /*TabButton(
                title: "Manage",
                icon: "assets/img/tab_profile.png",
                onTap: () => _selectTab(2),
                isSelected: selectedIndex == 2,
              ),*/
              TabButton(
                title: "History",
                icon: "assets/img/tab_more.png",
                onTap: () => _selectTab(2),
                isSelected: selectedIndex == 2,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      selectedIndex = index;
      switch (selectedIndex) {
        case 0:
          selectedPageView = const ScanView();
          break;
        case 1:
          selectedPageView = const CollectView();
          break;
        case 2:
          selectedPageView = const HistoryPage();
          break;
        /*case 3:
          selectedPageView = const HistoryPage();
          break;*/
      }
    });
  }
}
