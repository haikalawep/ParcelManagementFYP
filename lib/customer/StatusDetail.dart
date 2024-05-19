import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  TextEditingController _qrController = TextEditingController();
  TextEditingController _trackNoController = TextEditingController();

  String? selectedCollect;

  final List<String> collect = ['Counter', 'Boxes'];

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
                      hintText: "Enter Name",
                      controller: _nameController,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Tracking Number",
                      hintText: "Enter Track Number",
                      controller: _trackNoController,
                      enabled: false,
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
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Color",
                      hintText: "Enter Color",
                      controller: _colorController,
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
                      hintText: "Enter Size",
                      controller: _sizeController,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Status",
                      hintText: "Enter Status",
                      controller: _statusController,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Phone Number",
                      hintText: "Enter Phone Number",
                      controller: _phoneController,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Parcel No",
                      hintText: "Enter Parcel No",
                      controller: _parcelNoController,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundTitleTextfield(
                      title: "Charge",
                      hintText: "Enter Charge",
                      controller: _chargeController,
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
                      setState(() {
                        showQRCode = !showQRCode;
                      });
                    },
                    child: Text(showQRCode ? 'Hide QR Code' : 'Show QR Code'),
                  ),
                ],
              ),
            ),
          ),
        );

  }

  void updateParcel() {
    // Get updated values
    String newOptCollect = selectedCollect ?? '';

    // Create a map of updated values
    Map<String, dynamic> updatedData = {
      'optCollect': newOptCollect,
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
