import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/parcel_class.dart'; // Import the Parcel class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcelmanagement/customer/StatusDetail.dart';

class ParcelStatusView extends StatefulWidget {
  final User user; // Define a User object to hold user data

  const ParcelStatusView({Key? key, required this.user}) : super(key: key);

  @override
  State<ParcelStatusView> createState() => _ParcelStatusState();
}

class _ParcelStatusState extends State<ParcelStatusView> {
  List<Parcel> parcelList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatusData();
  }

  Future<void> fetchStatusData() async {
    try {
      // Get the user document from Firestore based on the current user's email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .limit(1)
          .get();

      // Check if any customer documents were found
      if (userSnapshot.docs.isNotEmpty) {
        // Extract the customer's phone number from the first document in the snapshot
        String customerPhoneNumber = (userSnapshot.docs.first.data() as Map<String, dynamic>)['mobile'] ?? '';


        // Query Firestore for parcels with matching phone numbers
        QuerySnapshot parcelSnapshot = await FirebaseFirestore.instance
            .collection('parcelD')
            .where('phoneR', isEqualTo: customerPhoneNumber)
            .get();

        setState(() {
          parcelList = parcelSnapshot.docs.map((doc) {
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
          isLoading = false;
        });
      } else {
        print('Customer document not found for email: ${widget.user.email}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching parcel data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }


  void _navigateToDetailView({required Parcel parcel, required User user}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => StatusDetail(parcel: parcel, user: widget.user),
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
      backgroundColor: const Color(0xFFF9E5DE),

      appBar: AppBar(
        title: const Text('Parcel Detail'),
        automaticallyImplyLeading: false, // Hide the back button
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: parcelList.length,
        itemBuilder: (context, index) {
          final parcel = parcelList[index];
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
                _navigateToDetailView(parcel: parcel, user: widget.user);
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
    );
  }
}
