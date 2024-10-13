import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobdone/services/jobService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: set data to this array, coming from the API
  late List<String> companyList = [
    'Hayleys',
    'Delmage',
    'Advantis',
    'MIT Global',
    'FedEx',
  ];

  String? selectedValue;
  bool isSubmit = false;
  late DateTime date;
  late TimeOfDay fromTime;
  late TimeOfDay toTime;

  late TextEditingController addNewCompanyController;

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController datePickController = TextEditingController();
  final TextEditingController timeFromPickController = TextEditingController();
  final TextEditingController timeToPickController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addNewCompFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    fromTime = TimeOfDay.fromDateTime(date);
    toTime = TimeOfDay.fromDateTime(date);
    addNewCompanyController = TextEditingController();
    getAllJobs();
  }

  void getAllJobs() async {
    var res = await JobApiService.getAllJobsFromDB();
    print('=================**********************$res');
  }

  @override
  void dispose() {
    textEditingController.dispose();
    datePickController.dispose();
    timeFromPickController.dispose();
    timeToPickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Add Completed Jobs",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          // DropdownButtonHideUnderline(
                          //   child: DropdownButton2<String>(
                          //     isExpanded: true,
                          //     hint: Text(
                          //       'Select Item',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         // color: Theme.of(context).hintColor, // TODO: add logic to show validation color change
                          //         color: isSubmit && selectedValue == null
                          //             ? Colors.red.shade900
                          //             : Colors.grey,
                          //       ),
                          //     ),
                          //     items: companyList
                          //         .map((item) => DropdownMenuItem(
                          //               value: item,
                          //               child: Text(
                          //                 item,
                          //                 style: const TextStyle(
                          //                   fontSize: 16,
                          //                 ),
                          //               ),
                          //             ))
                          //         .toList(),
                          //     value: selectedValue,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         selectedValue = value;
                          //         isSubmit = false;
                          //         // TODO: remove log
                          //         print("Selected Company: $selectedValue");
                          //       });
                          //     },
                          //     buttonStyleData: ButtonStyleData(
                          //       padding:
                          //           const EdgeInsets.symmetric(horizontal: 16),
                          //       height: 50,
                          //       width: (deviceWidth / 5) * 3,
                          //       decoration: BoxDecoration(
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(5)),
                          //         //border: Border.all(color: Colors.grey), // TODO: add logic to show validation color change
                          //         border: Border.all(
                          //             color: isSubmit && selectedValue == null
                          //                 ? Colors.red.shade900
                          //                 : Colors.grey),
                          //       ),
                          //     ),
                          //     dropdownStyleData: const DropdownStyleData(
                          //       maxHeight: 250,
                          //     ),
                          //     menuItemStyleData: const MenuItemStyleData(
                          //       height: 40,
                          //     ),
                          //     dropdownSearchData: DropdownSearchData(
                          //       searchController: textEditingController,
                          //       searchInnerWidgetHeight: 50,
                          //       searchInnerWidget: Container(
                          //         height: 50,
                          //         padding: const EdgeInsets.only(
                          //           top: 8,
                          //           bottom: 4,
                          //           right: 8,
                          //           left: 8,
                          //         ),
                          //         child: TextFormField(
                          //           expands: true,
                          //           maxLines: null,
                          //           controller: textEditingController,
                          //           decoration: InputDecoration(
                          //             isDense: true,
                          //             contentPadding:
                          //                 const EdgeInsets.symmetric(
                          //               horizontal: 10,
                          //               vertical: 8,
                          //             ),
                          //             hintText: 'Search for an item...',
                          //             hintStyle: const TextStyle(fontSize: 16),
                          //             border: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(8),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       searchMatchFn: (item, searchValue) {
                          //         return item.value
                          //             .toString()
                          //             .toLowerCase()
                          //             .contains(searchValue.toLowerCase());
                          //       },
                          //     ),
                          //     //This to clear the search value when you close the menu
                          //     onMenuStateChange: (isOpen) {
                          //       if (!isOpen) {
                          //         textEditingController.clear();
                          //       }
                          //     },
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              width: deviceWidth * 3 / 5,
                              child: FormField<String>(validator: (value) {
                                if (selectedValue == null) {
                                  return "Required!";
                                } else {
                                  return null;
                                }
                              }, builder: (
                                FormFieldState<String> state,
                              ) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    InputDecorator(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(0.0),
                                        labelText: 'Company',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: (selectedValue == null &&
                                                    !isSubmit)
                                                ? Colors.grey
                                                : (selectedValue != null &&
                                                        !isSubmit)
                                                    ? Colors.grey
                                                    : Colors.red.shade900),
                                        border: InputBorder.none,
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Select Item',
                                            style: TextStyle(
                                              fontSize: 16,
                                              // color: Theme.of(context).hintColor, // TODO: add logic to show validation color change
                                              color: isSubmit &&
                                                      selectedValue == null
                                                  ? Colors.red.shade900
                                                  : Colors.grey,
                                            ),
                                          ),
                                          items: companyList
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValue = value;
                                              //isSubmit = false;
                                              // TODO: remove log
                                              print(
                                                  "Selected Company: $selectedValue");
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            height: 50,
                                            width: (deviceWidth / 5) * 3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              //border: Border.all(color: Colors.grey), // TODO: add logic to show validation color change
                                              border: Border.all(
                                                  color:
                                                      (selectedValue == null &&
                                                              !isSubmit)
                                                          ? Colors.grey
                                                          : (selectedValue !=
                                                                      null &&
                                                                  !isSubmit)
                                                              ? Colors.grey
                                                              : Colors.red
                                                                  .shade900),
                                            ),
                                          ),
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                            maxHeight: 250,
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData:
                                              DropdownSearchData(
                                            searchController:
                                                textEditingController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller:
                                                    textEditingController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText:
                                                      'Search for an item...',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 16),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchValue
                                                      .toLowerCase());
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              textEditingController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    //const SizedBox(height: 5.0),
                                    state.hasError
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, left: 12.0),
                                            child: Text(
                                              state.errorText.toString(),
                                              style: TextStyle(
                                                  color: Colors.red.shade900,
                                                  fontSize: 12.0),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SizedBox(
                                height: 40,
                                width: 100,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Corner radius
                                    ), // Text color
                                  ),
                                  onPressed: () {
                                    // TODO: add new company API call from here
                                    openDialog();
                                  },
                                  child: const Text("+ New"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required!";
                      } else {
                        return null;
                      }
                    },
                    controller: datePickController,
                    decoration: const InputDecoration(
                      labelText: 'Worked Date',
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      var nDate = await pickDate();
                      if (nDate == null) return;
                      setState(() {
                        date = nDate;
                        datePickController.text =
                            DateFormat('yyyy-MM-dd').format(nDate);
                        // TODO: remove log
                        print(
                            "The Date: ${DateFormat('yyyy-MM-dd').format(date)}");
                      });
                    },
                    onTapOutside: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required!";
                      } else {
                        return null;
                      }
                    },
                    controller: timeFromPickController,
                    decoration: const InputDecoration(
                      labelText: 'Time From',
                      suffixIcon: Icon(Icons.access_time_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final time = await pickTime(fromTime);
                      if (time == null) return;
                      setState(() {
                        fromTime = time;
                        final fTod = formatTimeOfDay(time);
                        timeFromPickController.text = fTod;
                        // TODO: remove log
                        print("Time From: $fTod");
                      });
                    },
                    onTapOutside: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required!";
                      } else {
                        return null;
                      }
                    },
                    controller: timeToPickController,
                    decoration: const InputDecoration(
                      labelText: 'Time To',
                      suffixIcon: Icon(Icons.access_time_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final time = await pickTime(toTime);
                      if (time == null) return;
                      setState(() {
                        toTime = time;
                        final tTod = formatTimeOfDay(time);
                        timeToPickController.text = tTod;
                        // TODO: remove log
                        print("Time To: $tTod");
                      });
                    },
                    onTapOutside: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: deviceWidth,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _formKey.currentState!.reset();
                              datePickController.clear();
                              timeFromPickController.clear();
                              timeToPickController.clear();
                              setState(() {
                                selectedValue = null;
                                isSubmit = false;
                              });
                            },
                            child: const Text("Clear"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: deviceWidth,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // Corner radius
                              ), // Text color
                            ),
                            onPressed: () => saveData(),
                            child: const Text("Save"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Add New',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  /// Alert dialog for creating a semester
  Future openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add New Company'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    addNewCompanyController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            // icon: const Icon(Icons.clear),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _addNewCompFormKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          controller: addNewCompanyController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            labelStyle: const TextStyle(fontSize: 18),
                            contentPadding: const EdgeInsets.fromLTRB(
                                15.0, 15.0, 15.0, 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Corner radius
                    ), // Text color
                  ),
                  onPressed: popupSubmit,
                  child: const Text('Add'),
                )
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ));

  void popupSubmit() async {
    if (_addNewCompFormKey.currentState!.validate()) {
      final newCompany = addNewCompanyController.text;
      print("New Company Added: $newCompany");
      setState(() {
        companyList.add(newCompany);
      });
      // TODO: save new company into db
      // TODO: call data re-fetching API from here
      addNewCompanyController.clear();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New Company Added. $newCompany"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<DateTime?> pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    return newDate;
  }

  Future<TimeOfDay?> pickTime(TimeOfDay tod) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: tod,
    );
    return newTime;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future saveData() async {
    if (_formKey.currentState!.validate()) {
      print("Form Validated");

      // API call from here
      final reqBody = {
        "company": selectedValue,
        "date": datePickController.text,
        "timeFrom": timeFromPickController.text,
        "timeTo": timeToPickController.text,
      };

      bool isSave = await JobApiService.saveJobToDB(reqBody);
      print("===========----------------------${isSave}");

      return; // ========================= remove api set up completed
      setState(() {
        selectedValue = null;
        isSubmit = false;
      });
      datePickController.clear();
      timeFromPickController.clear();
      timeToPickController.clear();
    } else {
      if (selectedValue == null) {
        setState(() => isSubmit = true);
      } else {
        setState(() => isSubmit = false);
      }
      return;
    }
  }
}
