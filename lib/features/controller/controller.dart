// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sshems/features/model/realtime_data_model.dart';

enum ChargingRate { high, good, average, low, poor, nightime }
// enum Rate { high, low, average }

class DataController extends GetxController {
  static DataController get to => Get.find();

  bool loading = false,
      isNightTime = false,
      manualNightSet = false,
      acVoltsSupplyAvailable = false;
  SshemsLatestDataModel latestData = SshemsLatestDataModel();
  ChargingRate currentChargingRate = ChargingRate.nightime;
  int? timeEstimatedInMinutes, estimatedHours, estimatedmins, batteryPercentage;
  List<int> commandDigits = [0, 0, 0, 0];

  checkIfTimeIsNight() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      DateTime currentTime = DateTime.now();
      // Check if the current time is between 9 PM and 5 AM
      if (manualNightSet == false) {
        if (currentTime.hour >= 21 || currentTime.hour < 5) {
          isNightTime = true;
          update();
        } else {
          isNightTime = false;
          update();
        }
      }
    });
  }

  updateButtonState(int index, bool newState) {
    commandDigits[index] = newState == true ? 1 : 0;
    String commandMessage =
        "${commandDigits[0]}${commandDigits[1]}${commandDigits[2]}${commandDigits[3]}";
    print("commandMessage: $commandMessage");

    final databaseReference = FirebaseDatabase.instance.ref();
    const String path = "Priority/state";

    databaseReference.child(path).set(commandMessage).then((_) {
      print("State updated successfully to: $commandMessage");
    }).catchError((error) {
      print("Failed to update state: $error");
    });

    update();
  }

  retrieveSwitchInstruction() async {
    const String path = "Priority/state";
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(path).get();
    if (snapshot.exists) {
      print(snapshot.value);
      String commandString = snapshot.value.toString();
      commandDigits = commandString.split('').map(int.parse).toList();
      print('commandString: $commandString, commandDigits: $commandDigits');
    } else {
      print('No data available.');
    }
    update();
  }

  toggleAcSupplyState() {
    acVoltsSupplyAvailable = !acVoltsSupplyAvailable;
    update();
  }

  toggleAcNightTimeState(bool val) {
    isNightTime = val;
    manualNightSet = val == true ? true : false;
    update();
  }

  refreshLatestData() async {
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
          calculateBatteryPercentage();
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
    double inverterBatteryThreshold = 47.2; //  in volts

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

    estimatedHours = timeInDecimal.toInt();
    estimatedmins = ((timeInDecimal - estimatedHours!) * 60).toInt();
    exactTimeEstimated = '$estimatedHours hours, $estimatedmins mins';
    timeEstimatedInMinutes = (timeInDecimal * 60).toInt();

    print("Time in minutes: $timeEstimatedInMinutes");

    print(
      '\n \n \t If you continue using the same load of ${latestData.apparentPower} Watts, \n\t your inverter battery will last  for $exactTimeEstimated',
    );
  }

  calculateBatteryPercentage() {
    const fullChargeVoltage = 56.8;
    const lowVoltageCutoff = 47.2;
    double percentageCharge;
    if (latestData.batteryVoltage! - lowVoltageCutoff < 0) {
      percentageCharge = 0;
    } else {
      percentageCharge = ((latestData.batteryVoltage! - lowVoltageCutoff) /
              (fullChargeVoltage - lowVoltageCutoff)) *
          100;
    }

    final clampedPercentageCharge = percentageCharge.clamp(0.0, 100.0);
    batteryPercentage = clampedPercentageCharge.round();

    print('Percentage charge: $clampedPercentageCharge%');
  }
}
