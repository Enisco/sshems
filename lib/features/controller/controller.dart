// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sshems/features/model/realtime_data_model.dart';

class DataController extends GetxController {
  static DataController get to => Get.find();

  bool loading = false, isNightTime = false, acVoltsSupplyAvailable = false;
  SshemsLatestDataModel latestData = SshemsLatestDataModel();

  double acVoltage = 230.0,
      activePower = 0.0,
      batteryChargeCurrent = 4.5,
      batterydisChargeCurrent = 3.7,
      bateryVoltage = 54.5;

  refreshLatestData() {
    loading = true;
    update();
    try {
      final databaseReference = FirebaseDatabase.instance.ref().child('Latest');

      databaseReference.onValue.listen((event) {
        var data = event.snapshot.value;

        final dataReceived = jsonEncode(data);

        if (data != null) {
          var latestDataReceived = sshemsLatestDataModelFromJson(dataReceived);

          print(latestDataReceived.toJson());
          latestData = latestDataReceived;
          update();
        }
      });
    } catch (e) {
      print("Error occured: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error fetching data");
    }
    loading = false;
    update();
  }
}
