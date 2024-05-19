import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String college;
  final String email;
  final String mobile;
  final String name;

  // Add other attributes as needed

  User({
    required this.college,
    required this.email,
    required this.mobile,
    required this.name,
    // Add other attributes as needed
  });

  // Static method to create a Parcel object from a map
  static User fromMap(Map<String, dynamic> map) {
    return User(
        college: map['college'],
        email: map['email'],
        mobile: map['mobile'],
        name: map['name'],
    );
  }

  // Convert Parcel object to a map
  Map<String, dynamic> toMap() {
    return {
      'college': college,
      'email': email,
      'mobile': mobile,
      'name': name,

    };
  }

}