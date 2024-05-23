import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double? _charge;
  final TextEditingController _controller = TextEditingController();
  String? _docId;

  @override
  void initState() {
    super.initState();
    _fetchCharge();
  }

  Future<void> _fetchCharge() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('commission').limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      String chargeStr = doc['charge'].toString().replaceAll('%', '').trim();
      double charge = double.tryParse(chargeStr) ?? 0.0;
      setState(() {
        _charge = charge;
        _controller.text = _charge.toString();
        _docId = doc.id;  // Store the document ID
      });
    }
  }

  Future<void> _updateCharge() async {
    if (_docId != null) {
      double newCharge = double.tryParse(_controller.text) ?? _charge!;
      await FirebaseFirestore.instance.collection('commission').doc(_docId!).update({'charge': newCharge});
      setState(() {
        _charge = newCharge;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_charge != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Charge Percentage:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_charge%',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Set New Charge Percentage',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateCharge,
                  child: const Text('Update Charge'),
                ),
              ],
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
