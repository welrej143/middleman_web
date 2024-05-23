import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Features/Dashboard/presentation/models/withdraw.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  List<Withdraw> _withdraws = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchWithdraws();
  }

  Future<void> _fetchWithdraws() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('payout_requests')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _withdraws = querySnapshot.docs.map((doc) => Withdraw.fromFirestore(doc)).toList();
    });
  }

  void _updateStatus(Withdraw withdraw, String status) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('payout_requests')
        .where('invoiceNumber', isEqualTo: withdraw.invoiceNumber)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      await doc.reference.update({'status': status});
      setState(() {
        withdraw.status = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredWithdraws = _withdraws.where((withdraw) {
      return withdraw.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search by Invoice Number',
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
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Account Number')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Bank Name')),
                  DataColumn(label: Text('Invoice Number')),
                  DataColumn(label: Text('Name On Card')),
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Phone Number')),
                  DataColumn(label: Text('Status')),
                ],
                rows: filteredWithdraws.map((withdraw) {
                  return DataRow(cells: [
                    DataCell(Text(withdraw.accountNumber)),
                    DataCell(Text(withdraw.amount.toString())),
                    DataCell(Text(withdraw.bankName)),
                    DataCell(Text(withdraw.invoiceNumber)),
                    DataCell(Text(withdraw.nameOnCard)),
                    DataCell(Text(withdraw.timestamp.toDate().toString())),
                    DataCell(Text(withdraw.phoneNumber)),
                    DataCell(
                      DropdownButton<String>(
                        value: withdraw.status,
                        items: ['completed', 'processed', 'pending']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _updateStatus(withdraw, value);
                          }
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
