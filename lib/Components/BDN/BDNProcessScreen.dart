import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'BDNUploadScreen.dart';

class BDNProcessScreen extends StatefulWidget {
  const BDNProcessScreen({super.key});

  @override
  State<BDNProcessScreen> createState() => _BDNProcessScreenState();
}

class _BDNProcessScreenState extends State<BDNProcessScreen> {
  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    //stateInitiateAndUpdate(); --------------------------------------
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  ///----------------------- Internet Connectivity -----------------------
  bool isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      isConnected = result != ConnectivityResult.none;
    });
    print(isConnected);
  }

  // --------------------------------------
  // Future<List<PropertyInspectionModel>> stateInitiateAndUpdate() async {
  //   data = await PropertyInspectionDB.getAllPropertyInspection();
  //   setState(() {
  //     isLoading = false;
  //   });
  //   return data;
  // }
  ///-------------------------------------------------------------------------

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
                  child: Text('BDN PROCESS'),
                ),
                //TODO: check connectivity status and allow user to proceed with the relevant button
                if (isConnected)
                  ElevatedButton(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width/4,
                      width: MediaQuery.of(context).size.width/4,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload,
                              size: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'ISSUE BDN',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {},
                  )
                else
                  ElevatedButton(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width/4,
                      width: MediaQuery.of(context).size.width/4,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              size: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'SAVE BDN',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                SizedBox(height: 10,),
                ElevatedButton(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width/4,
                    width: MediaQuery.of(context).size.width/4,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download,
                            size: 50,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'DOWNLOAD',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'BDN AS A PDF',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () {},
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
              builder: (context) => BDNUploadScreen(),
            ),
          );
        },
        child: Icon(Icons.add), // Icon inside the FAB
        tooltip: 'Add', // Tooltip shown when the FAB is long-pressed
      ),
    );
  }
}
