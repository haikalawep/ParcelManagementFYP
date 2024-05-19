import 'package:cloud_firestore/cloud_firestore.dart';

class Parcel {
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
  final String qrURL;
  final String trackNo; // New field for QR code data

  Parcel({
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
    required this.qrURL,
    required this.trackNo, // Include qrCodeData in the constructor
  });

  // Static method to create a Parcel object from a map
  static Parcel fromMap(Map<String, dynamic> map) {
    return Parcel(
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
      qrURL: map['qrURL'],
      trackNo: map['trackNo'],
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
      'qrURL': qrURL,
      'trackNo': trackNo, // Include qrCodeData in the toMap method
    };
  }
}
