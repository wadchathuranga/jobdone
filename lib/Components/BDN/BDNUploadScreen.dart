import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
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
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (c, element) {
        return Card(
          elevation: 5,
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
                    deleteBdnFromDB(element);
                  },
              ),
              children: [
                SlidableAction(
                  autoClose: true,
                  onPressed: (_) async {
                    final result = await _showDeleteConfirmation();
                    if (!result) {
                      return;// Manually close if cancelled
                    }
                    deleteBdnFromDB(element);
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
                  onPressed: (_) => _uploadBDN(element['jobItemID']),
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.cloud_upload,
                  label: 'Upload',
                ),
                SlidableAction(
                  onPressed: (_) => _downloadJSON(element['jobItemID']),
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
                    Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(element['createdAt']))),
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

  /// UPLOAD METHOD
  Future<void> _uploadBDN(int jobItemID) async {
    // TODO: check BDN already uploaded or not

    BDN bdnInfo = await BDNInfoDB.getBDNByJobItemID(jobItemID);

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

  /// DOWNLOAD JSON FILE METHOD
  Future<void> _downloadJSON(int jobItemID) async {
    BDN bdnInfo = await BDNInfoDB.getBDNByJobItemID(jobItemID);

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

  /// DELETE METHOD
  void deleteBdnFromDB(element) {
    //TODO: make this proper way on the DB side as well

    setState(() {
      bdnList.removeWhere((item) =>
      item['bdnID'] == element['bdnID']);
    });
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



}
