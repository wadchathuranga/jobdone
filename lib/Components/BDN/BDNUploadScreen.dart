import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum Actions { delete, upload, genJSON }

class BDNUploadScreen extends StatefulWidget {
  const BDNUploadScreen({super.key});

  @override
  State<BDNUploadScreen> createState() => _BDNUploadScreenState();
}

class _BDNUploadScreenState extends State<BDNUploadScreen> {

  List<Map<String, dynamic>> BDN = [
    {
      "isUpload": false
    },
    {
      "isUpload": false
    },
    {
      "isUpload": true
    }
  ];

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
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
        title: const Text('BDN Upload'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SlidableAutoCloseBehavior(
              closeWhenOpened: true,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: BDN.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 3,
                    child: Slidable(
                      key: ValueKey(index),
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            autoClose: false,
                            onPressed: (_) {
                              _onDismissed(Actions.delete, BDN[index]);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {},
                            backgroundColor: const Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.cloud_upload,
                            label: 'Upload',
                          ),
                          SlidableAction(
                            onPressed: (_) {},
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.save,
                            label: 'JSON',
                          ),
                        ],
                      ),

                      child: ListTile(
                        title: Text('JOB123456'),
                        subtitle: Text('Issued Date'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isConnected)
                              const IconButton(
                                icon: Icon(
                                  Icons.signal_wifi_connected_no_internet_4,
                                  color: Colors.red,
                                  size: 35,
                                ),
                                onPressed: null,
                              )
                            else if (BDN[index]['isUpload'] == true)
                            const IconButton(
                              icon: Icon(
                                Icons.cloud_done,
                                color: Colors.green,
                                size: 35,
                              ),
                              onPressed: null,
                            )
                            else if (BDN[index]['isUpload'] == false)
                            const IconButton(
                              icon: Icon(
                                Icons.cloud_upload,
                                color: Colors.blue,
                                size: 35,
                              ),
                              onPressed: null,
                            ),
                          ],
                        ),
                        onTap: null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onDismissed(Actions action, data) {
    // setState(() => _semesters.removeAt(index));
    switch (action) {
      case Actions.delete:
        showAlertDialog(
          context,
          alertMsg:  "Do you want to delete Year all the exam results as well...",
        );
        break;
      case Actions.upload:
        // TODO: Handle this case.
        break;
      case Actions.genJSON:
        // TODO: Handle this case.
        break;
    }
  }

  /// Alert dialog for checking semester delete confirmation
  showAlertDialog(context, {required String alertMsg}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(
          color: Colors.deepPurple,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Yes",
        style: TextStyle(
          color: Colors.deepPurple,
        ),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Are you sure..?"),
      content: Text(alertMsg),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
