import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parcelmanagement/common/color_extension.dart';
import 'package:parcelmanagement/common/roundTextfield.dart';
import 'package:parcelmanagement/common/round_Button.dart';
import 'package:parcelmanagement/view/SplashWelcome.dart';
import 'package:parcelmanagement/view/loginPage.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';


class ParcelDetailView extends StatefulWidget {
  final String name;
  final String phoneNumber;

  const ParcelDetailView({Key? key, required this.name, required this.phoneNumber}) : super(key: key);

  @override
  _ParcelDetailViewState createState() => _ParcelDetailViewState();
}

class _ParcelDetailViewState extends State<ParcelDetailView> {
  TextEditingController txtCode = TextEditingController();
  TextEditingController txtNoParcel = TextEditingController();
  TextEditingController txtNameR = TextEditingController();
  TextEditingController txtPhoneR = TextEditingController();
  TextEditingController txtColor = TextEditingController();
  TextEditingController txtSize = TextEditingController();
  TextEditingController txtTrackingNumber = TextEditingController();

  String selectedSize = '';

  @override
  void initState() {
    super.initState();

    // Set initial values for name and phone number text fields
    txtNameR.text = widget.name;
    txtPhoneR.text = widget.phoneNumber;

    getCode();
    getCurrentNo();
  }

  Future<String> getCurrentNo() async {
    try {
      // Reference to the 'lastParcelNo' document in Firestore
      DocumentSnapshot lastParcelNoDoc = await FirebaseFirestore.instance.collection('metadata').doc('lastParcelNo').get();

      // Get the last used parcel number from the document
      int lastParcelNo = lastParcelNoDoc.exists ? lastParcelNoDoc['parcelNo'] : 0;

      return txtNoParcel.text = (lastParcelNo + 1).toString();
    } catch (e) {
      print('Error fetching last parcel number: $e');
      throw e;
    }
  }


  String generateParcelCode(DateTime date) {

    // Get the day of the week (Monday = 1, Tuesday = 2, ..., Sunday = 7)
    int dayOfWeek = date.weekday;

    // Get the ISO week number
    int weekNumber = DateTime.utc(date.year, date.month, date.day)
        .subtract(Duration(days: (dayOfWeek + 5) % 7))
        .difference(DateTime.utc(date.year, 1, 1))
        .inDays ~/
        7 +
        1;

    // Construct the parcel code based on the day of the week and week number
    String code = '';
    switch (dayOfWeek) {
      case 1:
        int incrementedWeekNumber = weekNumber + 1;
        code = 'MD$incrementedWeekNumber';
        break;
      case 2:
        code = 'TD$weekNumber';
        break;
      case 3:
        code = 'WD$weekNumber';
        break;
      case 4:
        code = 'TH$weekNumber';
        break;
      case 5:
        code = 'FD$weekNumber';
        break;
      case 6:
        code = 'SA$weekNumber';
        break;
      case 7:
        code = 'SUN$weekNumber';
        break;
    }

    return txtCode.text = code;
  }

  void getCode() {
    // Get the current date
    DateTime today = DateTime.now();

    // Generate parcel code for today
    generateParcelCode(today);
  }

  final List<String> sizes = ['Small', 'Medium', 'Big', 'Extra Big'];

