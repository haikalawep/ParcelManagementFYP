import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMessage {
  final String sMessage;
  final int parcelNo;
  final DateTime datesMessage;
  final DateTime confirmRetrievalDate;

  StaffMessage({
    required this.sMessage,
    required this.parcelNo,
    required this.datesMessage,
    required this.confirmRetrievalDate,
  });

  // Method to convert a Message object to a map
  Map<String, dynamic> toMap() {
    return {
      'message': sMessage,
      'parcelNo': parcelNo,
      'timestamp': datesMessage,
      'confirmRetrievalDate': confirmRetrievalDate,
    };
  }

  // Method to create a Message object from a map
  factory StaffMessage.fromMap(Map<String, dynamic> map) {
    return StaffMessage(
      sMessage: map['message'] ?? '',
      parcelNo: map['parcelNo'] ?? '',
      datesMessage: map['timestamp'] ?? Timestamp.now(),
      confirmRetrievalDate: map['confirmRetrievalDate'] ?? Timestamp.now(),
    );
  }

  // Method to create a Message object from a Firestore document snapshot
  factory StaffMessage.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StaffMessage(
      sMessage: data['message'] ?? '',
      parcelNo: data['parcelNo'] ?? '',
      datesMessage: data['timestamp'] ?? Timestamp.now(),
      confirmRetrievalDate: data['confirmRetrievalDate'] ?? Timestamp.now(),
    );
  }
}
