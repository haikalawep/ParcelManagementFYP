import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/sMessage_class.dart';
import 'package:parcelmanagement/common/color_extension.dart';

class NotificationPage extends StatefulWidget {
  final User user; // Define a User object to hold user data

  const NotificationPage({Key? key, required this.user}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  List<StaffMessage> staffMessageList = [];

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> fetchMessage() async {
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

        QuerySnapshot messageSnapshot = await FirebaseFirestore.instance
            .collection('staffMessages')
            .where('parcelNo', whereIn: [
          for (var doc in parcelSnapshot.docs)
            (doc.data() as Map<String, dynamic>)['parcelNo'],
        ])
            .get();

        if (mounted) {
          setState(() {
            staffMessageList = messageSnapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return StaffMessage(
                sMessage: data['message'] ?? '',
                parcelNo: data['parcelNo'] ?? 0,
                datesMessage: (data['timestamp'] as Timestamp).toDate(),
                confirmRetrievalDate: (data['confirmRetrievalDate'] as Timestamp).toDate(),
              );
            }).toList();
            isLoading = false;
          });
        }
      } else {
        print('Customer document not found for email: ${widget.user.email}');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (error) {
      print('Error fetching parcel data: $error');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            backgroundColor: TColor.background,

            appBar: AppBar(
              title: const Text('Notifications'),
              backgroundColor: TColor.topBar,
            ),
            body: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: staffMessageList.length,
              itemBuilder: (context, index) {
                final sMessage = staffMessageList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
                  child: GestureDetector(
                    onTap: () {
                      // Handle onTap event here
                      print('List item clicked');
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sMessage.parcelNo.toString(),
                              style: TextStyle(
                                fontSize: screenHeight * 0.015,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              '${sMessage.sMessage} on ${DateFormat('dd-MM-yyyy').format(sMessage.confirmRetrievalDate)}',
                              style: TextStyle(
                                fontSize: screenHeight * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'delete') {
                            try {
                              // Get the document ID of the message to be deleted
                              String documentIdToDelete = 'staffMessage_${sMessage.parcelNo}';  // Assuming documentId is a property in your StaffMessage class

                              // Delete the document from Firestore
                              await FirebaseFirestore.instance.collection('staffMessages').doc(documentIdToDelete).delete();

                              // Remove the item from the staffMessageList
                              setState(() {
                                staffMessageList.removeAt(index);
                              });

                              // Show a confirmation message to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Message deleted successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (error) {
                              // Show an error message if deletion fails
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete message'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else if (value == 'read') {
                            // Implement 'Read' functionality here
                          } else if (value == 'custom') {
                            print('1');
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                          PopupMenuItem<String>(
                            value: 'read',
                            child: Text('Read'),
                          ),
                          PopupMenuItem<String>(
                            value: 'custom',
                            child: Text('Custom Action'),
                          ),
                        ],
                      ),
                    ),
                  ),

                );
              },
            ),
        )
    );
  }
}
