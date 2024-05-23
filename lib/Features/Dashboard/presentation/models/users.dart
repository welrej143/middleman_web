import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final bool isVerified;
  bool isBanned;

  User({
    required this.email,
    required this.isVerified,
    this.isBanned = false,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      email: data['email'] ?? '',
      isVerified: data['isVerified'] ?? false,
      isBanned: data['isBanned'] ?? false,
    );
  }
}
