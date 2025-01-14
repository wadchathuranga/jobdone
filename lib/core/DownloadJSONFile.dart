import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/BDNModel.dart';
import 'CustomNotification.dart';

Future<void> downloadJSONFile(BuildContext context, Map<String, dynamic> bdnObj) async {
  try {
    // Convert the object to JSON
    String jsonString = jsonEncode(bdnObj);

    String? downloadPath = await getDownloadPath(context);

    if (downloadPath == null) {
      print("Could not get the Downloads folder path.");
      return;
    }

    String filePath = "$downloadPath/${bdnObj['bargeBdnNo']}.json";

    // Write the content to the file
    File file = File(filePath);
    await file.writeAsString(jsonString);

    if (!context.mounted) return;
    CustomNotification.showSuccess(
      context: context,
      message: "File saved success.",
    );
    print("File saved to $filePath");
  } catch (e) {
    if (!context.mounted) return;
    CustomNotification.showError(
      context: context,
      message: "Error saving file: $e",
    );
    print("Error saving file: $e");
  }
}

Future<String?> getDownloadPath(BuildContext context) async {
  if (Platform.isAndroid) {
    // Request storage permission
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      Directory? downloadsDir = Directory('/storage/emulated/0/BMS');
      if (await downloadsDir.exists()) {
        return downloadsDir.path;
      } else {
        await downloadsDir.create(recursive: true);
        return downloadsDir.path;
      }
    } else {
      // Show alert
      if (!context.mounted) return null;
      CustomNotification.showError(
        context: context,
        message: "Storage permission denied.",
      );
      print("Storage permission denied");
    }
  }
  return null;
}