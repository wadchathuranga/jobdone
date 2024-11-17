import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

class CustomNotification {
  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    ElegantNotification.success(
      height: 75,
      // isDismissable: false,
      position: Alignment.topRight,
      animation: AnimationType.fromRight,
      stackedOptions: StackedOptions(
        key: 'top',
        type: StackedType.same,
        itemOffset: const Offset(-5, -5),
      ),
      title: const Text(
        "Success",
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(message),
    ).show(context);
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    ElegantNotification.error(
      height: 75,
      // isDismissable: false,
      position: Alignment.topRight,
      animation: AnimationType.fromRight,
      stackedOptions: StackedOptions(
        key: 'top',
        type: StackedType.same,
        itemOffset: const Offset(-5, -5),
      ),
      title: const Text(
        "Error",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(message),
    ).show(context);
  }

  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    ElegantNotification.info(
      height: 75,
      // isDismissable: false,
      position: Alignment.topRight,
      animation: AnimationType.fromRight,
      stackedOptions: StackedOptions(
        key: 'top',
        type: StackedType.same,
        itemOffset: const Offset(-5, -5),
      ),
      title: const Text(
        "Info",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(message),
    ).show(context);
  }
}
