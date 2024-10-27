import 'package:flutter/material.dart';
import 'package:jobdone/Databases/locationAndBerthedType_queries.dart';

import '../../core/stylesAndFormatting.dart';

class BDNScreen extends StatefulWidget {
  const BDNScreen({Key? key, required this.job}) : super(key: key);

  final dynamic job;

  @override
  State<BDNScreen> createState() => _BDNScreenState();
}

class _BDNScreenState extends State<BDNScreen> {
  int currentStep = 0;
  bool isCompleted = false;

  late List portOfDeliveryList = [];
  late List locationOfSupplyList = [];

  var selectedPortOfDelivery;
  var selectedLocationOfSupply;

  // final List portOfDeliveryList = [
  //   "LKCMB | Colombo",
  //   "DUTRR | Trincomalle",
  //   "LKGAL | Galle"
  // ];

  // final List locationOfSupplyList = ["ANC", "IPL", "OPL"];

  @override
  void initState() {
    super.initState();

    getLocationList();
    getBerthedTypeList();
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
        ///===================== General Information Info =====================///
        Step(
          isActive: currentStep >= 0,
          title: const Text('Delivery Note'),
          content: deliveryNote(),
        ),

        ///===================== Details of Land Info =====================///
        Step(
          isActive: currentStep >= 1,
          title: const Text('Fuel Characteristics'),
          content: fuelCharacteristics(),
        ),

        // ///===================== Details of Structure Info =====================///
        // Step(
        //   isActive: currentStep >= 2,
        //   title: const Text('Details of Structure'),
        //   content: structureInfo(),
        // ),
        //
        // ///===================== Details of Valuation Info =====================///
        // Step(
        //   isActive: currentStep >= 3,
        //   title: const Text('Details of Valuation'),
        //   content: valuationInfo(),
        // ),
        //
        // ///===================== Other Details Info =====================///
        // Step(
        //   isActive: currentStep >= 4,
        //   title: const Text('Other Details'),
        //   content: otherInfo(),
        // ),
        //
        // ///===================== Final Step to Complete =====================///
        // Step(
        //   isActive: currentStep >= 5,
        //   title: const Text('Final Step'),
        //   content: const SizedBox(),
        // ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stepper(
              type: StepperType.vertical,
              steps: getSteps(),
              currentStep: currentStep,
              onStepTapped: (step) => setState(() => currentStep = step),
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                // if (isLastStep) {
                //   if (_genInfoFormKey.currentState!.validate()) {
                //     setState(() => isCompleted = true);
                //     mapDataObj();
                //   } else {
                //     setState(() => currentStep = 0);
                //   }
                // } else if (currentStep == 0 &&
                //     !_genInfoFormKey.currentState!.validate()) {
                //   return;
                // } else {
                //   setState(() => currentStep += 1);
                // }
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
        // key: _genInfoFormKey,
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
                      Text(widget.job['assignedFromDateTime']),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
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
                        child: Text(port['varLocationName'].toString()),
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
            const SizedBox(
              height: 10,
            ),
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
                        child:
                            Text(berthedType['varBerthedTypeName'].toString()),
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
                    maxLines: maxLines(),
                    minLines: minLines(),
                    // controller: _terminalController,
                    decoration: customInputDecoration('Terminal'),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Required!';
                      } else {
                        return null;
                      }
                    },
                    onTapOutside: (PointerDownEvent val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            TextFormField(
              readOnly: true,
              maxLines: maxLines(),
              minLines: minLines(),
              // controller: _bankClientNameController,
              decoration: customInputDecoration('BDN Number'),
              validator: (val) {
                if (val!.trim().isEmpty) {
                  return 'Required!';
                } else {
                  return null;
                }
              },
              onTapOutside: (PointerDownEvent val) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Along Side'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: maxLines(),
                        minLines: minLines(),
                        // controller: _propertyAddressController,
                        decoration: customInputDecoration('Date'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        maxLines: maxLines(),
                        minLines: minLines(),
                        // controller: _propertyAddressController,
                        decoration: customInputDecoration('Time'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Commenced Pumping'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: maxLines(),
                        minLines: minLines(),
                        // controller: _propertyAddressController,
                        decoration: customInputDecoration('Date'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        maxLines: maxLines(),
                        minLines: minLines(),
                        // controller: _propertyAddressController,
                        decoration: customInputDecoration('Time'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Complete Pumping'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: maxLines(),
                        minLines: minLines(),
                        // controller: _propertyAddressController,
                        decoration: customInputDecoration('Date'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
                        },
                        onTapOutside: (PointerDownEvent val) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        maxLines: maxLines(),
                        minLines: minLines(),
                        // controller: _propertyAddressController,
                        decoration: customInputDecoration('Time'),
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Required!';
                          } else {
                            return null;
                          }
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget fuelCharacteristics() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          TextFormField(
            maxLines: maxLines(),
            minLines: minLines(),
            // controller: _neighborhoodController,
            decoration: customInputDecoration('Neighborhood'),
            validator: (val) {
              if (val!.trim().isEmpty) {
                return 'Required!';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: maxLines(),
            minLines: minLines(),
            // controller: _otherBoundController,
            decoration: customInputDecoration('Comments on Boundaries'),
            validator: (val) {
              if (val!.trim().isEmpty) {
                return 'Required!';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: maxLines(),
            minLines: minLines(),
            // controller: _landDescriptionController,
            decoration: customInputDecoration('Land Description'),
            validator: (val) {
              if (val!.trim().isEmpty) {
                return 'Required!';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
