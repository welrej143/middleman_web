import 'package:cloud_firestore/cloud_firestore.dart';

class Verification {
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthday;
  final String phoneNumber;
  final String address;
  final String email;
  final String selectedId;
  final String backIdUrl;
  final String frontIdUrl;
  final String selfieUrl;
  final bool isVerified;

  Verification({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthday,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.selectedId,
    required this.backIdUrl,
    required this.frontIdUrl,
    required this.selfieUrl,
    required this.isVerified,
  });

  factory Verification.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Verification(
      firstName: data['firstName'] ?? '',
      middleName: data['middleName'] ?? '',
      lastName: data['lastName'] ?? '',
      birthday: data['birthday'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      selectedId: data['selectedId'] ?? '',
      backIdUrl: data['backIdUrl'] ?? '',
      frontIdUrl: data['frontIdUrl'] ?? '',
      selfieUrl: data['selfieUrl'] ?? '',
      isVerified: data['isVerified'] ?? false,
    );
  }

  Verification copyWith({bool? isVerified}) {
    return Verification(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      birthday: birthday,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      selectedId: selectedId,
      backIdUrl: backIdUrl,
      frontIdUrl: frontIdUrl,
      selfieUrl: selfieUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
