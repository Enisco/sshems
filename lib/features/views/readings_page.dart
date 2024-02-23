import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sshems/features/controller/controller.dart';
import 'package:sshems/widgets/curved_container.dart';
import 'package:sshems/widgets/select_color.dart';
import 'package:sshems/widgets/strings_extension.dart';

class ReadingsPage extends StatefulWidget {
  const ReadingsPage({super.key});

  @override
  State<ReadingsPage> createState() => _ReadingsPageState();
}

class _ReadingsPageState extends State<ReadingsPage> {
  final _controller = Get.put(DataController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      init: DataController(),
      builder: (context) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Row(
                  children: [
                    Text(
                      'Power Status',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _detailsCard(
                      title: "AC Voltage\nsupplied:",
                      value: _controller.acVoltsSupplyAvailable
                          ? '${(_controller.latestData.supplyVoltage ?? 0).toStringAsFixed(0)} V'
                          : "No Supply",
                      bgColor: const Color.fromARGB(255, 184, 217, 245),
                      iconData: CupertinoIcons.bolt,
                      iconColor: Colors.blue,
                      iconBgColor: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    _detailsCard(
                      title: "Active Power\nusage:",
                      value: (_controller.latestData.apparentPower ?? 0)
                          .toStringAsFixed(0)
                          .toWattsString(),
                      iconColor: Colors.amber.shade800,
                      bgColor: const Color.fromARGB(255, 241, 216, 138),
                      iconData: Icons.electric_meter,
                      iconBgColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Row(
                  children: [
                    Text(
                      'Battery Status',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _analysisCard(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _analysisCard() {
    Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        width: size.width,
        height: 200,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 57, 129, 122),
          borderRadius: BorderRadius.circular(26),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.battery_full,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Current Battery\nvoltage",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const Expanded(child: SizedBox()),
                CustomCurvedContainer(
                  width: 128,
                  height: 50,
                  fillColor: Colors.white,
                  child: Center(
                    child: Text(
                      '${(_controller.latestData.batteryVoltage ?? 0).toStringAsFixed(1)} V',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _controller.currentChargingRate == ChargingRate.nightime
                ? Row(
                    children: [
                      const Icon(
                        CupertinoIcons.sun_min,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: size.width * 0.65,
                        child: const Text(
                          "Sunshine Intensity is shown during the day",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(
                        Icons.solar_power_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Sunshine Intensity",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      CustomCurvedContainer(
                        height: 50,
                        width: 128,
                        fillColor: Colors.white,
                        borderColor:
                            chargingRateColor(_controller.currentChargingRate),
                        child: Center(
                          child: Text(
                            _controller.currentChargingRate.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: chargingRateColor(
                                  _controller.currentChargingRate),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _detailsCard({
    required String title,
    required String value,
    required Color bgColor,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        width: size.width * 0.43,
        height: size.width * 0.55,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(26),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: iconBgColor,
              child: Center(
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
