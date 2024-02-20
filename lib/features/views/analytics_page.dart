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
                      'System Capacity Analysis',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: size.width,
                  
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                
                const SizedBox(height: 30),
                const Row(
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
