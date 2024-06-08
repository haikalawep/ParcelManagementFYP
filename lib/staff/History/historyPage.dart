import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/history_Model.dart';
import 'package:parcelmanagement/class/parcel_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'package:parcelmanagement/staff/History/historyDetail.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/view/loginPage.dart';
import '../Manage/parcelDetail.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<History> historyList = [];
  List<History> filteredHistoryList = [];
  bool isLoading = true;
  TextEditingController txtSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    txtSearch.addListener(_filterHistoryList);
    fetchHistoryData();
  }

  @override
  void dispose() {
    txtSearch.removeListener(_filterHistoryList);
    txtSearch.dispose();
    super.dispose();
  }

  Future<void> fetchHistoryData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('history')
          .get();

      setState(() {
        historyList = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return History(
            nameR: data['nameR'] ?? '',
            dateManaged: (data['dateManaged'] as Timestamp).toDate(),
            code: data['code'] ?? '',
            color: data['color'] ?? '',
            charge: int.parse(data['charge'].toString()) ?? 0,
            optCollect: data['optCollect'] ?? '',
            parcelNo: int.parse(data['parcelNo'].toString()) ?? 0,
            phoneR: data['phoneR'] ?? '',
            size: data['size'] ?? '',
            status: data['status'] ?? '',
            trackNo: data['trackNo'] ?? '',
            parcelID: int.parse(data['parcelID'].toString()) ?? 0,// Pass qrCodeData here
          );
        }).toList();
        filteredHistoryList = historyList;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching history data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterHistoryList() {
    String searchTerm = txtSearch.text.toLowerCase();
    setState(() {
      filteredHistoryList = historyList.where((parcel) {
        return parcel.nameR.toLowerCase().contains(searchTerm) ||
            parcel.trackNo.toLowerCase().contains(searchTerm) ||
            parcel.phoneR.toLowerCase().contains(searchTerm);
      }).toList();
    });

  }

  void _navigateToHistoryView({required History history}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => HistoryDetail(history: history),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
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

    return Scaffold(
      backgroundColor: TColor.secondary,
      appBar: AppBar(
        title: const Text('Manage History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: screenHeight* 0.69,
              child: Container(
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(350, 200),
                    bottomRight: Radius.elliptical(350, 200),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                  child: RoundTextfield(
                    hintText: "Search History",
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
                Expanded(
                  child: isLoading
                      ? const Center(child: RefreshProgressIndicator(),)
                      : ListView.builder(
                    itemCount: filteredHistoryList.length,
                    itemBuilder: (context, index) {
                      final history = filteredHistoryList[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border(
                            bottom: BorderSide(
                              color: TColor.topBar,
                              width: 5.0,
                            ),
                            left: BorderSide(
                              color: TColor.topBar,
                              width: 5.0,
                            ),
                          ),
                          color: Colors.white, // Ensure the container has a background color to match the Card's background
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          onTap: () {
                            _navigateToHistoryView(history: history);
                            // Navigate to the ParcelDetail page and pass the parcel object
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => HistoryDetail(parcel: parcel),
                            //   ),
                            // );
                          },
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start (left) of the column
                              children: [
                                Text(
                                  history.trackNo, // Display the track number
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.015,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01), // Add a small space between the track number and the name
                                Text(
                                  history.nameR,
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            history.phoneR,
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                          trailing: Text(
                            DateFormat('dd-MM-yyyy').format(history.dateManaged),
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      );
                    },
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
