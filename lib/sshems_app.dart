// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SshemsApp extends StatefulWidget {
  const SshemsApp({super.key});

  @override
  State<SshemsApp> createState() => _SshemsAppState();
}

class _SshemsAppState extends State<SshemsApp> {
  double voltage = 230.0;
  double batteryChargeCurrent = 4.5,
      batterydisChargeCurrent = 3.7,
      bateryVoltage = 54.5;
  List<DragAndDropList> _contents = [];
  late Stream<List<double>> voltageStream;
  List<double> valsList =
      []; // AC volatge, DC chargeCur, DC dischargeCur, DC voltage
  bool voltageSupply = true;
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

    _contents = List.generate(4, (index) {
      return DragAndDropList(
        horizontalAlignment: MainAxisAlignment.center,
        // verticalAlignment: CrossAxisAlignment.center,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 3,
            color: Colors.white,
          ),
        ),
        header: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 2),
          child: Text(
            "  ${tiersName[index]}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        children: [
          DragAndDropItem(
            child: Text(
              "   ${tiersCaption[index]}",
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
            canDrag: false,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'SSHEMS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade800,
          title: const Text(
            "Home Energy Manager",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: size.width * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _detailsCard(
                    title: "AC Voltage\nsupplied:",
                    value: '${voltage.toStringAsFixed(2)} V',
                    bgColor: const Color.fromARGB(255, 184, 217, 245),
                    iconData: CupertinoIcons.bolt,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.white,
                  ),
                  _detailsCard(
                    title: "Active power\nusage:",
                    value: '${(voltage * 5.7 / 1000).toStringAsFixed(2)} kW',
                    bgColor: const Color.fromARGB(255, 191, 241, 230),
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
                  _detailsCard(
                    title: "Battery charging\ncurrent:",
                    value: '${batteryChargeCurrent.toStringAsFixed(2)} A',
                    bgColor: const Color.fromARGB(255, 241, 216, 138),
                    iconData: Icons.battery_charging_full_outlined,
                    iconColor: Colors.amber.shade800,
                    iconBgColor: Colors.white,
                  ),
                  _detailsCard(
                    title: "Battery discharging\ncurrent:",
                    value: '${batterydisChargeCurrent.toStringAsFixed(2)} A',
                    bgColor: const Color.fromARGB(255, 250, 196, 192),
                    iconData: CupertinoIcons.battery_25,
                    iconColor: Colors.red.shade700,
                    iconBgColor: const Color.fromARGB(255, 226, 238, 226),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.03),
              _detailsCard(
                title: "Battery\nvoltage:",
                value: '${bateryVoltage.toStringAsFixed(2)} V',
                bgColor: const Color.fromARGB(255, 199, 247, 200),
                iconData: CupertinoIcons.battery_full,
                iconColor: Colors.green,
                iconBgColor: const Color.fromARGB(255, 226, 238, 226),
              ),
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
              SizedBox(
                height: 400,
                child: DragAndDropLists(
                  children: _contents,
                  itemDragOnLongPress: true,
                  listDragOnLongPress: false,
                  onItemReorder: _onItemReorder,
                  onListReorder: _onListReorder,
                ),
              ),
            ],
          ),
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

    return Container(
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
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
      print("Item Reorder");
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
      var movedTiersList = tiersName.removeAt(oldListIndex);
      tiersName.insert(newListIndex, movedTiersList);
      print("List Reorder");
    });
  }
}
