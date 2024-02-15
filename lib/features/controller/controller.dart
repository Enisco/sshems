import 'package:get/get.dart';

class DataController extends GetxController {
  static DataController get to => Get.find();

  bool loading = false, isNightTime = false, acVoltsSupplyAvailable = false;

  double acVoltage = 230.0,
      activePower = 0.0,
      batteryChargeCurrent = 4.5,
      batterydisChargeCurrent = 3.7,
      bateryVoltage = 54.5;
}
