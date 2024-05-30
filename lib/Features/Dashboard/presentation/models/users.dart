import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthday;
  final String address;
  final String email;
  final bool isVerified;
  bool isBanned;

  User({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthday,
    required this.address,
    required this.email,
    required this.isVerified,
    this.isBanned = false,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      firstName: data['firstName'] ?? '',
      middleName: data['middleName'] ?? '',
      lastName: data['lastName'] ?? '',
      birthday: data['birthday'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      isVerified: data['isVerified'] ?? false,
      isBanned: data['isBanned'] ?? false,
    );
  }
}
