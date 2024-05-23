import 'package:cloud_firestore/cloud_firestore.dart';

class Verification {
  final String email;
  final String selectedId;
  final String backIdUrl;
  final String frontIdUrl;
  final String selfieUrl;
  final bool isVerified;

  Verification({
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
      email: email,
      selectedId: selectedId,
      backIdUrl: backIdUrl,
      frontIdUrl: frontIdUrl,
      selfieUrl: selfieUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
