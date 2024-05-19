import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/parcel_class.dart'; // Import the Parcel class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'parcelDetail.dart'; // Import the ParcelDetail page

class ManageParcelPage extends StatefulWidget {
  const ManageParcelPage({Key? key}) : super(key: key);

  @override
  State<ManageParcelPage> createState() => _ManageParcelPageState();
}

class _ManageParcelPageState extends State<ManageParcelPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Parcel> parcelList = [];
  List<Parcel> boxParcelList = [];
  List<Parcel> counterParcelList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchParcelData();
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
            charge: data['charge'] ?? '',
            optCollect: data['optCollect'] ?? '',
            parcelNo: data['parcelNo'] ?? '',
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

        isLoading = false;
      });
    } catch (error) {
      print('Error fetching parcel data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Parcel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Counter'),
            Tab(text: 'Box'),
          ],
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          // Box Tab View
          ListView.builder(
            itemCount: counterParcelList.length,
            itemBuilder: (context, index) {
              final parcel = counterParcelList[index];
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
                        builder: (context) => ParcelDetail(parcel: parcel),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
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
          // Counter Tab View
          ListView.builder(
            itemCount: boxParcelList.length,
            itemBuilder: (context, index) {
              final parcel = boxParcelList[index];
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
                      builder: (context) => ParcelDetail(parcel: parcel),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
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
        ],
      ),
    );
  }
}
