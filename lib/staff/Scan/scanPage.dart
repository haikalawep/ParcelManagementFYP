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
import 'package:parcelmanagement/staff/open_box.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.15;

    return Scaffold(
      backgroundColor: TColor.background,

      appBar: AppBar(
        title: const Text("Notify"),
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
                children: [
                  SizedBox(height: screenHeight*0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        "$numberOfParcelsToday Parcel Scanned Today",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.04),
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
                              height: screenHeight * 0.18, // Adjust the height as needed
                              child: Card(
                                color: TColor.topBar,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Recipients',
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight*0.025),
                                      Center(
                                        child: Text(
                                          '$numberOfRecipients',
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.045,
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
          
                        SizedBox(width: screenWidth*0.04),
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
                              height: screenHeight * 0.18, // Adjust the height as needed
                              child: Card(
                                color: TColor.topBar,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Parcels Hold',
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight*0.025),
                                      Center( // Center horizontally and vertically
                                        child: Text(
                                          '$numberOfParcels',
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.045,
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
                  SizedBox(height: screenHeight*0.04),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServoControlApp()),
                      );
                    },
                    child: Container(
                      width: screenWidth*0.63,
                      height: screenHeight*0.07,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: TColor.button
                      ),
                      child: Text(
                        "Control Box",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            color: TColor.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1764),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      //margin: EdgeInsets.only(bottom: 5), // Adjust the margin as needed
                      child: ElevatedButton(
                        onPressed: () async {
                          // Navigate to ParcelCollectPage and wait for result
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OCRPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(screenWidth * 0.045),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Scan Here',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                            //SizedBox(height: screenHeight * 0.03),
                            Icon(
                              Icons.document_scanner,
                              size: iconSize,
                              color: Colors.black,
                            ),
                            // Image.asset(
                            //   "assets/img/scan.png",
                            //   width: screenWidth * 0.05,
                            //   height: screenHeight * 0.05,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),

      // floatingActionButton: ElevatedButton(
      //   onPressed: () async {
      //     // Navigate to ParcelDetailView and wait for result
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => OCRPage(),
      //           //ParcelDetailView()
      //       ),
      //     );
      //   },
      //   style: ElevatedButton.styleFrom(
      //     shape: CircleBorder(), backgroundColor: TColor.button,
      //     padding: EdgeInsets.all(16), // Change to your desired background color
      //   ),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       // Text(
      //       //   'Scan Here',
      //       //   style: TextStyle(
      //       //     color: Colors.white, // Adjust the text color to contrast with the background
      //       //     fontSize: screenHeight * 0.02, // Adjust the text size if necessary
      //       //   ),
      //       // ),
      //       //SizedBox(height: screenHeight*0.01), // Add some space between the icon and text
      //       Image.asset(
      //         "assets/img/scan.png",
      //         width: screenWidth * 0.15,
      //         height: screenHeight * 0.15,
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

}
