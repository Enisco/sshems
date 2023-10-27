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
  List<DragAndDropList> _contents = [];
  late Stream<double> voltageStream;
  bool voltageSupply = true;
  List tiersName = ["Lights", "Power Outlets", "Power Appliances", "Others"];

  @override
  void initState() {
    super.initState();

    voltageStream = Stream<double>.periodic(
      const Duration(seconds: 1),
      (count) => Random().nextInt(5) + 230.0,
    );

    voltageStream.listen((v) {
      setState(() {
        voltage = v;
      });
    });

    _contents = List.generate(4, (index) {
      return DragAndDropList(
        horizontalAlignment: MainAxisAlignment.center,
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 3, color: Colors.white)),
        header: Text(
          '\n   Tier ${index + 1}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          DragAndDropItem(
            child: Text("   ${tiersName[index]}"),
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        voltageSupply = !voltageSupply;
                      });
                    },
                    child: Container(
                      width: size.width * 0.43,
                      height: size.width * 0.55,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 184, 217, 245),
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
                            backgroundColor: Colors.blue.shade200,
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.bolt,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          voltageSupply == true
                              ? Text(
                                  "Voltage\nsupplied:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700),
                                )
                              : Text(
                                  "No Voltage\nsupplied:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700),
                                ),
                          voltageSupply == true
                              ? Text(
                                  '${voltage.toStringAsFixed(2)} V',
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500),
                                )
                              : const Text(
                                  '0.00 V',
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.43,
                    height: size.width * 0.55,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 191, 241, 230),
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
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 226, 238, 226),
                          child: Center(
                            child: Icon(
                              Icons.electric_meter,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Active power usage:",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700),
                        ),
                        Text(
                          voltageSupply == true
                              ? '${(voltage * 9 / 1000).toStringAsFixed(2)} kW'
                              : "0.124 kW",
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
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
                // color: Colors.amber,
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
