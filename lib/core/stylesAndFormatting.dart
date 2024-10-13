import 'package:flutter/material.dart';

// TextFormField Decoration
InputDecoration customInputDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText,
    // labelStyle: const TextStyle(fontSize: 18),
    contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

// Box Decoration
BoxDecoration customBoxDecoration() {
  return BoxDecoration(
    // color: Colors.blue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.grey,
      width: 0,
    ),
  );
}

double dialogBoxHeight() {
  return 300.0;
}

int maxLines() {
  return 5;

  /// can change # of max lines
}

int minLines() {
  return 1;
}
