import 'package:flutter/material.dart';

class AnaluticsPage extends StatefulWidget {
  const AnaluticsPage({super.key});

  @override
  State<AnaluticsPage> createState() => _AnaluticsPageState();
}

class _AnaluticsPageState extends State<AnaluticsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
