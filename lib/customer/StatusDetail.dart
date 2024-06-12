import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/cMessage_class.dart';
import 'package:parcelmanagement/class/parcel_class.dart';
import 'package:parcelmanagement/common/color_extension.dart';
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
  TextEditingController _collectDateController = TextEditingController();
  TextEditingController _qrController = TextEditingController();


  String? selectedCollect;
  DateTime? retrievalDate;

  late double screenWidth;
  late double screenHeight;

  final List<String> collectOptions = ['Counter', 'Boxes'];

  @override
  void initState() {
    super.initState();

    _optCollectController.text = widget.parcel.optCollect;
    _qrController.text = widget.parcel.qrURL;
    selectedCollect = widget.parcel.optCollect;
    _collectDateController.text = widget.parcel.collectDate != null
        ? DateFormat('yyyy-MM-dd').format(widget.parcel.collectDate!)
        : '';

    retrieveQRCode();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        screenWidth = MediaQuery.of(context).size.width;
        screenHeight = MediaQuery.of(context).size.height;
      });
    });
  }

  Future<bool> _handleBackButtonPress(BuildContext context) async {
    // Perform any cleanup or additional logic here
    // Navigate back to the previous screen
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.secondary,

      appBar: AppBar(
        title: const Text("Parcel Detail", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: TColor.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: () {
              _showSaveConfirmationDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.qr_code_sharp, color: Colors.white),
            onPressed: () {
              //_showDeleteConfirmationDialog();
              showQR();
            },
          ),
        ],
      ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RoundTitleTextfield(
                      title: "Parcel Name",
                      hintText: widget.parcel.nameR,
                      enabled: false,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RoundTitleTextfield(
                          title: "Code",
                          hintText: widget.parcel.code,
                          enabled: false,
                          //hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: screenWidth*0.02),
                      Expanded(
                        child: RoundTitleTextfield(
                          title: "Parcel No",
                          hintText: widget.parcel.parcelNo.toString(),
                          enabled: false,
                          //hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.01),
                  Row(
                    children: [
                      Expanded(
                        child: RoundTitleTextfield(
                          title: "Date Managed",
                          hintText: DateFormat('yyyy-MM-dd').format(widget.parcel.dateManaged),
                          enabled: false,
                        ),
                      ),
                      SizedBox(width: screenWidth*0.02),
                      Expanded(
                        child: RoundTitleTextfield(
                          title: "Phone Number",
                          hintText: widget.parcel.phoneR,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RoundTitleTextfield(
                      title: "Tracking Number",
                      hintText: widget.parcel.trackNo,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RoundTitleTextfield(
                      title: "Color",
                      hintText: widget.parcel.color,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownButtonFormField<String>(
                      value: selectedCollect,
                      items: collectOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          // Update the selected status
                          setState(() {
                            selectedCollect = newValue;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Collect Option',
                        //hintText: '${_optCollectController.text}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  if (selectedCollect == 'Boxes')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: _collectDateController,
                        decoration: InputDecoration(
                          fillColor: Colors.pink,
                          labelText: "Date of Parcel Retrieval",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              retrievalDate = pickedDate;
                              _collectDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RoundTitleTextfield(
                      title: "Size",
                      hintText: widget.parcel.size,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RoundTitleTextfield(
                      title: "Status",
                      hintText: widget.parcel.status,
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RoundTitleTextfield(
                      title: "Charge",
                      hintText: 'RM ${widget.parcel.charge.toString()}',
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          updateParcel();

                          // Navigate to SplashView
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SplashUpdateView(user: widget.user)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: TColor.button, // Set the text color here
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth*0.15,
                            vertical: screenHeight*0.014,
                          ), // Adjust padding if needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17), // Adjust border radius if needed
                          ),
                        ),
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
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    width: screenWidth*0.9,
                                    height: screenHeight*0.7,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment(0.8, 1),
                                        colors: <Color>[
                                          Color(0xFFFEEDFC),
                                          Colors.white,
                                          Color(0xFFE4E6F7),
                                          Color(0xff673F69),
                                        ],
                                        tileMode: TileMode.mirror,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          width: screenWidth*0.7,
                                          height: screenHeight*0.4,
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
                                                Colors.green,
                                              ],
                                              tileMode: TileMode.clamp,
                                            ),
                                          ),
                                          child: Image.network(
                                            qrURL, // Use the qrURL for the QR code image URL
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight*0.03),
                                        Column(
                                          children: [
                                            Text(
                                              'Your Generated QR Code!',
                                              style: TextStyle(
                                                fontFamily: 'poppins_bold',
                                                fontSize: screenHeight*0.025,
                                                color: Color(0xFF6565FF),
                                              ),
                                            ),
                                            Text(
                                              "This is your unique QR code for parcel collection.",
                                              style: TextStyle(
                                                fontFamily: 'poppins_regular',
                                                fontSize: screenHeight*0.02,
                                              ),
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: TColor.moreButton, // Set the text color here
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth*0.05,
                            vertical: screenHeight*0.014,
                          ), // Adjust padding if needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17), // Adjust border radius if needed
                          ),
                        ),
                        child: Text(showQRCode ? 'Hide QR Code' : 'Show QR Code'),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        );

  }

  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save'),
          content: const Text('Are you sure you want to save the option collection?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updateParcel();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SplashUpdateView(user: widget.user)),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void showQR() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              width: screenWidth * 0.9,
              height: screenHeight * 0.7,
              decoration: const BoxDecoration(
                color: Colors.black,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xFFFEEDFC),
                    Colors.white,
                    Color(0xFFE4E6F7),
                    Color(0xff673F69),
                  ],
                  tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.4,
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
                          Colors.green,
                        ],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Image.network(
                      qrURL,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Column(
                    children: [
                      Text(
                        'Your Generated QR Code!',
                        style: TextStyle(
                          fontFamily: 'poppins_bold',
                          fontSize: screenHeight * 0.025,
                          color: Color(0xFF6565FF),
                        ),
                      ),
                      Text(
                        "This is your unique QR code for parcel collection.",
                        style: TextStyle(
                          fontFamily: 'poppins_regular',
                          fontSize: screenHeight * 0.02,
                        ),
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
    // Toggle showQRCode flag
    setState(() {
      showQRCode = !showQRCode;
    });
  }

  void sendMessage(int parcelNo, String messageText, {DateTime? retrievalDate}) {
    // Create a message object
    Message message = Message(
      message: messageText,
      parcelNo: parcelNo,
      datecMessage: Timestamp.now(),
      retrievalDate: retrievalDate != null ? Timestamp.fromDate(retrievalDate) : null,
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
    String newStatus = widget.parcel.status;
    DateTime? newRetrievalDate = retrievalDate;

    // Check if optCollect is changed from Boxes to Counter
    if (newOptCollect == 'Counter') {
      newStatus = 'Not Collected';
      newRetrievalDate = DateTime.now();
    } else if (newOptCollect == 'Boxes') {
      newStatus = 'Out Box';
    }

    // Create a map of updated values
    Map<String, dynamic> updatedData = {
      'optCollect': newOptCollect,
      'status': newStatus,
      'collectDate': newRetrievalDate,
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
          if (newOptCollect == 'Boxes' && retrievalDate != null) {
            // Send message if optCollect is "Box"
            sendMessage(widget.parcel.parcelNo, 'request to collect parcel at box', retrievalDate: retrievalDate);
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
