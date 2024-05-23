import 'package:cloud_firestore/cloud_firestore.dart';

class Dispute {
  final String concernCategory;
  final String description;
  final String phoneNumber;
  String status;
  final String ticketNumber;
  final DateTime timestamp;
  final String transactionNumber;

  Dispute({
    required this.concernCategory,
    required this.description,
    required this.phoneNumber,
    required this.status,
    required this.ticketNumber,
    required this.timestamp,
    required this.transactionNumber,
  });

  factory Dispute.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Dispute(
      concernCategory: data['concernCategory'] ?? '',
      description: data['description'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      status: data['status'] ?? 'pending',
      ticketNumber: data['ticketNumber'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      transactionNumber: data['transactionNumber'] ?? '',
    );
  }
}
