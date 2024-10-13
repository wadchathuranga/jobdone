import 'package:flutter/material.dart';

import '../../core/stylesAndFormatting.dart';

class BDNScreen extends StatefulWidget {
  const BDNScreen({Key? key}) : super(key: key);

  @override
  State<BDNScreen> createState() => _BDNScreenState();
}

class _BDNScreenState extends State<BDNScreen> {
  int currentStep = 0;
  bool isCompleted = false;

  final List portOfDeliveryList = [
    "LKCMB | Colombo",
    "DUTRR | Trincomalle",
    "LKGAL | Galle"
  ];
  var selectedPortOfDelivery;

  final List locationOfSupplyList = ["ANC", "IPL", "OPL"];
  var selectedLocationOfSupply;

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
            const Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job No'),
                    Text('Customer'),
                    Text('Vessel'),
                    Text('ETA'),
                  ],
                ),
                Column(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('JOB202409179'),
                    Text('Sri Lanka Shipping'),
                    Text('PANDA 002'),
                    Text('17-09-2024'),
                  ],
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
                    items: portOfDeliveryList.map((variety) {
                      return DropdownMenuItem(
                        value: variety.toString(),
                        child: Text(variety.toString()),
                      );
                    }).toList(),
                    onChanged: (newValueSelected) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        selectedPortOfDelivery = newValueSelected!;
                      });
                    },
                    // value: selectedVariety,
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
                    items: locationOfSupplyList.map((variety) {
                      return DropdownMenuItem(
                        value: variety.toString(),
                        child: Text(variety.toString()),
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
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: maxLines(),
              minLines: minLines(),
              // controller: _clientNameController,
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
            const SizedBox(height: 10),
            TextFormField(
              maxLines: maxLines(),
              minLines: minLines(),
              // controller: _bankClientNameController,
              decoration: customInputDecoration('Bank Client Name'),
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
              // controller: _propertyAddressController,
              decoration: customInputDecoration('Property Address'),
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
