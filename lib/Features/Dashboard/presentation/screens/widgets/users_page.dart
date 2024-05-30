import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Features/Dashboard/presentation/models/users.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> _users = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _users = querySnapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    });
  }

  void _toggleBan(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.email).update({
      'isBanned': !user.isBanned,
    });
    setState(() {
      user.isBanned = !user.isBanned;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((user) {
      return user.email.toLowerCase().contains(_searchQuery.toLowerCase());
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
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Middle Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Birthday')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Verification Status')),
                  DataColumn(label: Text('Ban')),
                ],
                rows: filteredUsers.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user.firstName)),
                    DataCell(Text(user.middleName)),
                    DataCell(Text(user.lastName)),
                    DataCell(Text(user.birthday)),
                    DataCell(Text(user.address)),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.isVerified ? 'Verified' : 'Unverified')),
                    DataCell(
                      Switch(
                        value: user.isBanned,
                        onChanged: (value) {
                          _toggleBan(user);
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
