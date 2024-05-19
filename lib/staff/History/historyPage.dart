import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/parcel_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'package:parcelmanagement/staff/History/historyDetail.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import '../Manage/parcelDetail.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Parcel> parcelList = [];
  bool isLoading = true;
  TextEditingController txtSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchHistoryData();
  }

  Future<void> fetchHistoryData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('history')
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
            trackNo: data['trackNo'] ?? '', // Pass qrCodeData here
          );
        }).toList();
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching history data: $error');
      setState(() {
        isLoading = false;
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
          title: Text('Manage History'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
          ),
        ),
        body: isLoading
            ? Center(
          child: Card(),
        )
            : ListView.builder(
          itemCount: parcelList.length,
          itemBuilder: (context, index) {
            final parcel = parcelList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                onTap: () {
                  // Navigate to the ParcelDetail page and pass the parcel object
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryDetail(parcel: parcel),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    parcel.nameR,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                  DateFormat('yyyy-MM-dd').format(parcel.dateManaged),
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
    );
  }

}
