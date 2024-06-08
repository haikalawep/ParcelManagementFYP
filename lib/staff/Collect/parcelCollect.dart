import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/common/round_Button.dart';
import 'package:parcelmanagement/staff/Collect/SplashCollect.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ParcelCollectPage extends StatefulWidget {
  @override
  _ParcelCollectPageState createState() => _ParcelCollectPageState();
}

class _ParcelCollectPageState extends State<ParcelCollectPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         // if (result != null)
          //         //   Text(
          //         //     'Data: ${result!.code}',
          //         //   )
          //         // else
          //         //   const Text('Scan the QR Code'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      // Removed the overlay parameter to eliminate the border
      // overlay: QrScannerOverlayShape(
      //   borderColor: Colors.red,
      //   borderRadius: 10,
      //   borderLength: 30,
      //   borderWidth: 10,
      //   cutOutSize: scanArea,
      // ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null && result!.code != null) {
        String scannedQRData = result!.code!;

        try {
          List<String> scannedDataList = scannedQRData.split(';');

          if (scannedDataList.length >= 1) {
            int parcelID = int.parse(scannedDataList[0]);

            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('parcelD')
                .where('parcelID', isEqualTo: parcelID)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              // Parcel number matches with Firestore data
              // Extract details from Firestore document
              DocumentSnapshot docSnapshot = querySnapshot.docs.first;
              String nameR = docSnapshot['nameR'];
              String code = docSnapshot['code'];
              int charge = docSnapshot['charge'];
              int parcelNo = docSnapshot['parcelNo'];
              String size = docSnapshot['size'];
              String color = docSnapshot['color'];
              String phoneR = docSnapshot['phoneR'];
              String optCollect = docSnapshot['optCollect'];
              String trackNo = docSnapshot['trackNo'];

              // Display details in an AlertDialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  controller.pauseCamera();
                  return AlertDialog(
                    title: Text('Details of Parcel'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Parcel No: ${parcelNo.toString()}'), // Convert int to String
                        Text('Name: $nameR'),
                        Text('Code: $code'),
                        Text('Charge: $charge'),
                      ],
                    ),
                    actions: <Widget>[
                      RoundButton(
                        onPressed: () async {
                          Timestamp currentDate = Timestamp.now();

                          String historyId = 'history_$parcelNo';

                          // Get a reference to the document
                          DocumentReference docRef = FirebaseFirestore.instance.collection('history').doc(historyId);

                          await docRef.set({
                            'nameR': nameR,
                            'code': code,
                            'charge': charge,
                            'parcelNo': parcelNo,
                            'dateManaged': currentDate,
                            'size': size,
                            'color': color,
                            'phoneR': phoneR,
                            'status': 'Collected',
                            'optCollect': optCollect,
                            'trackNo': trackNo,
                            'parcelID': parcelID,
                          });

                          await docSnapshot.reference.delete();

                          Navigator.pop(context); // Close the dialog
                          Navigator.popUntil(context, ModalRoute.withName('/')); // Pop until the HomeTab is reached
                          Navigator.push( // Push a new route to the CollectPage
                            context,
                            MaterialPageRoute(builder: (context) => SplashCollectView()),
                          );

                        },
                        title: 'Confirm',
                      ),
                    ],
                  );
                },
              ).then((_) {
                // Resume the camera when the dialog is dismissed
                controller.resumeCamera();
              });
            } else {
              // No matching parcel number found in Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Parcel number does not match Firestore')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid QR code data')),
            );
          }
        } catch (e) {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    });
  }

  void _onPermissionSet(
      BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No permission to access camera')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
