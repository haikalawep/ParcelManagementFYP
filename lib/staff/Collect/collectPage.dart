import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/customer/custHome_tab.dart';
import 'package:parcelmanagement/staff/OcrPage.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/staff/Collect/parcelCollect.dart';
import 'package:parcelmanagement/staff/open_box.dart';
import 'package:parcelmanagement/view/SplashWelcome.dart';
import 'package:parcelmanagement/view/loginPage.dart';

import '../../common/roundTextfield.dart';

class CollectView extends StatefulWidget {
  const CollectView({Key? key}) : super(key: key);

  @override
  State<CollectView> createState() => _CollectViewState();
}


class _CollectViewState extends State<CollectView> {
  TextEditingController txtSearch = TextEditingController();

  int parcelsCollectedToday = 0;
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    // Fetch the number of parcels from the database when the widget initializes
    fetchNumberOfScan();
  }

  // Function to fetch the number of parcels from the database
  Future<void> fetchNumberOfScan() async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day); // Today's date without time
      DateTime tomorrow = today.add(Duration(days: 1)); // Tomorrow's date
      Timestamp startTimestamp = Timestamp.fromDate(today); // Convert today's date to Timestamp
      Timestamp endTimestamp = Timestamp.fromDate(tomorrow); // Convert tomorrow's date to Timestamp


      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('history')
          .where('dateManaged', isGreaterThanOrEqualTo: startTimestamp) // Filter by scanDate greater than or equal to today
          .where('dateManaged', isLessThan: endTimestamp) // Filter by scanDate less than tomorrow
          .get();
      setState(() {
        // Update the numberOfParcels variable with the number of documents in the collection
        parcelsCollectedToday = snapshot.size;
        isLoading = false; // Set loading state to false

      });
    } catch (e) {
      print('Error fetching number of parcels: $e');
      setState(() {
        isLoading = false; // Set loading state to false in case of error
      });
    }
  }

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()), // Replace LoginPage with the appropriate class for your login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the home tab when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainTabView()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: TColor.background,

        appBar: AppBar(
          title: const Text('Collect'),
          backgroundColor: TColor.topBar,
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  signUserOut(context);
                }
            ),
          ],
        ),
        body: Column(
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RoundTextfield(
                  hintText: "Search Recipient",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(top: 40),
                  child: Center(
                      child: Text(
                        '$parcelsCollectedToday PARCELS COLLECTED TODAY',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                ),
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                ),
              ),
            ],
          ),

        floatingActionButton: ElevatedButton(
          onPressed: () async {
            // Navigate to ParcelDetailView and wait for result
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParcelCollectPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), backgroundColor: Colors.white,
            padding: EdgeInsets.all(16), // Change to your desired background color
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan Here',
                style: TextStyle(
                  color: Colors.black, // Adjust the text color to contrast with the background
                  fontSize: 12, // Adjust the text size if necessary
                ),
              ),
              SizedBox(height: 4), // Add some space between the icon and text
              Icon(
                Icons.qr_code,
                size: 70, // Adjust the size if necessary
                color: Colors.black, // Adjust the color if necessary
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );

  }
}