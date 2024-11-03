import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobdone/Databases/locationAndBerthedType_queries.dart';

import '../../core/stylesAndFormatting.dart';
import 'BDNProcessScreen.dart';

class BDNIssueScreen extends StatefulWidget {
  const BDNIssueScreen({super.key, required this.job});

  final dynamic job;

  @override
  State<BDNIssueScreen> createState() => _BDNIssueScreenState();
}

class _BDNIssueScreenState extends State<BDNIssueScreen> {
  int currentStep = 0;
  bool isCompleted = false;

  ///===================== Step_01 - Delivery Note =====================///
  final GlobalKey<FormState> _deliveryNoteFormKey = GlobalKey<FormState>();

  late List portOfDeliveryList = [];
  var selectedPortOfDelivery;

  late List locationOfSupplyList = [];
  var selectedLocationOfSupply;

  final TextEditingController _terminalController = TextEditingController();
  final TextEditingController _bdnController = TextEditingController();
  final TextEditingController _dateOfAlongSideController =
      TextEditingController();
  final TextEditingController _timeOfAlongSideController =
      TextEditingController();
  final TextEditingController _dateOfCommencedPumpingController =
      TextEditingController();
  final TextEditingController _timeOfCommencedPumpingController =
      TextEditingController();
  final TextEditingController _dateOfCompletePumpingController =
      TextEditingController();
  final TextEditingController _timeOfCompletePumpingController =
      TextEditingController();

  late DateTime date;

  ///===================== Step_02 - Fuel Characteristics =====================///
  final GlobalKey<FormState> _fuelCharacteristicsFormKey =
      GlobalKey<FormState>();

  late List productList = [];
  var selectedProduct;

  final TextEditingController _viscocityController = TextEditingController();
  final TextEditingController _waterContentController = TextEditingController();
  final TextEditingController _sulphurContentController =
      TextEditingController();
  final TextEditingController _densityController = TextEditingController();
  final TextEditingController _flashPointController = TextEditingController();

  ///===================== Step_03 - Quantity =====================///
  final GlobalKey<FormState> _quantityFormKey = GlobalKey<FormState>();

  final TextEditingController _grossObservedVolumeController =
      TextEditingController();
  final TextEditingController _grossStandardVolumeController =
      TextEditingController();
  final TextEditingController _quantityMTController = TextEditingController();
  final TextEditingController _barrelsAt60FController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();

  ///===================== Step_04 - Supplier Confirmation =====================///
  final GlobalKey<FormState> _supplierConfirmationFormKey =
      GlobalKey<FormState>();

  final TextEditingController _vesselGrossTonnageController =
      TextEditingController();
  final TextEditingController _vesselOwnerOperatorController =
      TextEditingController();
  final TextEditingController _dateOfVesselETDController =
      TextEditingController();
  final TextEditingController _timeOfVesselETDController =
      TextEditingController();
  final TextEditingController _vesselNextPortController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  ///===================== Step_05 - Master Chief's Acknowledgement =====================///
  final GlobalKey<FormState> _masterChiefAcknowledgementFormKey =
      GlobalKey<FormState>();

  final TextEditingController _vesselSN1Controller = TextEditingController();
  final TextEditingController _vesselCSN1Controller = TextEditingController();
  final TextEditingController _vesselSN2Controller = TextEditingController();
  final TextEditingController _vesselCSN2Controller = TextEditingController();
  final TextEditingController _bunkerTankerSN1Controller =
      TextEditingController();
  final TextEditingController _bunkerTankerCSN1Controller =
      TextEditingController();
  final TextEditingController _bunkerTankerSN2Controller =
      TextEditingController();
  final TextEditingController _bunkerTankerCSN2Controller =
      TextEditingController();
  final TextEditingController _surveyorSNController = TextEditingController();
  final TextEditingController _surveyorCSNController = TextEditingController();
  final TextEditingController _otherSNController = TextEditingController();
  final TextEditingController _otherCSNController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  ///==========================================================================///

  @override
  void initState() {
    super.initState();

    ///=== Step_01 - Delivery Note ===///
    selectedPortOfDelivery = widget.job['port'];
    selectedLocationOfSupply = widget.job['berthedTypeCode'];

    date = DateTime.now();

    _dateOfAlongSideController.text = DateFormat('yyyy-MM-dd').format(date);
    _timeOfAlongSideController.text = DateFormat('HH:mm').format(date);

    _dateOfCommencedPumpingController.text =
        DateFormat('yyyy-MM-dd').format(date);
    _timeOfCommencedPumpingController.text = DateFormat('HH:mm').format(date);

    _dateOfCompletePumpingController.text =
        DateFormat('yyyy-MM-dd').format(date);
    _timeOfCompletePumpingController.text = DateFormat('HH:mm').format(date);

    getLocationList();
    getBerthedTypeList();

    ///=== Step_02 - Fuel Characteristics ===///
    productList = widget.job['jobItems'];

    ///=== Step_03 - Quantity ===///

    ///=== Step_04 - Supplier Confirmation ===///

    ///=== Step_05 - Master Chief's Acknowledgement ===///
  }

