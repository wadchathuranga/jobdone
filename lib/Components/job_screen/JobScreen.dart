import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Databases/bargeAllocation_queries.dart';
import '../BDN/BDNScreen.dart';
import '../BDN/DeliveryNoteScreen/DeliveryNoteScreen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key? key, required this.selectedDate}) : super(key: key);

  final DateTime selectedDate;

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  late String convtDate;
  List jobList = [];

  @override
  void initState() {
    super.initState();
    getJobListByDate();
  }

  void getJobListByDate() async {
    convtDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(widget.selectedDate);
    jobList = await BargeAllocationDB.getJobListByDate(convtDate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: Column(
        children: [
          Text(
            DateFormat('yyyy-MM-dd').format(widget.selectedDate).toString(),
            style: const TextStyle(fontSize: 20),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: jobList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: _expandableTile(jobList[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _expandableTile(jobItem) {
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
                            jobItem['vesselName'],
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
                                            BDNScreen(job: jobItem),
                                      ),
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
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jobItem['jobNo'],
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
                                    'From: ${DateFormat('HH:mm').format(DateTime(DateTime.parse(jobItem['assignedFromDateTime']).year, DateTime.parse(jobItem['assignedFromDateTime']).month, DateTime.parse(jobItem['assignedFromDateTime']).day, 0, 0, 0)).toString()}   -   To: ${DateFormat('HH:mm').format(DateTime(DateTime.parse(jobItem['assignedToDateTime']).year, DateTime.parse(jobItem['assignedToDateTime']).month, DateTime.parse(jobItem['assignedToDateTime']).day, 23, 59, 0)).toString()}'),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
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
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jobItem['jobNo'],
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
                                    'From: ${DateFormat('HH:mm').format(DateTime(DateTime.parse(jobItem['assignedFromDateTime']).year, DateTime.parse(jobItem['assignedFromDateTime']).month, DateTime.parse(jobItem['assignedFromDateTime']).day, 0, 0, 0)).toString()}   -   To: ${DateFormat('HH:mm').format(DateTime(DateTime.parse(jobItem['assignedToDateTime']).year, DateTime.parse(jobItem['assignedToDateTime']).month, DateTime.parse(jobItem['assignedToDateTime']).day, 23, 59, 0)).toString()}'),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Table(
                              border: TableBorder.all(),
                              children: [
                                // Table header
                                const TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 2.0,
                                        right: 2.0,
                                        top: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Text('Product Code',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 2.0,
                                        right: 2.0,
                                        top: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Text('Max Qty',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 2.0,
                                        right: 2.0,
                                        top: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Text('Min Qty',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
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
                                ...jobItem['jobItems'].map((item) {
                                  return _tableRow(item);
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

  TableRow _tableRow(item) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(item['productCode'], textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(item['maxQty'].toStringAsFixed(2),
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(item['minQty'].toStringAsFixed(2),
              textAlign: TextAlign.center),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item['isItemExist'] == 0)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: const Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.green,
                  size: 20,
                ),
              )
            else
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
  }
}
