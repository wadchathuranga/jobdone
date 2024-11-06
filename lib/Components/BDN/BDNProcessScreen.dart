import 'package:flutter/material.dart';

import 'BDNUploadScreen.dart';

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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('BDN PROCESS SCREEN'),
                ),
                //TODO: check connectivity status and allow user to proceed with the relevant button
                ElevatedButton(
                  child: Text('SAVE BDN'),
                  onPressed: (){},
                ),
                ElevatedButton(
                  child: Text('ISSUE BDN'),
                  onPressed: (){},
                ),
                ElevatedButton(
                  child: Text('DOWNLOAD BDN PDF'),
                  onPressed: (){},
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  BDNUploadScreen(),
            ),
          );
        },
        child: Icon(Icons.add), // Icon inside the FAB
        tooltip: 'Add', // Tooltip shown when the FAB is long-pressed
      ),
    );
  }
}
