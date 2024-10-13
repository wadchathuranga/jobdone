import 'package:flutter/material.dart';

class DeliveryNoteScreen extends StatefulWidget {
  const DeliveryNoteScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryNoteScreen> createState() => _DeliveryNoteScreenState();
}

class _DeliveryNoteScreenState extends State<DeliveryNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BDN Details'),
      ),
      body: const Center(
        child: Text('Delivery Note Screen'),
      ),
    );
  }
}
