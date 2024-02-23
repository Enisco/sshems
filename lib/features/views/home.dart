import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sshems/features/controller/controller.dart';
import 'package:sshems/features/views/analytics_page.dart';
import 'package:sshems/features/views/readings_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    _controller.refreshLatestData();
    _controller.retrieveSwitchInstruction();
    _controller.checkIfTimeIsNight();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.loading == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return GetBuilder<DataController>(
        init: DataController(),
        builder: (context) {
          return DefaultTabController(
            length: 2,
            initialIndex: _controller.isNightTime ? 1 : 0,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Home Energy Manager',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.teal,
                bottom: TabBar(
                  indicatorColor: Colors.amber.shade800,
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.chart_bar_circle_fill,
                          ),
                          SizedBox(width: 8),
                          Text('Status'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.chart_pie_fill,
                          ),
                          SizedBox(width: 8),
                          Text('Analytics'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 60,
                color: Colors.teal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Power on Grid?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      activeTrackColor: Colors.white,
                      activeColor: Colors.amber,
                      value: _controller.acVoltsSupplyAvailable,
                      onChanged: (val) {
                        _controller.toggleAcSupplyState();
                      },
                    ),
                    const Expanded(child: SizedBox()),
                    const Text(
                      'Night mode?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      activeTrackColor: Colors.white,
                      activeColor: Colors.amber,
                      value: _controller.manualNightSet,
                      onChanged: (val) {
                        _controller.toggleAcNightTimeState(val);
                      },
                    ),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  ReadingsPage(),
                  AnalyticsPage(),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
