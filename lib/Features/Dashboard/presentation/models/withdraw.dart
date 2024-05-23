import 'package:cloud_firestore/cloud_firestore.dart';

class Withdraw {
  final String accountNumber;
  final double amount;
  final String bankName;
  final String invoiceNumber;
  final String nameOnCard;
  final Timestamp timestamp;
  final String phoneNumber;
  String status;

  Withdraw({
    required this.accountNumber,
    required this.amount,
    required this.bankName,
    required this.invoiceNumber,
    required this.nameOnCard,
    required this.timestamp,
    required this.phoneNumber,
    required this.status,
  });

  factory Withdraw.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Withdraw(
        accountNumber: data['accountNumber'] ?? '',
        amount: data['amount']?.toDouble() ?? 0.0,
    bankName: data['bankName'] ?? '',
    invoiceNumber: data['invoiceNumber'] ?? '',
    nameOnCard: data['nameOnCard'] ?? '',
    timestamp: data['timestamp'] ?? Timestamp.now(),
      phoneNumber: data['phoneNumber'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }
}

