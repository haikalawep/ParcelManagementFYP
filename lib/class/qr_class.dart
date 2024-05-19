import 'package:cloud_firestore/cloud_firestore.dart';

class QR {
  final String imageUrl;
  final String TestName;
  final String TestPhone;
  final String TestEmail;


  QR({
    required this.imageUrl,
    required this.TestName,
    required this.TestPhone,
    required this.TestEmail,
  });

  // Static method to create a Parcel object from a map
  static QR fromMap(Map<String, dynamic> map) {
    return QR(
      imageUrl: map['imageUrl'],
      TestName: map['TestName'],
      TestPhone: map['TestPhone'],
      TestEmail: map['TestEmail'],

    );
  }

  // Convert Parcel object to a map
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'TestName': TestName,
      'TestPhone': TestPhone,
      'TestEmail': TestEmail,
    };
  }
}
