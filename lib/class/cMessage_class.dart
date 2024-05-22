import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final int parcelNo;
  final Timestamp datecMessage;

  Message({
    required this.message,
    required this.parcelNo,
    required this.datecMessage,
  });

  // Method to convert a Message object to a map
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'parcelNo': parcelNo,
      'timestamp': datecMessage,
    };
  }

  // Method to create a Message object from a map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] ?? '',
      parcelNo: map['parcelNo'] ?? 0,
      datecMessage: map['timestamp'] ?? Timestamp.now(),
    );
  }

  // Method to create a Message object from a Firestore document snapshot
  factory Message.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      message: data['message'] ?? '',
      parcelNo: data['parcelNo'] ?? 0,
      datecMessage: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
