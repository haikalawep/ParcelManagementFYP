import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/tab_button.dart';
import 'package:parcelmanagement/customer/custHome_tab.dart';
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

  int currentSelectedIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      ScanView(),
      CollectView(),
      HistoryPage()
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
      resizeToAvoidBottomInset: false, // This ensures the bottom navigation bar stays fixed
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
              "assets/icons/Scan.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Scan.svg",
              colorFilter: ColorFilter.mode(
                TColor.topBar,
                BlendMode.srcIn,
              ),
            ),
            label: "Handle",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Collect.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Collect.svg",
              colorFilter: ColorFilter.mode(
                TColor.topBar,
                BlendMode.srcIn,
              ),
            ),
            label: "Collect",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/History(1).svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/History(1).svg",
              colorFilter: ColorFilter.mode(
                TColor.topBar,
                BlendMode.srcIn,
              ),
            ),
            label: "History",
          ),
        ],
      ),
    );
  }
}