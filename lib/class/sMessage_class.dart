import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMessage {
  final String sMessage;
  final int parcelNo;
  final Timestamp datesMessage;

  StaffMessage({
    required this.sMessage,
    required this.parcelNo,
    required this.datesMessage,
  });

  // Method to convert a Message object to a map
  Map<String, dynamic> toMap() {
    return {
      'message': sMessage,
      'parcelNo': parcelNo,
      'timestamp': datesMessage,
    };
  }

  // Method to create a Message object from a map
  factory StaffMessage.fromMap(Map<String, dynamic> map) {
    return StaffMessage(
      sMessage: map['message'] ?? '',
      parcelNo: map['parcelNo'] ?? 0,
      datesMessage: map['timestamp'] ?? Timestamp.now(),
    );
  }

  // Method to create a Message object from a Firestore document snapshot
  factory StaffMessage.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StaffMessage(
      sMessage: data['message'] ?? '',
      parcelNo: data['parcelNo'] ?? 0,
      datesMessage: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
