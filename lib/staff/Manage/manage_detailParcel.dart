import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/parcel_class.dart'; // Import the Parcel class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'parcelDetail.dart'; // Import the ParcelDetail page

class ManageParcelPage extends StatefulWidget {
  const ManageParcelPage({Key? key}) : super(key: key);

  @override
  State<ManageParcelPage> createState() => _ManageParcelPageState();
}

class _ManageParcelPageState extends State<ManageParcelPage> with TickerProviderStateMixin {
  TabController? _tabController;
  TabController? _boxTabController;
  List<Parcel> parcelList = [];
  List<Parcel> boxParcelList = [];
  List<Parcel> counterParcelList = [];
  List<Parcel> filteredBoxParcelList = [];
  List<Parcel> filteredCounterParcelList = [];
  bool isLoading = true;
  TextEditingController txtSearchCounter = TextEditingController();
  TextEditingController txtSearchBox = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _boxTabController = TabController(length: 2, vsync: this);
    fetchParcelData();

    txtSearchCounter.addListener(() {
      filterCounterParcels();
    });

    txtSearchBox.addListener(() {
      filterBoxParcels();
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _boxTabController!.dispose();
    txtSearchCounter.dispose();
    txtSearchBox.dispose();
    super.dispose();
  }

  Future<void> fetchParcelData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('parcelD')
          .get();

      setState(() {
        parcelList = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Parcel(
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
            qrURL: data['qrURL'] ?? '',
            trackNo: data['trackNo'] ?? '',
          );
        }).toList();

        // Populate boxParcelList and counterParcelList based on parcel status
        boxParcelList = parcelList.where((parcel) => parcel.optCollect == 'Boxes').toList();
        counterParcelList = parcelList.where((parcel) => parcel.optCollect == 'Counter').toList();

        filteredBoxParcelList = boxParcelList;
        filteredCounterParcelList = counterParcelList;

        isLoading = false;
      });
    } catch (error) {
      print('Error fetching parcel data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterCounterParcels() {
    setState(() {
      filteredCounterParcelList = counterParcelList
          .where((parcel) => parcel.trackNo.toLowerCase().contains(txtSearchCounter.text.toLowerCase()) ||
          parcel.nameR.toLowerCase().contains(txtSearchCounter.text.toLowerCase()))
          .toList();
    });
  }

  void filterBoxParcels() {
    setState(() {
      filteredBoxParcelList = boxParcelList
          .where((parcel) => parcel.trackNo.toLowerCase().contains(txtSearchBox.text.toLowerCase()) ||
          parcel.nameR.toLowerCase().contains(txtSearchBox.text.toLowerCase()))
          .toList();
    });
  }

  void _navigateToDetailView({required Parcel parcel}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => ParcelDetail(parcel: parcel),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,

      appBar: AppBar(
        title: const Text('Manage Parcel'),
        backgroundColor: TColor.topBar,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Counter'),
            Tab(text: 'Box', ),
          ],
          labelStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Increase font size for selected tab
          unselectedLabelStyle: const TextStyle(fontSize: 16),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RoundTextfield(
                  hintText: "Search Parcel in Counter",
                  controller: txtSearchCounter,
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
                child: ListView.builder(
                  itemCount: filteredCounterParcelList.length,
                  itemBuilder: (context, index) {
                    final parcel = filteredCounterParcelList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: const Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 5.0,
                          ),
                          left: BorderSide(
                            color: Colors.black,
                            width: 5.0,
                          ),
                        ),
                        color: Colors.white, // Ensure the container has a background color to match the Card's background
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        onTap: () {
                          _navigateToDetailView(parcel: parcel);
                          // Navigate to the ParcelDetail page and pass the parcel object
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => HistoryDetail(parcel: parcel),
                          //   ),
                          // );
                        },
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start (left) of the column
                            children: [
                              Text(
                                parcel.trackNo, // Display the track number
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 15), // Add a small space between the track number and the name
                              Text(
                                parcel.nameR,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          parcel.phoneR,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Text(
                          DateFormat('dd-MM-yyyy').format(parcel.dateManaged),
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RoundTextfield(
                  hintText: "Search Parcel in Box",
                  controller: txtSearchBox,
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
              TabBar(
                controller: _boxTabController,
                tabs: const[
                  Tab(text: 'Out Box'),
                  Tab(text: 'In Box'),
                ],
                labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Adjust label style if needed
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                indicator: BoxDecoration(
                  color: TColor.topBar, // Set the desired background color
                  borderRadius: BorderRadius.circular(15), // Optional: adjust the border radius
                ),
                indicatorSize: TabBarIndicatorSize.tab, // or TabBarIndicatorSize.label, depending on your preference
                indicatorWeight: 5,
              ),
              Expanded(
                  child: TabBarView(
                    controller: _boxTabController,
                    children: [
                      ListView.builder(
                        itemCount: filteredBoxParcelList.where((parcel) => parcel.status == 'Out Box').length,
                        itemBuilder: (context, index) {
                          final parcel = filteredBoxParcelList.where((parcel) => parcel.status == 'Out Box').toList()[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: const Border(
                                bottom: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 5.0,
                                ),
                                left: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 5.0,
                                ),
                              ),
                              color: Colors.white, // Ensure the container has a background color to match the Card's background
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              onTap: () {
                                _navigateToDetailView(parcel: parcel);
                                // Navigate to the ParcelDetail page and pass the parcel object
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => HistoryDetail(parcel: parcel),
                                //   ),
                                // );
                              },
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start (left) of the column
                                  children: [
                                    Text(
                                      parcel.trackNo, // Display the track number
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 15), // Add a small space between the track number and the name
                                    Text(
                                      parcel.nameR,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                parcel.phoneR,
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Text(
                                DateFormat('dd-MM-yyyy').format(parcel.dateManaged),
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      ListView.builder(
                        itemCount: filteredBoxParcelList.where((parcel) => parcel.status == 'In Box').length,
                        itemBuilder: (context, index) {
                          final parcel = filteredBoxParcelList.where((parcel) => parcel.status == 'In Box').toList()[index];
                          bool isDateAfterNow = parcel.dateManaged.isAfter(DateTime.now());
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: const Border(
                                bottom: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 5.0,
                                ),
                                left: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 5.0,
                                ),
                              ),
                              color: Colors.white, // Ensure the container has a background color to match the Card's background
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              onTap: () {
                                _navigateToDetailView(parcel: parcel);
                                // Navigate to the ParcelDetail page and pass the parcel object
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => HistoryDetail(parcel: parcel),
                                //   ),
                                // );
                              },
                              leading: isDateAfterNow
                                ? const Icon(Icons.circle, color: Colors.green, size: 30)
                                : const Icon(Icons.circle, color: Colors.red, size: 30),
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start (left) of the column
                                  children: [
                                    Text(
                                      parcel.trackNo, // Display the track number
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 15), // Add a small space between the track number and the name
                                    Text(
                                      parcel.nameR,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                parcel.phoneR,
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Text(
                                DateFormat('dd-MM-yyyy').format(parcel.dateManaged),
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),


                    ],
                  )
              )

              // Expanded(
              //     child: ListView.builder(
              //       itemCount: filteredBoxParcelList.length,
              //       itemBuilder: (context, index) {
              //         final parcel = filteredBoxParcelList[index];
              //         return Container(
              //           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(15.0),
              //             border: const Border(
              //               bottom: BorderSide(
              //                 color: Colors.blueAccent,
              //                 width: 5.0,
              //               ),
              //               left: BorderSide(
              //                 color: Colors.blueAccent,
              //                 width: 5.0,
              //               ),
              //             ),
              //             color: Colors.white, // Ensure the container has a background color to match the Card's background
              //           ),
              //           child: ListTile(
              //             contentPadding: const EdgeInsets.symmetric(
              //               vertical: 16,
              //               horizontal: 16,
              //             ),
              //             onTap: () {
              //               _navigateToDetailView(parcel: parcel);
              //               // Navigate to the ParcelDetail page and pass the parcel object
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => HistoryDetail(parcel: parcel),
              //               //   ),
              //               // );
              //             },
              //             title: Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 2.0),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start (left) of the column
              //                 children: [
              //                   Text(
              //                     parcel.trackNo, // Display the track number
              //                     style: const TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.normal,
              //                     ),
              //                   ),
              //                   const SizedBox(height: 15), // Add a small space between the track number and the name
              //                   Text(
              //                     parcel.nameR,
              //                     style: const TextStyle(
              //                       fontSize: 24,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             subtitle: Text(
              //               parcel.phoneR,
              //               style: TextStyle(
              //                 color: Colors.blue.shade700,
              //                 fontSize: 16,
              //               ),
              //             ),
              //             trailing: Text(
              //               DateFormat('dd-MM-yyyy').format(parcel.dateManaged),
              //               style: const TextStyle(
              //                 color: Colors.black45,
              //                 fontSize: 16,
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              // ),
            ],
          ),
          // Box Tab View
          // Counter Tab View
        ],
      ),
    );
  }
}
