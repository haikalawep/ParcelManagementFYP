import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/customer/custHome_tab.dart';
import 'package:parcelmanagement/staff/OcrPage.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/staff/Collect/parcelCollect.dart';
import 'package:parcelmanagement/view/SplashWelcome.dart';

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
      backgroundColor: const Color(0xFFF9E5DE),

      appBar: AppBar(
        title: Text('Collect'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ),


            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the TestQR page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashView()),
                );
              },
              child: Text('Scan QR'),
              style: ButtonStyle(
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
          shape: CircleBorder(), backgroundColor: Colors.blue,
          padding: EdgeInsets.all(8), // Change to your desired background color
        ),
        child: Image.asset(
          "assets/img/scan.png",
          width: 40,
          height: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),
    );

  }
}