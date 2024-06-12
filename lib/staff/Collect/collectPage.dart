import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'package:parcelmanagement/staff/Collect/parcelCollect.dart';
import 'package:parcelmanagement/view/loginPage.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.1;
    //bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Scaffold(
      backgroundColor: TColor.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: screenHeight * 0.24,
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight*0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: screenWidth*0.1),
                        Text('Collect', style: TextStyle(fontSize: screenHeight * 0.03 , color: Colors.white, fontWeight: FontWeight.w500)),
                        //SizedBox(width: screenWidth * 0.6),
                        IconButton(
                            icon: const Icon(Icons.logout),
                            color: Colors.white,
                            onPressed: () {
                              signUserOut(context);
                            }
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: RoundTextfield(
                        prefixIcon: Icons.search,
                        hintText: "Search Recipient",
                        controller: txtSearch,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Stack(
            children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      '$parcelsCollectedToday Parcels Collected Today',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.584),
              ],
            ),
              Positioned(
                bottom: 5,
                right: 8,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to ParcelCollectPage and wait for result
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParcelCollectPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    alignment: Alignment.center,
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: iconSize,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
              ],
        ),
      ),
    );
  }
}
