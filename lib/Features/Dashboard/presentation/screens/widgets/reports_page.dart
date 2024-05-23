import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Map<String, dynamic>> _reports = [];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('report')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _reports = querySnapshot.docs.map((doc) {
        return {
          'message': doc['message'],
          'timestamp': (doc['timestamp'] as Timestamp).toDate(),
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(report['message']),
                      subtitle: Text(report['timestamp'].toString()),
                    ),
                    if (index < _reports.length - 1)
                      Divider(),  // Add a Divider between the items
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
