import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../BDN/BDNScreen.dart';
import '../BDN/DeliveryNoteScreen/DeliveryNoteScreen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key? key}) : super(key: key);

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  // Sample JSON-like data for jobItems
  final List<Map<String, dynamic>> jobItems = [
    {
      "jobItemDTID": 608,
      "productCode": "HSFO",
      "maxQty": 300.3,
      "minQty": 280,
      "isItemExist": 0
    },
    {
      "jobItemDTID": 609,
      "productCode": "MGO",
      "maxQty": 58.058,
      "minQty": 58,
      "isItemExist": 0
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: Column(
        children: [
          Text(
            DateFormat('yyyy-mm-dd').format(DateTime.now()).toString(),
            style: const TextStyle(fontSize: 20),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: _expandableTile(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: _expandableTile(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expandableTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          ExpandableNotifier(
            initialExpanded: false,
            child: Stack(
              children: [
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.blueAccent,
                  ),
                ),
                ScrollOnExpand(
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vessel Name Here',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 40,
                            // width: 50,
                            child: Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.note_add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BDNScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    collapsed: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'JOBNO',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'JOB123456',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                    'From: ${DateFormat('HH:mm').format(DateTime.now()).toString()}   -   To: ${DateFormat('HH:mm').format(DateTime.now()).toString()}'),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Product Details',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    expanded: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'JOBNO',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'JOB123456',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                    'From: ${DateFormat('HH:mm').format(DateTime.now()).toString()}   -   To: ${DateFormat('HH:mm').format(DateTime.now()).toString()}'),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Table(
                              border: TableBorder.all(),
                              children: [
                                // Table header
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2.0,
                                        right: 2.0,
                                        top: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Text('Product Code',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2.0,
                                        right: 2.0,
                                        top: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Text('Max Qty',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2.0,
                                        right: 2.0,
                                        top: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Text('Min Qty',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2.0,
                                        right: 2.0,
                                        top: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Text('Item Exist',
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                ),
                                ...jobItems.map((jobItem) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(jobItem['productCode'],
                                            textAlign: TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                            jobItem['maxQty'].toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                            jobItem['minQty'].toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Icon(
                                              Icons.radio_button_unchecked,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    theme: const ExpandableThemeData(
                      // hasIcon: false, //hide the icon
                      tapHeaderToExpand: false,
                      tapBodyToExpand: true,
                      tapBodyToCollapse: true,
                      iconColor: Colors.white,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
