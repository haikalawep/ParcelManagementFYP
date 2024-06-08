import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String nameR;
  final DateTime dateManaged;
  final String code;
  final String color;
  final int charge;
  final String optCollect;
  final int parcelNo;
  final String phoneR;
  final String size;
  final String status;
  final String trackNo;
  final int parcelID;// New field for QR code data

  History({
    required this.nameR,
    required this.dateManaged,
    required this.code,
    required this.color,
    required this.charge,
    required this.optCollect,
    required this.parcelNo,
    required this.phoneR,
    required this.size,
    required this.status,
    required this.trackNo,
    required this.parcelID,// Include qrCodeData in the constructor
  });

  // Static method to create a Parcel object from a map
  static History fromMap(Map<String, dynamic> map) {
    return History(
      nameR: map['nameR'],
      dateManaged: (map['dateManaged'] as Timestamp).toDate(),
      code: map['code'],
      color: map['color'],
      optCollect: map['optCollect'],
      size: map['size'],
      status: map['status'],
      phoneR: map['phoneR'],
      parcelNo: map['parcelNo'],
      charge: map['charge'],
      trackNo: map['trackNo'],
      parcelID: map['parcelID'],
    );
  }

  // Convert Parcel object to a map
  Map<String, dynamic> toMap() {
    return {
      'nameR': nameR,
      'dateManaged': dateManaged,
      'code': code,
      'color': color,
      'optCollect': optCollect,
      'size': size,
      'status': status,
      'phoneR': phoneR,
      'parcelNo': parcelNo,
      'charge': charge,
      'trackNo': trackNo,
      'parcelID': parcelID, //Data in the toMap method
    };
  }
}
