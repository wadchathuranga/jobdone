import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jobdone/Models/BDNModel.dart';

import '../../Databases/bdn_queries.dart';
import '../../Models/BDNModel.dart';
import '../../core/CustomNotification.dart';
import '../../core/DownloadJSONFile.dart';

enum Actions { delete, upload, genJSON }

class BDNUploadScreen extends StatefulWidget {
  const BDNUploadScreen({super.key});

  @override
  State<BDNUploadScreen> createState() => _BDNUploadScreenState();
}

class _BDNUploadScreenState extends State<BDNUploadScreen> {
  List<Map<String, dynamic>> bdnList = [];

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    //stateInitiateAndUpdate(); --------------------------------------

    getBdnList();
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  void getBdnList() async {
    bdnList = (await BDNInfoDB.getJobListByDate());
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
              child: _createGroupedListView(),
              // child: ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: bdnList.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return Card(
              //       elevation: 3,
              //       child: Slidable(
              //         key: ValueKey(index),
              //         startActionPane: ActionPane(
              //           motion: const DrawerMotion(),
              //           children: [
              //             SlidableAction(
              //               autoClose: false,
              //               onPressed: (_) {
              //                 _onDismissed(Actions.delete, bdnList[index]);
              //               },
              //               backgroundColor: const Color(0xFFFE4A49),
              //               foregroundColor: Colors.white,
              //               icon: Icons.delete,
              //               label: 'Delete',
              //             ),
              //           ],
              //         ),
              //         endActionPane: ActionPane(
              //           motion: const DrawerMotion(),
              //           children: [
              //             SlidableAction(
              //               onPressed: (_) => _uploadBDN(),
              //               backgroundColor: const Color(0xFF0392CF),
              //               foregroundColor: Colors.white,
              //               icon: Icons.cloud_upload,
              //               label: 'Upload',
              //             ),
              //             SlidableAction(
              //               onPressed: (_) => _downloadJSON(),
              //               backgroundColor: Colors.green,
              //               foregroundColor: Colors.white,
              //               icon: Icons.save,
              //               label: 'JSON',
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(5.0),
              //           child: ListTile(
              //             title: Text(bdnList[index].bdnNo!),
              //             subtitle: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Text(bdnList[index].jobNo.toString()),
              //                     Text('  |  '),
              //                     Text('LSFO'),
              //                   ],
              //                 ),
              //                 Text(DateTime.now().toString()),
              //               ],
              //             ),
              //             trailing: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 if (!isConnected)
              //                   const IconButton(
              //                     icon: Icon(
              //                       Icons.signal_wifi_connected_no_internet_4,
              //                       color: Colors.red,
              //                       size: 35,
              //                     ),
              //                     onPressed: null,
              //                   )
              //                 else if (bdnList[index].isUpload == true)
              //                   const IconButton(
              //                     icon: Icon(
              //                       Icons.cloud_done,
              //                       color: Colors.green,
              //                       size: 35,
              //                     ),
              //                     onPressed: null,
              //                   )
              //                 else if (bdnList[index].isUpload == false)
              //                   const IconButton(
              //                     icon: Icon(
              //                       Icons.cloud_upload,
              //                       color: Colors.blue,
              //                       size: 35,
              //                     ),
              //                     onPressed: null,
              //                   ),
              //               ],
              //             ),
              //             onTap: null,
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createGroupedListView() {
    return GroupedListView<dynamic, dynamic>(
      shrinkWrap: true,
      elements: bdnList,
      groupBy: (element) => element['jobNo'].toString(),
      //groupComparator: (value1, value2) => value2.compareTo(value1),
      //itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: true,
      groupSeparatorBuilder: (value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (c, element) {
        return Card(
          elevation: 3,
          child: Slidable(
            key: ValueKey(element['bdnID']),
            closeOnScroll: true,  // Closes when list is scrolled
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(
                  closeOnCancel: true,  // Close on cancel tap
                  confirmDismiss: () async {
                    final controller = Slidable.of(context);
                    final result = await _showDeleteConfirmation();
                    if (!result) {
                      controller?.close();  // Manually close if cancelled
                    }
                    return result;
                  },
                  onDismissed: () {
                    //TODO: make this proper way
                    setState(() {
                      bdnList.removeWhere((item) =>
                      item['bdnID'] == element['bdnID']);
                    });
                  },
              ),
              children: [
                SlidableAction(
                  autoClose: false,
                  onPressed: (_) {
                    //_onDismissedConfirm(element);
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
                  onPressed: (_) => _uploadBDN(element['jobItemID'], element['bdnID']),
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.cloud_upload,
                  label: 'Upload',
                ),
                SlidableAction(
                  onPressed: (_) => _downloadJSON(element['jobItemID'], element['bdnID']),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'JSON',
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                title: Text(element['bdnNo'].toString()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(element['bargeBdnNo'].toString()),
                        const Text('  |  '),
                        Text(element['jobProductCode'].toString()),
                      ],
                    ),
                    Text(DateTime.now().toString()),
                  ],
                ),
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
                    else if (element['isUpload'] == true)
                      const IconButton(
                        icon: Icon(
                          Icons.cloud_done,
                          color: Colors.green,
                          size: 35,
                        ),
                        onPressed: null,
                      )
                    else if (element['isUpload'] == false)
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
          ),
        );
      },
    );
  }

  Future<void> _uploadBDN(int jobItemID, int bdnID) async {
    // TODO: check BDN already uploaded or not

    BDN bdnInfo = await BDNInfoDB.getBDNByJobItemID(jobItemID, bdnID);

    // TODO: create API call to upload BDN to server

    if(!mounted){
      return;
    }
    // Show alert
    CustomNotification.showSuccess(
      context: context,
      message: "BDN ${bdnInfo.bdnNo} Uploaded.",
    );
  }

  Future<void> _downloadJSON(int jobItemID, int bdnID) async {
    BDN bdnInfo = await BDNInfoDB.getBDNByJobItemID(jobItemID, bdnID);

    // Download BDN as a JSON File
    if(!mounted){
      return;
    }
    await downloadJSONFile(context, bdnInfo);

    if(!mounted){
      return;
    }
    CustomNotification.showSuccess(
      context: context,
      message: "BDN ${bdnInfo.bdnNo} Downloaded.",
    );
  }

  /// Alert dialog for delete confirmation
  Future<bool> _showDeleteConfirmation() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  _onDismissedConfirm(Actions action, element) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure..?"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              onPressed: () async {
                setState(() {
                  bdnList.removeWhere((item) =>
                  item['bdnID'] == element['bdnID']);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
