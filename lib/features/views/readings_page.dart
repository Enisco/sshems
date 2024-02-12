import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReadingsPage extends StatefulWidget {
  const ReadingsPage({super.key});

  @override
  State<ReadingsPage> createState() => _ReadingsPageState();
}

class _ReadingsPageState extends State<ReadingsPage> {
  double voltage = 230.0;
  double batteryChargeCurrent = 4.5,
      batterydisChargeCurrent = 3.7,
      bateryVoltage = 54.5;
  late Stream<List<double>> voltageStream;
  List<double> valsList =
      []; // AC volatge, DC chargeCur, DC dischargeCur, DC voltage
  bool voltageSupply = true, isNightTime = false;
  List tiersName = ["Lights", "Power Outlets", "Power Appliances", "Others"];
  List tiersCaption = [
    "All lights in the house",
    "Sockets and all power outlets",
    "All power appliances in the house",
    "Other devices on the last line",
  ];

  @override
  void initState() {
    super.initState();

    voltageStream = Stream<List<double>>.periodic(
      const Duration(seconds: 1),
      (count) => [
        Random().nextInt(5) + 230.0,
        Random().nextInt(3) / 3 + 4.5,
        Random().nextInt(3) / 3 + 3.7,
        Random().nextInt(4) / 3.9 + 54.6,
      ],
    );

    voltageStream.listen((vals) {
      setState(() {
        voltage = vals[0];
        batteryChargeCurrent = vals[1];
        batterydisChargeCurrent = vals[2];
        bateryVoltage = vals[3];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: size.width * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailsCard(
                  title: "AC Voltage\nsupplied:",
                  value: voltageSupply
                      ? '${voltage.toStringAsFixed(2)} V'
                      : "No Supply",
                  bgColor: const Color.fromARGB(255, 184, 217, 245),
                  iconData: CupertinoIcons.bolt,
                  iconColor: Colors.blue,
                  iconBgColor: Colors.white,
                ),
                _detailsCard(
                  title: "Active Power\nusage:",
                  value: '${(voltage * 5.7 / 1000).toStringAsFixed(2)} kW',
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
                isNightTime == true
                    ? _detailsCard(
                        title: "PV charging\ncurrent:",
                        value: '${batteryChargeCurrent.toStringAsFixed(2)} A',
                        bgColor: const Color.fromARGB(255, 241, 216, 138),
                        iconData: Icons.battery_charging_full_outlined,
                        iconColor: Colors.amber.shade800,
                        iconBgColor: Colors.white,
                      )
                    : _detailsCard(
                        title: "Battery discharging\ncurrent:",
                        value: voltageSupply
                            ? "---"
                            : '${batterydisChargeCurrent.toStringAsFixed(2)} A',
                        bgColor: const Color.fromARGB(255, 250, 196, 192),
                        iconData: CupertinoIcons.battery_25,
                        iconColor: Colors.red.shade700,
                        iconBgColor: const Color.fromARGB(255, 226, 238, 226),
                      ),
                _detailsCard(
                  title: "Battery\nvoltage:",
                  value: '${bateryVoltage.toStringAsFixed(2)} V',
                  bgColor: const Color.fromARGB(255, 199, 247, 200),
                  iconData: CupertinoIcons.battery_full,
                  iconColor: Colors.green,
                  iconBgColor: const Color.fromARGB(255, 226, 238, 226),
                ),
              ],
            ),
            SizedBox(height: size.width * 0.03),
            const SizedBox(height: 30),
            const Row(
              children: [
                Text(
                  'Order Your Priorities',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
