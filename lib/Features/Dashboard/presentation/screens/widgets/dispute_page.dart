import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Features/Dashboard/presentation/models/dispute.dart';

class DisputePage extends StatefulWidget {
  const DisputePage({Key? key}) : super(key: key);

  @override
  State<DisputePage> createState() => _DisputePageState();
}

class _DisputePageState extends State<DisputePage> {
  List<Dispute> _disputes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDisputes();
  }

  Future<void> _fetchDisputes() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('disputes')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _disputes = querySnapshot.docs.map((doc) => Dispute.fromFirestore(doc)).toList();
    });
  }

  void _updateStatus(Dispute dispute, String status) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('disputes')
        .where('ticketNumber', isEqualTo: dispute.ticketNumber)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      await doc.reference.update({'status': status});
      setState(() {
        dispute.status = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredDisputes = _disputes.where((dispute) {
      return dispute.transactionNumber.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disputes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Search by Transaction Number',
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
                  DataColumn(label: Text('Concern Category')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Phone Number')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Ticket Number')),
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Transaction Number')),
                ],
                rows: filteredDisputes.map((dispute) {
                  return DataRow(cells: [
                    DataCell(Text(dispute.concernCategory)),
                    DataCell(Text(dispute.description)),
                    DataCell(Text(dispute.phoneNumber)),
                    DataCell(
                      DropdownButton<String>(
                        value: dispute.status,
                        items: ['completed', 'under investigation', 'pending']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _updateStatus(dispute, value);
                          }
                        },
                      ),
                    ),
                    DataCell(Text(dispute.ticketNumber)),
                    DataCell(Text(dispute.timestamp.toString())),
                    DataCell(Text(dispute.transactionNumber)),
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
