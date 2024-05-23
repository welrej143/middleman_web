import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final int amount;
  final String buyer;
  final String description;
  final String proofOfDeliveryUrl;
  final String seller;
  String status;
  final Timestamp timestamp;
  final String transactionId;

  TransactionModel({
    required this.amount,
    required this.buyer,
    required this.description,
    required this.proofOfDeliveryUrl,
    required this.seller,
    required this.status,
    required this.timestamp,
    required this.transactionId,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return TransactionModel(
      amount: data['amount'] ?? 0,
      buyer: data['buyer'] ?? '',
      description: data['description'] ?? '',
      proofOfDeliveryUrl: data['proofOfDeliveryUrl'] ?? '',
      seller: data['seller'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      transactionId: data['transactionId'] ?? '',
    );
  }
}
