// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sshems/features/views/home.dart';

class SshemsApp extends StatefulWidget {
  const SshemsApp({super.key});

  @override
  State<SshemsApp> createState() => _SshemsAppState();
}

class _SshemsAppState extends State<SshemsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SSHEMS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
