import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/widgets/dispute_page.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/widgets/reports_page.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/widgets/settings_page.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/widgets/transaction_page.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/widgets/users_page.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/widgets/verification_page.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/widgets/withdraw_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const UsersPage(),
    const VerificationPage(),
    const SettingsPage(),
    const TransactionPage(),
    const WithdrawPage(),
    const DisputePage(),
    const ReportsPage(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected;

  const Sidebar({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Dashboard Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Users'),
            onTap: () => onItemSelected(0),
          ),
          ListTile(
            leading: const Icon(Icons.verified_rounded),
            title: const Text('Verification'),
            onTap: () => onItemSelected(1),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => onItemSelected(2),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Transaction'),
            onTap: () => onItemSelected(3),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Withdraw'),
            onTap: () => onItemSelected(4),
          ),
          ListTile(
            leading: const Icon(Icons.error),
            title: const Text('Dispute'),
            onTap: () => onItemSelected(5),
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: () => onItemSelected(6),
          ),
        ],
      ),
    );
  }
}

class User {
  final String email;
  final bool isVerified;
  bool isBanned;

  User({
    required this.email,
    required this.isVerified,
    this.isBanned = false,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      email: data['email'] ?? '',
      isVerified: data['isVerified'] ?? false,
      isBanned: data['isBanned'] ?? false,
    );
  }
}
