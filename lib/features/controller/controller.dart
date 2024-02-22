// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sshems/features/model/realtime_data_model.dart';

enum ChargingRate { high, good, average, low, poor, nightime }
// enum Rate { high, low, average }

class DataController extends GetxController {
  static DataController get to => Get.find();

  bool loading = false, isNightTime = false, acVoltsSupplyAvailable = false;
  SshemsLatestDataModel latestData = SshemsLatestDataModel();
  ChargingRate currentChargingRate = ChargingRate.nightime;

  toggleAcSupplyState() {
    acVoltsSupplyAvailable = !acVoltsSupplyAvailable;
    update();
  }

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
          getChargingRate(latestData.chargingCurrent ?? 0);
          calculateBatteryCapacityPeriod();
        }
      });
    } catch (e) {
      print("Error occured: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error fetching data");
    }
    loading = false;
    update();
  }

  getChargingRate(double chargingCurrent) {
    if (chargingCurrent < 1.0) {
      currentChargingRate = ChargingRate.poor;
    } else if (chargingCurrent < 5.0) {
      currentChargingRate = ChargingRate.low;
    } else if (chargingCurrent < 10.0) {
      currentChargingRate = ChargingRate.average;
    } else if (chargingCurrent < 15.0) {
      currentChargingRate = ChargingRate.good;
    } else {
      currentChargingRate = ChargingRate.high;
    }
    print(
      "Charging Current = $chargingCurrent, Charging Rate = $currentChargingRate",
    );
  }

  calculateBatteryCapacityPeriod() {
    double batteryCapacity = 220; // in Ah
    // double inverterBatteryThreshold = 47.2; //  in volts
    double inverterBatteryThreshold = 48.5; //  in volts

    double t, timeInDecimal;
    String exactTimeEstimated;

    for (t = 0;; t += 0.1) {
      final voltageRemaining =
          (((latestData.batteryVoltage ?? 0) * batteryCapacity) -
                  ((latestData.apparentPower ?? 0) * t)) /
              batteryCapacity;

      if (voltageRemaining <= inverterBatteryThreshold) {
        timeInDecimal = t;
        break;
      }
    }

    int hoursEstimated = timeInDecimal.toInt();
    int minutesEstimated = ((timeInDecimal - hoursEstimated) * 60).toInt();
    exactTimeEstimated = '$hoursEstimated hours, $minutesEstimated mins';

    print(
      '\n \n \t If you continue using the same load of ${latestData.apparentPower} Watts, \n\t your inverter battery will last  for $exactTimeEstimated',
    );
  }
}
