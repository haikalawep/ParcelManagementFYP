import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/staff/Collect/SplashCollect.dart';
import 'package:parcelmanagement/staff/Manage/manage_detailParcel.dart';
import 'package:parcelmanagement/staff/OcrPage.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/staff/Scan/parcelInsert.dart';
import 'package:parcelmanagement/staff/homepage.dart';
import 'package:parcelmanagement/view/loginPage.dart';
import '../../common/roundTextfield.dart';

class ScanView extends StatefulWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  TextEditingController txtSearch = TextEditingController();
  int numberOfParcels = 0; // Variable to store the number of parcels
  int numberOfParcelsToday = 0;
  int numberOfRecipients = 0;
  bool isLoading = true; // Add a loading state

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    // Fetch the number of parcels from the database when the widget initializes
    fetchNumberOfParcels();
    fetchNumberOfRecipients();
  }

  // Function to fetch the number of parcels from the database
  Future<void> fetchNumberOfParcels() async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day); // Today's date without time
      DateTime tomorrow = today.add(Duration(days: 1)); // Tomorrow's date
      Timestamp startTimestamp = Timestamp.fromDate(today); // Convert today's date to Timestamp
      Timestamp endTimestamp = Timestamp.fromDate(tomorrow); // Convert tomorrow's date to Timestamp

      QuerySnapshot allParcelsSnapshot = await FirebaseFirestore.instance
          .collection('parcelD')
          .get();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('parcelD')
          .where('dateManaged', isGreaterThanOrEqualTo: startTimestamp) // Filter by scanDate greater than or equal to today
          .where('dateManaged', isLessThan: endTimestamp) // Filter by scanDate less than tomorrow
          .get();
      setState(() {
        // Update the numberOfParcels variable with the number of documents in the collection
        numberOfParcelsToday = snapshot.size;
        isLoading = false; // Set loading state to false

        numberOfParcels = allParcelsSnapshot.size;

      });
    } catch (e) {
      print('Error fetching number of parcels: $e');
      setState(() {
        isLoading = false; // Set loading state to false in case of error
      });
    }
  }

  Future<void> fetchNumberOfRecipients() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        // Update the numberOfParcels variable with the number of documents in the collection
        numberOfRecipients = snapshot.size;
      });
    } catch (e) {
      print('Error fetching number of parcels: $e');
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
        backgroundColor: const Color(0xFFF9E5DE),

        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator if data is still loading
            : ListView(
          children: [
            AppBar(
              title: const Text("Notify"),
              backgroundColor: TColor.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    signUserOut(context);
                  }
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  "$numberOfParcelsToday Parcels Scanned Today",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the next page when the container is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeView()), // Replace NextPage with your actual next page widget
                        );
                      },
                      child: Container(
                        height: 120, // Adjust the height as needed
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Recipients',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    '$numberOfRecipients',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the next page when the container is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageParcelPage()), // Replace NextPage with your actual next page widget
                        );
                      },
                      child: Container(
                        height: 120, // Adjust the height as needed
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Parcels Hold',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center( // Center horizontally and vertically
                                  child: Text(
                                    '$numberOfParcels',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                builder: (context) => OCRPage(),
                  //ParcelDetailView()
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
