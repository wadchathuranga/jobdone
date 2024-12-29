import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobdone/Databases/bdn_queries.dart';
import 'package:jobdone/Models/BDNModel.dart';
import 'package:page_transition/page_transition.dart';

import '../../core/CustomNotification.dart';
import 'BDNUploadScreen.dart';
import '../../core/DownloadJSONFile.dart';

class BDNSaveScreen extends StatefulWidget {
  const BDNSaveScreen({super.key, required this.bdnData});

  final BDN bdnData;

  @override
  State<BDNSaveScreen> createState() => _BDNSaveScreenState();
}

class _BDNSaveScreenState extends State<BDNSaveScreen> {
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
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('BDN COMPLETION'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isConnected)
                  ElevatedButton(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width / 4,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
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
                              'SAVE BDN',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: _saveBDNInfo,
                  )
                else
                  ElevatedButton(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width / 4,
                        width: MediaQuery.of(context).size.width / 4,
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save,
                                size: 50,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ISSUE BDN',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onPressed: () async {
                        //TODO: save BDN in BDN table of local DB

                        // Download BDN as a JSON File
                        //await downloadJSONFile(context, widget.bdnData);
                      }),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!context.mounted) return;
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: const BDNUploadScreen(),
              inheritTheme: true,
              ctx: context,
            ),
          );
        }, // Icon inside the FAB
        tooltip: 'BDN List',
        child: const Icon(Icons.library_books), // Tooltip shown when the FAB is long-pressed
      ),
    );
  }

  void _saveBDNInfo() async {
    var msg = "";

    bool res = await BDNInfoDB.saveBDNInfoToDB(widget.bdnData);

    if (res) {
      msg = "BDN Saved.";
      if (!mounted) return;
      CustomNotification.showSuccess(context: context, message: msg);
    } else {
      msg = "BDN Already Completed!";
      if (!mounted) return;
      CustomNotification.showInfo(context: context, message: msg);
    }

    //TODO: upload BDN to the server DB

    // final snackBar = SnackBar(
    //   content: const Text('BDN Uploading... Please Wait...'),
    //   action: SnackBarAction(
    //     label: 'Dismiss',
    //     onPressed: () {
    //       // Perform an action
    //     },
    //   ),
    //   duration: const Duration(seconds: 3),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