  void getLocationList() async {
    portOfDeliveryList = await LocationAndBerthedTypeDB.getAllLocation();
    setState(() {});
  }

  void getBerthedTypeList() async {
    locationOfSupplyList = await LocationAndBerthedTypeDB.getAllBerthedType();
    setState(() {});
  }

  List<Step> getSteps() => [
        ///===================== Step_01 - Delivery Note =====================///
        Step(
          isActive: currentStep >= 0,
          // title: const Text('Delivery Note'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Note'),
              currentStep == 0
                  ? TextButton(onPressed: () {}, child: const Text('clear'))
                  : const SizedBox()
            ],
          ),
          content: deliveryNote(),
        ),

        ///===================== Step_02 - Fuel Characteristics =====================///
        Step(
          isActive: currentStep >= 1,
          // title: const Text('Fuel Characteristics'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fuel Characteristics'),
              currentStep == 1
                  ? TextButton(onPressed: () {}, child: const Text('clear'))
                  : const SizedBox()
            ],
          ),
          content: fuelCharacteristics(),
        ),

        ///===================== Step_03 - Quantity =====================///
        Step(
          isActive: currentStep >= 2,
          // title: const Text('Quantity'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity'),
              currentStep == 2
                  ? TextButton(onPressed: () {}, child: const Text('clear'))
                  : const SizedBox()
            ],
          ),
          content: quantity(),
        ),

        ///===================== Step_04 - Supplier Confirmation =====================///
        Step(
          isActive: currentStep >= 3,
          // title: const Text('Supplier Confirmation'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Supplier Confirmation'),
              currentStep == 3
                  ? TextButton(onPressed: () {}, child: const Text('clear'))
                  : const SizedBox()
            ],
          ),
          content: supplierConfirmation(),
        ),

        ///===================== Step_05 - Master Chief's Acknowledgement =====================///
        Step(
          isActive: currentStep >= 4,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Master Chief\'s Acknowledgement'),
              currentStep == 4
                  ? TextButton(onPressed: () {}, child: const Text('clear'))
                  : const SizedBox()
            ],
          ),
          content: masterChiefAcknowledgement(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BDN Issue'),
      ),
      body: SingleChildScrollView(
        // physics: const ScrollPhysics(),
        child: Column(
          children: [
            Stepper(
              type: StepperType.vertical,
              physics: const ScrollPhysics(),
              steps: getSteps(),
              currentStep: currentStep,
              onStepTapped: (step) {
                setState(() => currentStep = step);
              },
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                if (isLastStep) {
                  if (_masterChiefAcknowledgementFormKey.currentState!
                      .validate()) {
                    setState(() => isCompleted = true);
                    //TODO: make data object
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BDNProcessScreen(),
                      ),
                    );
                  } else if (!_deliveryNoteFormKey.currentState!.validate()) {
                    setState(() => currentStep = 0);
                  } else if (!_fuelCharacteristicsFormKey.currentState!
                      .validate()) {
                    setState(() => currentStep = 1);
                  } else if (!_quantityFormKey.currentState!.validate()) {
                    setState(() => currentStep = 2);
                  } else if (!_supplierConfirmationFormKey.currentState!
                      .validate()) {
                    setState(() => currentStep = 3);
                  }
                } else if (currentStep == 0 &&
                    !_deliveryNoteFormKey.currentState!.validate()) {
                  return;
                } else if (currentStep == 1 &&
                    !_fuelCharacteristicsFormKey.currentState!.validate()) {
                  return;
                } else if (currentStep == 2 &&
                    !_quantityFormKey.currentState!.validate()) {
                  return;
                } else if (currentStep == 3 &&
                    !_supplierConfirmationFormKey.currentState!.validate()) {
                  return;
                } else {
                  setState(() => currentStep += 1);
                }
              },
              onStepCancel: currentStep == 0
                  ? null
                  : () => setState(() => currentStep -= 1),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = currentStep == getSteps().length - 1;
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      if (currentStep != 0)
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: details.onStepCancel,
                              child: const Text('BACK'),
                            ),
                          ),
                        ),
                      if (currentStep != 0) const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: details.onStepContinue,
                            child: Text(isLastStep ? 'COMPLETE' : 'NEXT'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget deliveryNote() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Form(
        key: _deliveryNoteFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job No'),
                    Text('Customer'),
                    Text('Vessel'),
                    Text('ETA'),
                  ],
                ),
                const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(':'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(':'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(':'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(':'),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.job['jobNo'].toString()),
                      Text(
                        widget.job['customerName'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        widget.job['vesselName'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                          '${DateFormat('yyyy-MM-dd HH:mm').format(DateFormat('yyyy-MM-dd').parse(widget.job['assignedFromDateTime']))} HRS'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    validator: (val) {
                      if (val == null) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    itemHeight: 50,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Port of Delivery',
                    ),
                    items: portOfDeliveryList.map((port) {
                      return DropdownMenuItem(
                        value: port['varLocationCode'].toString(),
                        child: Text(
                            '${port['varLocationCode']} | ${port['varLocationName']}'),
                      );
                    }).toList(),
                    onChanged: (newValueSelected) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        selectedPortOfDelivery = newValueSelected!;
                      });
                    },
                    value: selectedPortOfDelivery,
                    isExpanded: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    validator: (val) {
                      if (val == null) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    itemHeight: 50,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Location of Supply',
                    ),
                    items: locationOfSupplyList.map((berthedType) {
                      return DropdownMenuItem(
                        value: berthedType['varBerthedTypeCode'].toString(),
                        child: Text(
                            '${berthedType['varBerthedTypeCode']} | ${berthedType['varBerthedTypeName']}'),
                      );
                    }).toList(),
                    onChanged: (newValueSelected) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        selectedLocationOfSupply = newValueSelected!;
                      });
                    },
                    value: selectedLocationOfSupply,
                    isExpanded: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (selectedLocationOfSupply == 'IPL')
              Column(
                children: [
                  TextFormField(
                    decoration: customInputDecoration('Terminal'),
                    // validator: (val) {
                    //   if (val!.trim().isEmpty) {
                    //     return 'Required!';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _terminalController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            TextFormField(
              readOnly: true,
              decoration: customInputDecoration('BDN Number'),
              // validator: (val) {
              //   if (val!.trim().isEmpty) {
              //     return 'Required!';
              //   } else {
              //     return null;
              //   }
              // },
              controller: _bdnController,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onTapOutside: (PointerDownEvent val) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Along Side'),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Date'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _dateOfAlongSideController,
                        onTap: () async {
                          DateTime selectedDate = await pickDate();
                          setState(() {
                            _dateOfAlongSideController.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                          if (!mounted)
                            return; // Checks `this.mounted`, not `context.mounted`.
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Time (HRS)'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _timeOfAlongSideController,
                        onTap: () async {
                          DateTime selectedDate = await pickTime();
                          setState(() {
                            _timeOfAlongSideController.text =
                                DateFormat('HH:mm').format(selectedDate);
                          });
                          if (!mounted) return;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Commenced Pumping'),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Date'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _dateOfCommencedPumpingController,
                        onTap: () async {
                          DateTime selectedDate = await pickDate();
                          setState(() {
                            _dateOfCommencedPumpingController.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                          if (!mounted) return;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Time (HRS)'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _timeOfCommencedPumpingController,
                        onTap: () async {
                          DateTime selectedDate = await pickTime();
                          setState(() {
                            _timeOfCommencedPumpingController.text =
                                DateFormat('HH:mm').format(selectedDate);
                          });
                          if (!mounted) return;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Complete Pumping'),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Date'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _dateOfCompletePumpingController,
                        onTap: () async {
                          DateTime selectedDate = await pickDate();
                          setState(() {
                            _dateOfCompletePumpingController.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                          if (!mounted) return;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Time (HRS)'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _timeOfCompletePumpingController,
                        onTap: () async {
                          DateTime selectedDate = await pickTime();
                          setState(() {
                            _timeOfCompletePumpingController.text =
                                DateFormat('HH:mm').format(selectedDate);
                          });
                          if (!mounted) return;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget fuelCharacteristics() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Form(
        key: _fuelCharacteristicsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    validator: (val) {
                      if (val == null) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    itemHeight: 50,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Product',
                    ),
                    items: productList.map((product) {
                      return DropdownMenuItem(
                        value: product['productCode'].toString(),
                        child: Text(product['productCode'].toString()),
                      );
                    }).toList(),
                    onChanged: (newValueSelected) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        selectedProduct = newValueSelected!;
                      });
                    },
                    value: selectedProduct,
                    isExpanded: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Viscosity'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _viscocityController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Water Content'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _waterContentController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Sulphur Content'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _sulphurContentController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Density'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _densityController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Flash Point'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _flashPointController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget quantity() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Form(
        key: _quantityFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Gross Observed Volume'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _grossObservedVolumeController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Gross Standard Volume'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _grossStandardVolumeController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Quantity (Metric Tons)'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _quantityMTController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Barrels at 60F'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _barrelsAt60FController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        customInputDecoration('Temperature VCF and WCF'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _temperatureController,
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget supplierConfirmation() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Form(
        key: _supplierConfirmationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Column(
                  children: [
                    Text('Radio Button 1'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Radio Button 2'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Radio Button 3'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('Vessel Gross Tonnage'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _vesselGrossTonnageController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: customInputDecoration('Vessel Owner/Operator'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _vesselOwnerOperatorController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Vessel ETD'),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Date'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _dateOfVesselETDController,
                        onTap: () async {
                          // set date to standard DateTime format
                          DateTime currDate = DateFormat('yyyy-MM-dd')
                              .parse(_dateOfVesselETDController.text);

                          // date picker popup
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: _dateOfVesselETDController.text.isEmpty
                                ? date
                                : currDate,
                            firstDate: DateTime(DateTime.now().year - 5),
                            lastDate: DateTime(DateTime.now().year + 5),
                          );

                          if (newDate != null) {
                            setState(() {
                              _dateOfVesselETDController.text =
                                  DateFormat('yyyy-MM-dd').format(newDate);
                            });
                          }
                          if (!mounted) return;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Time (HRS)'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        controller: _timeOfVesselETDController,
                        onTap: () async {
                          // set time to standard DateTime format
                          DateTime currDTime = DateFormat('HH:mm')
                              .parse(_timeOfVesselETDController.text);

                          // time picker popup
                          TimeOfDay? newTime = await showTimePicker(
                            context: context,
                            initialTime: _timeOfVesselETDController.text.isEmpty
                                ? TimeOfDay.now()
                                : TimeOfDay(
                                    hour: currDTime.hour,
                                    minute: currDTime.minute),
                          );

                          if (newTime != null) {
                            DateTime selectedDate = DateTime(0000, 00, 00,
                                newTime.hour, newTime.minute, 0, 0, 0);
                            setState(() {
                              _timeOfVesselETDController.text =
                                  DateFormat('HH:mm').format(selectedDate);
                            });
                          }
                          if (!mounted) return;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: customInputDecoration('Vessel Next Port'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _vesselNextPortController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration: customInputDecoration(
                        'For (Company\'s Name and Stamp)'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _companyNameController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    decoration:
                        customInputDecoration('Full Name in Block Letters'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    controller: _fullNameController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget masterChiefAcknowledgement() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Form(
        key: _masterChiefAcknowledgementFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Vessel'),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _vesselSN1Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Counter Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _vesselCSN1Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _vesselSN2Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Counter Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _vesselCSN2Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bunker Tanker (MARPOL)'),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _bunkerTankerSN1Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Counter Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _bunkerTankerCSN1Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _bunkerTankerSN2Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputDecoration('Counter Seal No'),
                        // validator: (val) {
                        //   if (val!.trim().isEmpty) {
                        //     return 'Required!';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: _bunkerTankerCSN2Controller,
                        // onTapOutside: (PointerDownEvent val) {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Surveyor'),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: customInputDecoration('Seal No'),
                    // validator: (val) {
                    //   if (val!.trim().isEmpty) {
                    //     return 'Required!';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _surveyorSNController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: customInputDecoration('Counter Seal No'),
                    // validator: (val) {
                    //   if (val!.trim().isEmpty) {
                    //     return 'Required!';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _surveyorCSNController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Others'),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: customInputDecoration('Seal No'),
                    // validator: (val) {
                    //   if (val!.trim().isEmpty) {
                    //     return 'Required!';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _otherSNController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: customInputDecoration('Counter Seal No'),
                    // validator: (val) {
                    //   if (val!.trim().isEmpty) {
                    //     return 'Required!';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _otherCSNController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    maxLines: 3,
                    minLines: minLines(),
                    decoration: customInputDecoration('Remark'),
                    // validator: (val) {
                    //   if (val!.trim().isEmpty) {
                    //     return 'Required!';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _remarkController,
                    // onTapOutside: (PointerDownEvent val) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  // Date picker function
  Future<DateTime> pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) {
      return date;
    } else {
      return newDate;
    }
  }

  // Date picker function
  Future<DateTime> pickTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime == null) {
      return DateTime(0000, 00, 00, date.hour, date.minute, 0, 0, 0);
    } else {
      return DateTime(0000, 00, 00, newTime.hour, newTime.minute, 0, 0, 0);
    }
  }
}
