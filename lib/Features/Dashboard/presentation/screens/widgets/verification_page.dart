import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Features/Dashboard/presentation/models/verification.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  List<Verification> _verifications = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchVerifications();
  }

  Future<void> _fetchVerifications() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('id_verification').get();
    setState(() {
      _verifications = querySnapshot.docs.map((doc) => Verification.fromFirestore(doc)).toList();
    });
  }

  void _showImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              width: 300,
              height: 300,
              imageUrl,
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

  void _toggleVerification(String email, bool isVerified) async {
    // Query the user with the given email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('id_verification')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      DocumentSnapshot doc2 = querySnapshot2.docs.first;
      await doc.reference.update({'isVerified': isVerified});
      await doc2.reference.update({'isVerified': isVerified});
      setState(() {
        int index = _verifications.indexWhere((verification) => verification.email == email);
        if (index != -1) {
          _verifications[index] = _verifications[index].copyWith(isVerified: isVerified);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredVerifications = _verifications.where((verification) {
      return verification.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search',
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
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('ID Type')),
                  DataColumn(label: Text('Back ID')),
                  DataColumn(label: Text('Front ID')),
                  DataColumn(label: Text('Selfie')),
                  DataColumn(label: Text('Approve')),
                ],
                rows: filteredVerifications.map((verification) {
                  return DataRow(cells: [
                    DataCell(Text(verification.email)),
                    DataCell(Text(verification.selectedId)),
                    DataCell(
                      InkWell(
                        onTap: () => _showImage(verification.backIdUrl),
                        child: Image.network(
                          verification.backIdUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    DataCell(
                      InkWell(
                        onTap: () => _showImage(verification.frontIdUrl),
                        child: Image.network(
                          verification.frontIdUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    DataCell(
                      InkWell(
                        onTap: () => _showImage(verification.selfieUrl),
                        child: Image.network(
                          verification.selfieUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    DataCell(
                      Switch(
                        value: verification.isVerified,
                        onChanged: (value) {
                          _toggleVerification(verification.email, value);
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
