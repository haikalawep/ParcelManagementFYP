import 'package:parcelmanagement/staff/Manage/SplashEdit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/parcel_class.dart';
import 'package:parcelmanagement/common/roundTextfield.dart'; // Import the Parcel class

import 'package:qr/qr.dart';


class ParcelDetail extends StatefulWidget {
  final Parcel parcel;

  const ParcelDetail({Key? key, required this.parcel}) : super(key: key);

  @override
  _ParcelDetailState createState() => _ParcelDetailState();
}

class _ParcelDetailState extends State<ParcelDetail> {
  String qrURL = '';
  bool showQRCode = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateManagedController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _optCollectController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _parcelNoController = TextEditingController();
  TextEditingController _chargeController = TextEditingController();
  TextEditingController _trackNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.parcel.nameR;
    _dateManagedController.text =
        DateFormat('yyyy-MM-dd').format(widget.parcel.dateManaged);
    _codeController.text = widget.parcel.code;
    _colorController.text = widget.parcel.color;
    _optCollectController.text = widget.parcel.optCollect;
    _sizeController.text = widget.parcel.size;
    _statusController.text = widget.parcel.status;
    _phoneController.text = widget.parcel.phoneR;
    _parcelNoController.text = widget.parcel.parcelNo.toString();
    _chargeController.text = widget.parcel.charge.toString();
    _trackNoController.text = widget.parcel.trackNo;

    retrieveQRCode(); // Call retrieveQRCode method here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel Details'),
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
                  hintText: "Enter Name",
                  controller: _nameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Tracking Number",
                  hintText: "Enter Track Number",
                  controller: _trackNoController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Date Managed",
                  hintText: "Select Date",
                  controller: _dateManagedController,
                  enabled: false, // Disable editing for the date field
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Code",
                  hintText: "Enter Code",
                  controller: _codeController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Color",
                  hintText: "Enter Color",
                  controller: _colorController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Collect Option",
                  hintText: "Enter Option",
                  controller: _optCollectController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Size",
                  hintText: "Enter Size",
                  controller: _sizeController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Status",
                  hintText: "Enter Status",
                  controller: _statusController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Phone Number",
                  hintText: "Enter Phone Number",
                  controller: _phoneController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Parcel No",
                  hintText: "Enter Parcel No",
                  controller: _parcelNoController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Charge",
                  hintText: "Enter Charge",
                  controller: _chargeController,
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  // Update database with new values
                  // You can call a function here to update the database
                  updateParcel();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SplashEditView()),
                  );
                },
                child: Text('Edit'),
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
                  );
                },
                child: Text(showQRCode ? 'Hide QR Code' : 'Show QR Code'),
              ),
            ],
          ),
        ),
      ),
    );
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
      }
    } catch (e) {
      print('Error retrieving QR code data: $e');
    }
  }

  void updateParcel() {
    // Get updated values from controllers
    String newName = _nameController.text;
    String newCode = _codeController.text;
    String newColor = _colorController.text;
    String newOptCollect = _optCollectController.text;
    String newSize = _sizeController.text;
    String newStatus = _statusController.text;
    String newPhone = _phoneController.text;
    String newParcelNo = _parcelNoController.text;
    String newCharge = _chargeController.text;
    String newTrackNo = _trackNoController.text;

    // Create a map of updated values
    Map<String, dynamic> updatedData = {
      'nameR': newName,
      'code': newCode,
      'color': newColor,
      'optCollect': newOptCollect,
      'size': newSize,
      'status': newStatus,
      'phoneR': newPhone,
      'parcelNo': newParcelNo,
      'charge': newCharge,
      'trackNo' : newTrackNo,
    };

    // Get a reference to the Firestore collection
    CollectionReference parcelsRef = FirebaseFirestore.instance.collection('parcelD');

    // Query for the document that matches the parcel's name (or any other unique identifier)
    parcelsRef
        .where('nameR', isEqualTo: widget.parcel.nameR)
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Parcel updated successfully')),
          );
        })
            .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Parcel updated failed')),
          );
        });
      } else {
        print('Parcel not found in Firestore');
      }
    })
        .catchError((error) {
      print('Error querying Firestore: $error');
    });

  }

}
