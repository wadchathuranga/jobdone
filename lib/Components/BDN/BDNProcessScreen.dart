import 'package:flutter/material.dart';

class BDNProcessScreen extends StatefulWidget {
  const BDNProcessScreen({super.key});

  @override
  State<BDNProcessScreen> createState() => _BDNProcessScreenState();
}

class _BDNProcessScreenState extends State<BDNProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BDN Process'),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('BDN PROCESS SCREEN'),
            ),
          ],
        ),
      ),
    );
  }
}
