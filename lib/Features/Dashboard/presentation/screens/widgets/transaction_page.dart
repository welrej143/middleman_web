import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Features/Dashboard/presentation/models/transaction.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> with SingleTickerProviderStateMixin {
  List<TransactionModel> _transactions = [];
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _transactions = querySnapshot.docs.map((doc) => TransactionModel.fromFirestore(doc)).toList();
    });
  }

  void _updateStatus(TransactionModel transaction, String status) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('transactionId', isEqualTo: transaction.transactionId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      await doc.reference.update({'status': status});
      setState(() {
        transaction.status = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ongoingTransactions = _transactions.where((transaction) => transaction.status != 'completed' && transaction.status != 'cancelled').toList();
    final completedTransactions = _transactions.where((transaction) => transaction.status == 'completed').toList();
    final cancelledTransactions = _transactions.where((transaction) => transaction.status == 'cancelled').toList();

    final filteredOngoingTransactions = ongoingTransactions.where((transaction) {
      return transaction.transactionId.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final filteredCompletedTransactions = completedTransactions.where((transaction) {
      return transaction.transactionId.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final filteredCancelledTransactions = cancelledTransactions.where((transaction) {
      return transaction.transactionId.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search by Transaction ID',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionTable(filteredOngoingTransactions),
                _buildTransactionTable(filteredCompletedTransactions),
                _buildTransactionTable(filteredCancelledTransactions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTable(List<TransactionModel> transactions) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Buyer')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Proof Of Delivery')),
          DataColumn(label: Text('Seller')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Timestamp')),
          DataColumn(label: Text('Transaction ID')),
        ],
        rows: transactions.map((transaction) {
          return DataRow(cells: [
            DataCell(Text(transaction.amount.toString())),
            DataCell(Text(transaction.buyer)),
            DataCell(Text(transaction.description)),
            DataCell(
              transaction.proofOfDeliveryUrl.isNotEmpty
                  ? GestureDetector(
                onTap: () => _showImage(transaction.proofOfDeliveryUrl),
                child: Image.network(
                  transaction.proofOfDeliveryUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : Text('No Proof'),
            ),
            DataCell(Text(transaction.seller)),
            DataCell(Text(transaction.status)),
            DataCell(Text(transaction.timestamp.toDate().toString())),
            DataCell(Text(transaction.transactionId)),
          ]);
        }).toList(),
      ),
    );
  }

  void _showImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              imageUrl,
              width: 300,
              height: 300,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
