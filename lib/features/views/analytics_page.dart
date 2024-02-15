import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sshems/features/controller/controller.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final controller = Get.put(DataController());

  List tiersName = ["Lights", "Power Outlets", "Power Appliances", "Others"];
  List tiersCaption = [
    "All lights in the house",
    "Sockets and all power outlets",
    "All power appliances in the house",
    "Other devices on the last line",
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      init: DataController(),
      builder: (context) {
        return const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 25),
                Row(
                  children: [
                    Text(
                      'System Capacity Analysis',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                //
                SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Switch Power Lines',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
