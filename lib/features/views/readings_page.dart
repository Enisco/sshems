import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sshems/features/controller/controller.dart';

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
    Size size = MediaQuery.of(context).size;
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
                        'System Status',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _detailsCard(
                        title: "AC Voltage\nsupplied:",
                        value: _controller.acVoltsSupplyAvailable
                            ? '${_controller.acVoltage.toStringAsFixed(2)} V'
                            : "No Supply",
                        bgColor: const Color.fromARGB(255, 184, 217, 245),
                        iconData: CupertinoIcons.bolt,
                        iconColor: Colors.blue,
                        iconBgColor: Colors.white,
                      ),
                      _detailsCard(
                        title: "Active Power\nusage:",
                        value:
                            '${(_controller.activePower / 1000).toStringAsFixed(2)} kW',
                        bgColor: const Color.fromARGB(255, 217, 245, 239),
                        iconData: Icons.electric_meter,
                        iconColor: Colors.teal,
                        iconBgColor: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _controller.isNightTime == true
                          ? _detailsCard(
                              title: "PV charging\ncurrent:",
                              value:
                                  '${_controller.batteryChargeCurrent.toStringAsFixed(2)} A',
                              bgColor: const Color.fromARGB(255, 241, 216, 138),
                              iconData: Icons.battery_charging_full_outlined,
                              iconColor: Colors.amber.shade800,
                              iconBgColor: Colors.white,
                            )
                          : _detailsCard(
                              title: "Battery discharging\ncurrent:",
                              value: _controller.acVoltsSupplyAvailable
                                  ? "---"
                                  : '${_controller.batterydisChargeCurrent.toStringAsFixed(2)} A',
                              bgColor: const Color.fromARGB(255, 250, 196, 192),
                              iconData: CupertinoIcons.battery_25,
                              iconColor: Colors.red.shade700,
                              iconBgColor:
                                  const Color.fromARGB(255, 226, 238, 226),
                            ),
                      _detailsCard(
                        title: "Battery\nvoltage:",
                        value:
                            '${_controller.bateryVoltage.toStringAsFixed(2)} V',
                        bgColor: const Color.fromARGB(255, 199, 247, 200),
                        iconData: CupertinoIcons.battery_full,
                        iconColor: Colors.green,
                        iconBgColor: const Color.fromARGB(255, 226, 238, 226),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          );
        });
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
