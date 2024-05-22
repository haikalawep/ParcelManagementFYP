import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/cMessage_class.dart';
import 'package:parcelmanagement/class/parcel_class.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'package:parcelmanagement/customer/SplashUpdate.dart'; // Import the Parcel class

class StatusDetail extends StatefulWidget {
  final Parcel parcel;
  final User user;

  const StatusDetail({Key? key, required this.parcel, required this.user}) : super(key: key);

  @override
  _StatusDetailState createState() => _StatusDetailState();
}

class _StatusDetailState extends State<StatusDetail> {
  String qrURL = '';
  bool showQRCode = false;

  TextEditingController _optCollectController = TextEditingController();

  TextEditingController _qrController = TextEditingController();


  String? selectedCollect;

  final List<String> collect = ['Counter', 'Boxes'];

  @override
  void initState() {
    super.initState();

    _optCollectController.text = widget.parcel.optCollect;

    _qrController.text = widget.parcel.qrURL;

    retrieveQRCode();
  }

  Future<bool> _handleBackButtonPress(BuildContext context) async {
    // Perform any cleanup or additional logic here
    // Navigate back to the previous screen
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E5DE),

      appBar: AppBar(
        title: Text('Parcel Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Parcel Name",
                      hintText: widget.parcel.nameR,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Tracking Number",
                      hintText: widget.parcel.trackNo,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Date Managed",
                      hintText: DateFormat('yyyy-MM-dd').format(widget.parcel.dateManaged),
                      enabled: false, // Disable editing for the date field
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Code",
                      hintText: widget.parcel.code,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Color",
                      hintText: widget.parcel.color,
                      enabled: false,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButtonFormField<String>(
                      value: selectedCollect,
                      decoration: InputDecoration(
                        labelText: '${_optCollectController.text}',
                        border: OutlineInputBorder(),
                        hintText: 'Select Option',
                      ),
                      items: collect.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCollect = newValue;
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Size",
                      hintText: widget.parcel.size,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Status",
                      hintText: widget.parcel.status,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Phone Number",
                      hintText: widget.parcel.phoneR,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Parcel No",
                      hintText: widget.parcel.parcelNo.toString(),
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Charge",
                      hintText: widget.parcel.dateManaged.toString(),
                      enabled: false,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      updateParcel();

                      // Navigate to SplashView
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashUpdateView(user: widget.user)),
                      );
                    },
                    child: Text('Save'),
                  ),
                  if (qrURL.isNotEmpty && showQRCode)
                    Image.network(
                      qrURL,
                      width: 150,
                      height: 150,
                    ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 36,
                                ),
                                height: MediaQuery.of(context).size.height * 0.60,
                                width: MediaQuery.of(context).size.width * 0.860,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment(0.8, 1),
                                    colors: <Color>[
                                      Color(0xFFFEEDFC),
                                      Colors.white,
                                      Color(0xFFE4E6F7),
                                      Color(0xFFE2E5F5),
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      height: 340,
                                      width: 340,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(60),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment(0.8, 1),
                                          colors: <Color>[
                                            Colors.white,
                                            Color(0xFFE4E6F7),
                                            Colors.white,
                                          ],
                                          tileMode: TileMode.mirror,
                                        ),
                                      ),
                                      child: Image.network(
                                        qrURL, // Use the qrURL for the QR code image URL
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recipient Generated QR Code!',
                                          style: TextStyle(
                                            fontFamily: 'poppins_bold',
                                            fontSize: 30,
                                            color: Color(0xFF6565FF),
                                          ),
                                        ),
                                        Text(
                                          "This is your unique QR code for another person to scan",
                                          style: TextStyle(
                                            fontFamily: 'poppins_regular',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 32.0,
                                                    color: const Color.fromARGB(
                                                        255, 133, 142, 212)
                                                        .withOpacity(0.68),
                                                  ),
                                                ],
                                              ),
                                              // child: const Icon(
                                              //   EvaIcons.shareOutline,
                                              //   color: Color(0xFF6565FF),
                                              // ),
                                            ),
                                            //const Gap(8),
                                            const Text(
                                              "Share",
                                              style: TextStyle(
                                                fontFamily: 'poppins_semi_bold',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        //const Gap(40),
                                        Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 32.0,
                                                    color: const Color.fromARGB(
                                                        255, 133, 142, 212)
                                                        .withOpacity(0.68),
                                                  ),
                                                ],
                                              ),
                                              // child: const Icon(
                                              //   EvaIcons.saveOutline,
                                              //   color: Color(0xFF6565FF),
                                              // ),
                                            ),
                                            //const Gap(8),
                                            const Text(
                                              "Save",
                                              style: TextStyle(
                                                fontFamily: 'poppins_semi_bold',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ); //Show Dialog
                    },
                    child: Text(showQRCode ? 'Hide QR Code' : 'Show QR Code'),
                  ),
                ],
              ),
            ),
          ),
        );

  }

  void sendMessage(int parcelNo, String messageText) {
    // Create a message object
    Message message = Message(
      message: messageText,
      parcelNo: parcelNo,
      datecMessage: Timestamp.now(),
    );

    // Get a reference to the messages collection
    CollectionReference messagesRef = FirebaseFirestore.instance.collection('cMessages');

    String docId = 'message_$parcelNo';

    // Add the message document to Firestore
    messagesRef.doc(docId).set(message.toMap()).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request message sent successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),
      );
    });
  }

  void updateParcel() {
    // Get updated values
    String newOptCollect = selectedCollect ?? '';
    String newStatus = 'Out Box';

    // Create a map of updated values
    Map<String, dynamic> updatedData = {
      'optCollect': newOptCollect,
      'status' : newStatus,
    };


    // Get a reference to the Firestore collection
    CollectionReference parcelsRef =
    FirebaseFirestore.instance.collection('parcelD');

    // Query for the document that matches the parcel's name (or any other unique identifier)
    parcelsRef
        .where('nameR', isEqualTo: widget.parcel.nameR)
        .where('parcelNo', isEqualTo: widget.parcel.parcelNo)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID
        String docId = querySnapshot.docs.first.id;

        // Get a reference to the document
        DocumentReference parcelRef = parcelsRef.doc(docId);

        // Update the document with the new values
        parcelRef
            .update(updatedData)
            .then((value) {
          if (newOptCollect == 'Boxes') {
            // Send message if optCollect is "Box"
            sendMessage(widget.parcel.parcelNo, 'request to collect parcel at box');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Parcel updated successfully')),
          );
          Navigator.pop(context);
        })
            .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Parcel updated failed')),
          );
        });
      } else {
        print('Parcel not found in Firestore');
      }
    }).catchError((error) {
      print('Error querying Firestore: $error');
    });
  }

  Future<void> retrieveQRCode() async {
    try {
      // Query Firestore to fetch the parcel document based on parcel details
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('parcelD')
          .where('nameR', isEqualTo: widget.parcel.nameR)
          .where('parcelNo', isEqualTo: widget.parcel.parcelNo)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the QR code data from the document
        Map<String, dynamic> userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          // Populate the user profile fields with data from Firestore
          qrURL = userData['qrURL'] ?? '';
        });
      } else {
        print('Parcel not found in Firestore');
        // Navigate back to the profile screen
        Navigator.pop(context);

      }
    } catch (e) {
      print('Error retrieving QR code data: $e');
    }
  }

}
