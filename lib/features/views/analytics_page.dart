import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:sshems/features/controller/controller.dart';
import 'package:sshems/widgets/curved_container.dart';
import 'package:sshems/widgets/strings_extension.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final _controller = Get.put(DataController());

  final List tiersName = [
    "Lights",
    "Power Outlets",
    "Power Appliances",
    "Others"
  ];
  final List tiersCaption = [
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
                _analyticsCard(),
                const SizedBox(height: 35),
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
                const SizedBox(height: 15),
                _controlButton(
                  title: tiersName[0],
                  caption: tiersCaption[0],
                  commandDigitIndex: 0,
                ),
                _controlButton(
                  title: tiersName[1],
                  caption: tiersCaption[1],
                  commandDigitIndex: 1,
                ),
                _controlButton(
                  title: tiersName[2],
                  caption: tiersCaption[2],
                  commandDigitIndex: 2,
                ),
                _controlButton(
                  title: tiersName[3],
                  caption: tiersCaption[3],
                  commandDigitIndex: 3,
                ),
                const SizedBox(height: 65),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _analyticsCard() {
    Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        width: size.width,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(26),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: SizedBox()),
                RotatedBox(
                  quarterTurns: 3,
                  child: Icon(
                    CupertinoIcons.battery_full,
                    color: Colors.green.shade200,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 4),
                Center(
                  child: Text(
                    '${(_controller.batteryPercentage ?? 0)} %',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  width: 0.3,
                  height: 40,
                  color: Colors.white70,
                ),
                const Expanded(child: SizedBox()),
                Icon(
                  Icons.electric_meter,
                  color: Colors.amber.shade200,
                  size: 30,
                ),
                const SizedBox(width: 4),
                Center(
                  child: Text(
                    (_controller.latestData.apparentPower ?? 0)
                        .toStringAsFixed(0)
                        .toWattsString(),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            _controller.isNightTime == false
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.info_circle,
                        color: Colors.amber,
                        size: 30,
                      ),
                      SizedBox(width: 12),
                      SizedBox(
                        // width: size.width * 0.65,
                        child: Text(
                          "Power analysis will be available \nbetween 9pm and 5am.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : _controller.acVoltsSupplyAvailable == true
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.lightbulb_fill,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            // width: size.width * 0.65,
                            child: Text(
                              "There is power on grid. \nInverter battery is charging.",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.info_circle_fill,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: size.width - 130,
                                child: Text(
                                  'If you continue using the same load of ${_controller.latestData.apparentPower} Watts, your inverter battery will last  for ${_controller.estimatedHours} hrs, ${_controller.estimatedmins} mins.',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required String title,
    required String caption,
    required int commandDigitIndex,
  }) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CustomCurvedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        fillColor: const Color.fromARGB(255, 43, 92, 87),
        width: size.width,
        borderRadius: 8,
        height: 65,
        borderColor: Colors.tealAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  caption,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SlidingSwitch(
              width: 120,
              height: 50,
              value: _controller.commandDigits[commandDigitIndex] == 1
                  ? true
                  : false,
              onChanged: (bool value) {
                _controller.updateButtonState(commandDigitIndex, value);
              },
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              textOff: "OFF",
              textOn: "ON",
              iconOff: CupertinoIcons.lightbulb_slash,
              iconOn: CupertinoIcons.lightbulb_fill,
              contentSize: 22,
              colorOn: Colors.red,
              colorOff: const Color(0xff6682c0),
              background: const Color.fromARGB(255, 201, 247, 231),
              buttonColor: const Color(0xfff7f5f7),
              inactiveColor: const Color(0xff636f7b),
            ),
          ],
        ),
      ),
    );
  }
}
