import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  bool isSwitched = false;

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
    final iconSize = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: TColor.primary,

      appBar: AppBar(
        title: const Text("Notify", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: TColor.primary,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                signUserOut(context);
              }
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: RefreshProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                      color: TColor.secondary,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
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
                        SizedBox(height: screenHeight*0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ServoControlScreen()),
                                  );
                                },
                                child: Container(
                                  height: screenHeight * 0.35,
                                  width: screenWidth * 0.4,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.purpleAccent),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: screenHeight*0.03),
                                        Row(
                                          children: [
                                            SizedBox(width: screenWidth * 0.04),
                                            SvgPicture.asset(
                                              'assets/icons/Unlock(1).svg',
                                              //color: Colors.grey[300],
                                              height: screenHeight * 0.065,
                                              width: screenWidth * 0.055,
                                            ),
                                            //SizedBox(width: screenWidth * 0.02),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight*0.03),
                                        Row(
                                          children: [
                                            SizedBox(width: screenWidth * 0.04),
                                            Text(
                                              "Control",
                                              style: TextStyle(
                                                  fontSize: screenHeight * 0.03,
                                                  color: TColor.white,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ],
                                        ),
                                        //SizedBox(height: screenHeight*0.01),
                                        Row(
                                          children: [
                                            SizedBox(width: screenWidth * 0.04),
                                            Text(
                                              "Box",
                                              style: TextStyle(
                                                  fontSize: screenHeight * 0.03,
                                                  color: TColor.white,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight*0.04),
                                        Row(
                                          children: [
                                            SizedBox(width: screenWidth * 0.02),
                                            Switch(
                                              value: isSwitched,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched = value;
                                                });
                                              },
                                              activeColor: Colors.green,
                                              inactiveThumbColor: Colors.red,
                                              inactiveTrackColor: Colors.grey,
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth*0.02),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomeView()),
                                      );
                                    },
                                    child: Container(
                                      height: screenHeight * 0.23,
                                      width: screenWidth * 0.4,// Adjust the height as needed
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.pink),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Recipients',
                                              style: TextStyle(
                                                fontSize: screenHeight * 0.025,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: screenHeight*0.025),
                                            Center( // Center horizontally and vertically
                                              child: Text(
                                                '$numberOfRecipients',
                                                style: TextStyle(
                                                  fontSize: screenHeight * 0.07,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the next page when the container is clicked
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const ManageParcelPage()), // Replace NextPage with your actual next page widget
                                      );
                                    },
                                    child: Container(
                                      height: screenHeight * 0.23,
                                      width: screenWidth * 0.4, // Adjust the height as needed
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.amber),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Parcels Hold',
                                              style: TextStyle(
                                                fontSize: screenHeight * 0.025,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: screenHeight*0.025),
                                            Center( // Center horizontally and vertically
                                              child: Text(
                                                '$numberOfParcels',
                                                style: TextStyle(
                                                  fontSize: screenHeight * 0.07,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight*0.04),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 5,
                right: 5,
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
                    alignment: Alignment.center,
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                  ),
                  child: Icon(
                    Icons.document_scanner,
                    size: iconSize,
                    color: Colors.black,
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