  void sendSMS(String recipientPhoneNumber) async {
    try {
      // Replace these values with your Nexmo API key and secret
      String apiKey = 'e4df00a3';
      String apiSecret = 'YVS2aJSY0XnOPL5U';
      String fromNumber = 'Vonage APIs';

      // Construct the request body
      Map<String, dynamic> requestBody = {
        'api_key': apiKey,
        'api_secret': apiSecret,
        'from': fromNumber,
        'to': '6' + recipientPhoneNumber,
        'text': 'Your parcel is ready for collection. Please visit our store to collect it.',
      };

      // Make HTTP POST request to Nexmo API endpoint
      final response = await http.post(
        Uri.parse('https://rest.nexmo.com/sms/json'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      // Check if the SMS was sent successfully
      if (response.statusCode == 200) {
        print('SMS sent successfully');
      } else {
        print('Failed to send SMS');
      }
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }

  int calculateCharge(String size) {
    switch (size) {
      case 'Small':
        return 1;
      case 'Medium':
        return 2;
      case 'Big':
        return 3;
      case 'Extra Big':
        return 4;
      default:
        return 0; // Default charge if size is not recognized
    }
  }

  Future<void> insertParcel() async {
    try {
      // Access the text values from the controllers
      String code = txtCode.text;
      String nameR = txtNameR.text;
      String phoneR = txtPhoneR.text;
      String color = txtColor.text;
      int charge = calculateCharge(selectedSize);
      String trackNumber = txtTrackingNumber.text;

      Timestamp currentDate = Timestamp.now();
      // Get the last used parcel number
      int lastParcelNo = await getLastParcelNumber();
      // Increment the last used parcel number for the next insertion
      int newParcelNo = lastParcelNo + 1;
      // Generate a unique ID using a prefix and the new parcel number
      String uniqueId = 'parcel_$newParcelNo';

      // Get a reference to the document
      DocumentReference docRef = FirebaseFirestore.instance.collection('parcelD').doc(uniqueId);

      // Store the parcel details into Firestore using set() method
      await docRef.set({
        'code': code,
        'parcelNo': newParcelNo,
        'nameR': nameR,
        'phoneR': phoneR,
        'color': color,
        'size': selectedSize,
        'charge': charge,
        'status': 'Not Collected',
        'optCollect': 'Counter',
        'dateManaged': currentDate,
        'collectDate': currentDate,
        'trackNo': trackNumber, // Store the current date
      });

      String qrData = generateUniqueID();
      String qrURL = await generateQRCode(qrData);

      // Update Firestore with the QR code URL
      await docRef.update({'qrURL': qrURL});

      int qrDataInt;
      try {
        qrDataInt = int.parse(qrData);
      } catch (e) {
        // Handle the error, perhaps log it or take another action
        print('Error: qrData is not a valid integer');
        return;  // Exit the function or handle accordingly
      }

// Update Firestore with the parcel ID as an integer
      await docRef.update({'parcelID': qrDataInt});

      // Update the last used parcel number document
      await updateLastParcelNumber(newParcelNo);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insert Successfully')),
      );
      print('QR Code URL: $qrURL');
      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insert Failed: $e')),
      );
    }
  }

  String generateUniqueID() {
    Random random = Random();
    String newID;

    // Generate a random 7-digit number
    int randomNumber = random.nextInt(9000000) + 1000000; // Generates a number between 1000000 and 9999999
    newID = randomNumber.toString();

    return newID;
  }

  Future<int> getLastParcelNumber() async {
    try {
      // Reference to the 'lastParcelNo' document in Firestore
      DocumentSnapshot lastParcelNoDoc = await FirebaseFirestore.instance.collection('metadata').doc('lastParcelNo').get();

      // Get the last used parcel number from the document
      int lastParcelNo = lastParcelNoDoc.exists ? lastParcelNoDoc['parcelNo'] : 0;

      return lastParcelNo;
    } catch (e) {
      print('Error fetching last parcel number: $e');
      throw e;
    }
  }

  Future<void> updateLastParcelNumber(int newParcelNo) async {
    try {
      // Reference to the 'lastParcelNo' document in Firestore
      DocumentReference lastParcelNoRef = FirebaseFirestore.instance.collection('metadata').doc('lastParcelNo');

      // Update the 'lastParcelNo' document with the new parcel number
      await lastParcelNoRef.set({'parcelNo': newParcelNo});
    } catch (e) {
      print('Error updating last parcel number: $e');
      throw e;
    }
  }



  Future<String> generateQRCode(String data) async {
    try {
      // Construct the URL with query parameters
      Uri url = Uri.https('codzz-qr-cods.p.rapidapi.com', '/getQrcode', {
        'type': 'url',
        'value': data,
      });

      // Make HTTP GET request to QR Code Utils API
      final response = await http.get(
        url,
        headers: {
          'X-RapidAPI-Key': 'cb00bdc7e0mshdd599ac166219a1p1cb170jsndf82b2c3cef4',
          'X-RapidAPI-Host': 'codzz-qr-cods.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        // Return the QR code image URL directly
        return json.decode(response.body)['url'];
      } else {
        throw Exception('Failed to generate QR code');
      }
    } catch (e) {
      throw Exception('Failed to generate QR code: $e');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              Text(
                "Parcel Details",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "Add parcel details to store",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Code",
                controller: txtCode,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Parcel No",
                controller: txtNoParcel,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Recipient Name",
                controller: txtNameR,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Recipient Number",
                controller: txtPhoneR,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Parcel Color",
                controller: txtColor,
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Size',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                value: selectedSize == '' ? null : selectedSize,
                onChanged: (String? value) {
                  setState(() {
                    selectedSize = value!;
                  });
                },
                items: sizes.map((String size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: txtTrackingNumber,
                decoration: InputDecoration(
                  hintText: "Tracking Number",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      // Launch QR code scanner
                      String? scannedCode = await scanQRCode();

                      // Update tracking number field with the scanned code
                      if (scannedCode != null) {
                        setState(() {
                          txtTrackingNumber.text = scannedCode;
                        });
                      }
                    },
                    icon: Icon(Icons.qr_code),
                  ),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 25),
              RoundButton(
                  title: "Insert",
                  onPressed: () {
                    insertParcel();
                    sendSMS(txtPhoneR.text);
                    // Navigate to SplashView
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SplashView()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> scanQRCode() async {
    // Create a Completer to handle the asynchronous result of scanning
    Completer<String?> completer = Completer<String?>();

    return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          child: QRView(
            key: GlobalKey(debugLabel: 'QR'),
            onQRViewCreated: (QRViewController controller) {
              // Listen for scanned QR codes
              controller.scannedDataStream.listen((scanData) {
                // Pass the scanned code to the completer
                completer.complete(scanData.code);

                // Update the tracking number field with the scanned code
                setState(() {
                  txtTrackingNumber.text = scanData.code!;
                });

                // Stop scanning QR codes
                controller.dispose();

                // Close the bottom sheet
                Navigator.pop(context);
              });
            },
          ),
        );
      },
    ).then((value) {
      // Return the result of scanning
      return value;
    });
  }


}



