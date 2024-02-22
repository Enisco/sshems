import 'package:flutter/material.dart';
import 'package:sshems/features/controller/controller.dart';

Color chargingRateColor(ChargingRate currentChargingRate) {
  if (currentChargingRate == ChargingRate.poor) {
    return Colors.red;
  } else if (currentChargingRate == ChargingRate.low) {
    return Colors.orange;
  } else if (currentChargingRate == ChargingRate.average) {
    return Colors.blue;
  } else if (currentChargingRate == ChargingRate.good) {
    return Colors.green;
  } else {
    return Colors.teal;
  }
}
